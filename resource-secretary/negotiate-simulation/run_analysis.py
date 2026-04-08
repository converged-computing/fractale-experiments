import os
import json
import argparse
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path
from scipy.stats import chi2_contingency, pointbiserialr, ttest_ind
from rich.console import Console
from rich.table import Table
from rich.progress import Progress
import statsmodels.api as sm

console = Console()
palette = {"hpc": "#4B0082", "cloud": "#0055CC", "standalone": "#00BFA6"}

def parse_args():
    parser = argparse.ArgumentParser(description="Scientific Negotiate Fleet Analytics")
    parser.add_argument("--input-dir", type=str, default="./data")
    parser.add_argument("--output-dir", type=str, default="./results")
    parser.add_argument("--save-data", type=str, default="negotiation-simulation.csv", help="Save flattened data (csv)")
    return parser.parse_args()

def format_calls_data(worker_id, prompt_id, trace, verdict, archetype):
    """
    We want to look at call categories and figure out, within the space of required
    calls (meaning the agent needed to call these categories)
    1. If agents preferred calls over others within a category.
    2. How much of each space is explored, and total space explorted
    3. If number of calls is associated with outcomes (plot)
    """    
    category_rows = []
    uid = f"worker_{worker_id}_prompt_{prompt_id}"

    # unnecessary calls? These are actual tools provisioned for each category
    tools = set()
    for cat_info in trace['categories'].values():
        for tool in cat_info.get('actual_tools', []):
            tools.add(tool)

    # Check actual calls for any we don't need
    unnecessary_calls = []
    actual_calls = trace['actual_calls'] 
    
    # Note that some calls here are not associated obviously with a category,
    # we will look at data plots after and determine.
    for call in actual_calls:
        func_name = call.split(".")[-1]
        if func_name not in tools:        
            unnecessary_calls.append(call)
    unnecessary = "|".join(unnecessary_calls)
    
    # this is for tool categories, (count satisfied) / (count required)
    score = trace['score']
    
    for cat_name, info in trace['categories'].items():
        row = {
            "uid": uid,
            "worker_id": worker_id,
            "prompt_id": prompt_id, 
            "archetype": archetype,
            "score": score,
            "category": cat_name,
            "cat_satisfied": info['satisfied'],
            "num_tools_called": info["number_called"],
            "total_actual_calls": info["actual_calls"],
            "pct_explored": info["percentage_calls_explored"],
            "potential_tools_count": len(info['potential_tools']),
            "tools_used": "|".join(info['actual_tools']),
            "possibly_unnecessary": unnecessary,
        }
        row.update(verdict)
        category_rows.append(row)
    
    return category_rows


def run_logistic_regression_analysis(df):
    categories = ['has_software', 'has_compute', 'has_parallel', 
                  'has_storage', 'has_network', 'has_temporal', 'has_container']
    
    # Create dummy variables for Archetype (drops one to avoid multi-collinearity)
    X = pd.get_dummies(df[['archetype'] + categories], columns=['archetype'], drop_first=True)
    X = sm.add_constant(X.astype(float)) # Add intercept
    y = df['is_correct'].astype(float)

    # 2. Fit the model
    model = sm.Logit(y, X).fit(disp=0)
    
    # 3. Extract results for plotting
    results_df = pd.DataFrame({
        'Feature': model.params.index,
        'Coefficient': model.params.values,
        'P-Value': model.pvalues.values,
        'Conf_Lower': model.conf_int()[0].values,
        'Conf_Upper': model.conf_int()[1].values
    }).set_index('Feature')

    return results_df

def extract_features(raw, filename):
    """
    Extracts deep behavioral and logic features from a single result JSON.
    Consolidates Complexity, Tool Calls, Error Types, and Binary Categories.
    """
    # Get the prompt id (result)
    prompt_id = int(os.path.basename(filename).replace('result-', '').replace('.json', ''))
    # Yes, this does assume our organization of data/<experiment>/<worker>/result-<prompt>.json
    experiment = filename.parts[1]
    
    # Stuff about the worker!
    worker_truth = raw['ground_truth']
    node_count = 1
    archetype = worker_truth['metadata']['archetype']

    # I want these to fail if we are missing something
    prompt = raw['prompt']
    worker_id = raw['worker_id']
    uid = f"experiment_{experiment}_worker_{worker_id}_prompt_{prompt_id}"
    worker_uid = f"worker_{worker_id}_experiment_{experiment}"
    req_logic = raw['requirement_logic']
    audit = raw['audit']
    report = audit['report']
    verdict = audit['verdict']
    trace = report['trace']
    reasoning = report['reasoning']
    calls = report['calls']
    missing = report['missing_requirements']
    specificity_index = raw["specificity_index"]
    complexity = sum(len(v) if isinstance(v, dict) else 1 for v in req_logic.values())
    
    # Let's make a binary 0/1 for this to make my life easy
    is_correct = 1 if verdict.get("is_correct") else 0

    # This is for calls df
    calls_rows = format_calls_data(worker_id, prompt_id, trace, verdict, archetype)
    
    # specificity_index + count of nested key-value pairs in logic
    required_categories = sum(len(v) if isinstance(v, dict) else 1 for v in req_logic.values())
    
    # Type 1 vs. type 2 error (I always mess these up...)
    # Type 1: False Positive (Truth=INCOMPATIBLE, Agent=COMPATIBLE or BUSY)
    # Type 2: False Negative (Truth=COMPATIBLE, Agent=INCOMPATIBLE)
    actual_v = verdict.get("actual_verdict", "UNKNOWN")
    agent_v = verdict.get("agent_verdict", "UNKNOWN")
    if "compute" in req_logic and req_logic['compute']['unit'] == "nodes":
        node_count = req_logic['compute']['count']

    satisfied =  ["COMPATIBLE", "BUSY", "READY"]
    type_1_error = 1 if (actual_v == "INCOMPATIBLE" and agent_v in satisfied) else 0
    type_2_error = 1 if (actual_v in satisfied and agent_v == "INCOMPATIBLE") else 0
    is_compatible = actual_v in ['COMPATIBLE', 'READY', 'BUSY']

    # We create binary indicators for every category
    features = {
        "uid": uid,
        "worker_id": worker_id,
        "worker_gid": worker_uid,
        "prompt_id": prompt_id, 
        "prompt": prompt,
        "archetype": archetype,
        "specificity": specificity_index,
        "reasoning": reasoning,
        "complexity": complexity,
        "is_correct": is_correct,
        "experiment": experiment,
        "is_compatible": is_compatible,
        "type_1_error": type_1_error,
        "type_2_error": type_2_error,
        "actual_verdict": actual_v,
        "agent_verdict": agent_v,
        "missing": "|".join(missing),
        "software_name": req_logic['software']['name'],
        "gpu_count": req_logic.get("compute", {}).get('gpus') or 0,
        "node_count": node_count,
        "low_latency_req": "with support for low latency MPI" in prompt,
        "mpi_req": 1 if req_logic.get("parallel", {}).get("mpi", False) else 0,
        "gpu_logic": req_logic.get("compute", {}).get("gpu_requires", "").strip(),
    }
    features.update(verdict)

    # Extract all categories as independent binary variables
    possible_categories = ['software', 'compute', 'parallel', 'storage', 'network', 'temporal', 'container']
    for cat in possible_categories:
        features[f"has_{cat}"] = 1 if cat in req_logic else 0

    return features, calls_rows

def find_missing_runs(df):
    """
    Figure out if we are missing a run
    I wrote this because we had 9999 results out of 10K!!
    """
    found = {}
    for wid in df.worker_id.unique():
        found[wid] = set()
        for pid in df[df.worker_id == wid].prompt_id.unique():
            found[wid].add(pid)
        # I think my apartment likely lost Gemini API connectivity
        # This is an example that the system is imperfect.
        # Worker id 60 is missing a result:
        # [79]
        # We can rerun for it.
        if len(found[wid]) != 100:
            missing = [x for x in range(100) if x not in found[wid]]
            print(f'Worker id {wid} is missing a result:')
            print(missing)


def plot_archetype_category_heatmap(df, out_path):
    categories = ['has_software', 'has_compute', 'has_parallel', 
                  'has_storage', 'has_network', 'has_temporal', 'has_container']
    
    # Calculate accuracy for each category within each archetype
    heatmap_data = []
    for arch in df['archetype'].unique():
        arch_sub = df[df['archetype'] == arch]
        for cat in categories:
            # Only look at cases where the category was actually present
            acc = arch_sub[arch_sub[cat] == 1]['is_correct'].mean()
            heatmap_data.append({'Archetype': arch, 'Category': cat.replace('has_', ''), 'Accuracy': acc})
    
    h_df = pd.DataFrame(heatmap_data).pivot(index='Category', columns='Archetype', values='Accuracy')
    
    plt.figure(figsize=(10, 7))
    sns.heatmap(h_df, annot=True, cmap="RdYlGn", fmt=".2f", cbar_kws={'label': 'Mean Accuracy'})
    plt.title("Accuracy by Category and Archetype")
    plt.savefig(out_path / "archetype_category_heatmap.png")
    plt.close()

def get_archetype_feature_influence(df):
    categories = ['has_software', 'has_compute', 'has_parallel', 
                  'has_storage', 'has_network', 'has_temporal', 'has_container']
    
    all_results = []
    
    for arch in df['archetype'].unique():
        sub_df = df[df['archetype'] == arch]
        
        # Ensure we have enough variance to run regression
        X = sub_df[categories].astype(float)
        y = sub_df['is_correct'].astype(float)
        
        # Drop columns with zero variance (e.g., if HPC never has 'temporal')
        X = X.loc[:, (X != X.iloc[0]).any()]
        X = sm.add_constant(X)
        
        try:
            model = sm.Logit(y, X).fit(disp=0)
            
            res = pd.DataFrame({
                'Feature': model.params.index,
                'Coefficient': model.params.values,
                'P-Value': model.pvalues.values,
                'Conf_Lower': model.conf_int()[0].values,
                'Conf_Upper': model.conf_int()[1].values
            }).query("Feature != 'const'")
            
            res['Archetype'] = arch
            all_results.append(res)
        except Exception as e:
            print(f"Skipping {arch} due to error: {e}")
            
    return pd.concat(all_results)


def plot_feature_influence(results_df, out_path):
    plt.figure(figsize=(10, 8))
    results_df = results_df.sort_values('Coefficient')
    
    # Colors: Red for significant negative impact, Green for significant positive, Gray for neutral
    colors = []
    for _, row in results_df.iterrows():
        if row['P-Value'] < 0.05:
            colors.append('#d63031' if row['Coefficient'] < 0 else '#27ae60')
        else:
            colors.append('#b2bec3')

    # Plotting error bars (95% CI)
    plt.errorbar(results_df['Coefficient'], range(len(results_df)), 
                 xerr=[results_df['Coefficient'] - results_df['Conf_Lower'], 
                       results_df['Conf_Upper'] - results_df['Coefficient']],
                 fmt='o', color='black', capsize=5)
    
    # Plotting bars
    plt.barh(range(len(results_df)), results_df['Coefficient'], color=colors, alpha=0.6)
    
    plt.axvline(0, color='black', linestyle='--', linewidth=1)
    plt.yticks(range(len(results_df)), [x.replace('has_', '').replace('_', ' ') for x in results_df.index])
    plt.xlabel("Impact on Log-Odds of Accuracy (Coefficient)")
    plt.title("Feature Importance: Which Requirements Predict Agent Failure?")
    plt.grid(axis='x', linestyle=':', alpha=0.7)
    
    plt.tight_layout()
    plt.savefig(out_path / "feature_influence_forest_plot.png")
    plt.savefig(out_path / "feature_influence_forest_plot.svg")
    plt.close()


def plot_archetype_feature_influence(results_df, out_path):
    # Clean up feature names for the plot
    results_df['Feature'] = results_df['Feature'].str.replace('has_', '')
    
    # Create the plot
    plt.figure(figsize=(12, 10))
    sns.set_style("whitegrid")
    
    # use a standard bar plot but manually add the error bars
    # Sort features by the average coefficient across archetypes for a clean look
    order = results_df.groupby('Feature')['Coefficient'].mean().sort_values().index    
    ax = sns.barplot(
        data=results_df, 
        y='Feature', x='Coefficient', hue='Archetype',
        order=order, palette=palette, alpha=0.7
    )
    
    plt.axvline(0, color='black', linestyle='--', linewidth=1.2)    
    ax.set_title("Feature Importance by Archetype: Predictors of Agent Failure", fontsize=24)
    ax.set_xlabel("Impact on Log-Odds of Accuracy (Coefficient)", fontsize=20)
    ax.set_ylabel("Requirement Category", fontsize=20)
    plt.legend(title="Archetype", loc="lower right")
    plt.tight_layout()
    plt.savefig(out_path / "feature_influence_by_archetype.svg")    
    plt.savefig(out_path / "feature_influence_by_archetype.png")
    plt.close()
    
def plot_confusion_matrix(df, out_path):
    """
    In [1]: df.actual_verdict.unique()
    Out[1]: array(['INCOMPATIBLE', 'COMPATIBLE', 'READY'], dtype=object)

    In [2]: df.agent_verdict.unique()
    Out[2]: array(['INCOMPATIBLE', 'BUSY', 'UNKNOWN', 'READY'], dtype=object)

    We need to combine BUSY and READY into COMPATIBLE, because we did not well
    define what "BUSY" means. We are confident BUSY and READY == compatible.
    """
    merge_df = df.copy()
    
    # Map BUSY/READY/COMPATIBLE to a single label: COMPATIBLE
    # Map everything else (except UNKNOWN) to INCOMPATIBLE
    target_map = {"BUSY": "COMPATIBLE", "READY": "COMPATIBLE", "COMPATIBLE": "COMPATIBLE"}
    
    merge_df['actual_verdict'] = merge_df['actual_verdict'].replace(target_map)
    merge_df['agent_verdict'] = merge_df['agent_verdict'].replace(target_map)

    # Define the labels for the axes. 
    row_labels = ["COMPATIBLE", "INCOMPATIBLE"]
    col_labels = ["COMPATIBLE", "INCOMPATIBLE"]    
    if "UNKNOWN" in merge_df['agent_verdict'].unique():
        col_labels.append("UNKNOWN")

    # 2. Calculate Raw Counts First
    confusion_counts = pd.crosstab(
        merge_df['actual_verdict'], 
        merge_df['agent_verdict']
    ).reindex(index=row_labels, columns=col_labels, fill_value=0)
    
    total_n = confusion_counts.values.sum()
    
    # Normalizing by ROW (Actual Verdict)
    confusion_pct = confusion_counts.div(confusion_counts.sum(axis=1), axis=0)

    # total accuracy - sum of the diagonal where labels match / Total N)
    # we only sum the labels that exist in both actual and agent
    correct_matches = (merge_df['actual_verdict'] == merge_df['agent_verdict']).sum()
    total_accuracy = correct_matches / total_n
    annot_labels = [
        [f"{pct:.2f}\n(N={count})" for pct, count in zip(row_pct, row_count)]
        for row_pct, row_count in zip(confusion_pct.values, confusion_counts.values)
    ]

    print(total_n)
    
    # if total_n != 10000:
    #    raise ValueError("This is supposed to be 10K")

    plt.figure(figsize=(9, 7))    
    ax = sns.heatmap(
        confusion_pct, 
        annot=annot_labels, 
        fmt="", 
        cmap="YlGnBu", 
        cbar_kws={'label': f'Recall (Proportion by Row, Total N=10K)'}
    )

    ax.set_title(f"Actual vs. Agent Verdict\nTotal Accuracy: {total_accuracy:.2%}", fontsize=18, pad=20)
    ax.set_xlabel("Agent Verdict", fontsize=14, labelpad=10)
    ax.set_ylabel("Actual Verdict", fontsize=14, labelpad=10)    
    plt.tight_layout()
    plt.savefig(out_path / "verdict_confusion_matrix.png")
    plt.savefig(out_path / "verdict_confusion_matrix.svg")
    plt.savefig(out_path / "verdict_confusion_matrix.pdf")
    plt.close()

def generate_visualizations(df, calls_df, output_dir):
    
    out_path = Path(output_dir)
    out_path.mkdir(parents=True, exist_ok=True)
    sns.set_theme(style="whitegrid", context="paper", font_scale=1.8)

    # Verdict confusion matrix
    plot_confusion_matrix(df, out_path)
        
    # Accuracy by complexity and simplicity
    # This shows there is something about HPC that makes it harder for the agent. We need to determine what.
    plt.figure(figsize=(8, 5))
    sns.lineplot(data=df, x="complexity", y="is_correct", marker='o', errorbar=('ci', 95), hue="archetype", palette=palette)
    plt.title("Accuracy vs. Constraint Complexity")
    plt.ylabel("% Agent Responses Correct")
    plt.savefig(out_path / "accuracy_complexity_by_archetype.png")
    plt.savefig(out_path / "accuracy_complexity_by_archetype.svg")
    plt.close()

    plt.figure(figsize=(8, 5))
    sns.lineplot(data=df, x="specificity", y="is_correct", marker='o', errorbar=('ci', 95), hue="archetype", palette=palette)
    plt.title("Accuracy vs. Constraint Specificity")
    plt.ylabel("% Agent Responses Correct")
    plt.savefig(out_path / "accuracy_specificty_by_archetype.png")
    plt.savefig(out_path / "accuracy_specificty_by_archetype.svg")
    plt.close()

    #results_df = run_logistic_regression_analysis(df)
    #for index in ['archetype_hpc', 'archetype_standalone']:
    #    results_df = results_df.drop(index)
    #plot_feature_influence(results_df, out_path)
    plot_archetype_category_heatmap(df, out_path)
    
    # This one breaks down by archetype, which matters
    results_df = get_archetype_feature_influence(df)
    plot_archetype_feature_influence(results_df, out_path)

    # This is how to figure out WHY we called incompatible compatible
    incompat = df[df.actual_verdict == "INCOMPATIBLE"]
    subset= incompat[incompat.agent_verdict.isin(['COMPATIBLE', "BUSY", "READY"])]
    counts = {}
    for miss in subset.missing.tolist():
        miss = miss.split('|')
        for m in miss:
            category, rest = m.split(':', 1)
            category = category.strip()
        if category not in counts:
            counts[category] = 0
        counts[category] += 1
    
    print('AGENT CALLED INCOMPAT BUT NOT. Should sum to total in confusion.')
    list(counts.values())
    sum(list(counts.values()))

    # This is how to figure out WHY we called incompatible compatible
    compat = df[df.actual_verdict.isin(['COMPATIBLE', "BUSY", "READY"])]
    subset= compat[compat.agent_verdict == "INCOMPATIBLE"]
    counts = {}
    for miss in subset.missing.tolist():
        if not miss:
            continue
        miss = miss.split('|')
        for m in miss:
            category, rest = m.split(':', 1)
            category = category.strip()
        if category not in counts:
            counts[category] = 0
        counts[category] += 1
    
    print('AGENT CALLED COMPAT BUT NOT. Should sum to total in confusion.')
    list(counts.values())
    sum(list(counts.values()))

    print('TODO get means and sd for node and gpu counts.')
    print('aldo need to report on unknowns')
    import IPython
    IPython.embed()

    # Requirements - this was for me to check on distribution of values of things
    # fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    # sns.countplot(data=df, x="node_count", ax=axes[0, 0], hue="archetype", palette=palette, legend=False)
    # top_sw = df[df['software_name'] != 'none']['software_name'].value_counts().nlargest(10).reset_index()
    # sns.barplot(data=top_sw, x='count', y='software_name', ax=axes[0, 0], hue='software_name', palette="Blues_r", legend=False)
    # sns.countplot(data=df, x="gpu_count", ax=axes[0, 1], hue="gpu_count", palette="Greens", legend=False)
    # logic_counts = df['gpu_logic'].value_counts()
    # axes[1, 0].pie(logic_counts, labels=logic_counts.index, autopct='%1.1f%%', colors=sns.color_palette("pastel"))
    # sns.countplot(data=df, x="mpi_req", ax=axes[1, 1], hue="mpi_req", palette="Oranges", legend=False)
    # plt.tight_layout(); plt.savefig(out_path / "requirement_landscape.png")
    # plt.show()

    # tool calls vs. accuracy
    g = sns.lmplot(
        data=calls_df, 
        x="score", 
        y="is_correct", 
        x_estimator=np.mean, 
        hue="archetype", 
        palette=palette,
        # God damn
        height=5,    # Height of the plot
        aspect=2.0   # Aspect ratio (Width = height * aspect)
    )

    g.set(xlim=(0, 1), ylim=(0, 1.1)) 
    g.set_axis_labels("Tool Call Score", "% Agent Responses Correct", fontsize=18)
    g.fig.suptitle("Tool Call Count vs. Correctness", fontsize=20)
    g.set_xticklabels(size=14)
    g.set_yticklabels(size=14)
    g.fig.subplots_adjust(top=0.9)

    plt.savefig(out_path / "tool_call_accuracy.png", bbox_inches='tight')
    plt.savefig(out_path / "tool_call_accuracy.svg", bbox_inches='tight')
    plt.close()

    # We aren't including this, but interesting.
    g = sns.lmplot(
        data=calls_df, 
        x="pct_explored", 
        y="is_correct", 
        x_estimator=np.mean, 
        hue="archetype", 
        palette=palette,
        # God damn
        height=5,    # Height of the plot
        aspect=2.0   # Aspect ratio (Width = height * aspect)
    )

    g.set(xlim=(0, 1), ylim=(0, 1.1)) 
    g.set_axis_labels("Tool Call Score", "% Agent Responses Correct", fontsize=18)
    g.fig.suptitle("Tool Call Count vs. Correctness", fontsize=20)
    g.set_xticklabels(size=14)
    g.set_yticklabels(size=14)
    g.fig.subplots_adjust(top=0.9)

    plt.savefig(out_path / "tool_call_accuracy_pct_explored.png", bbox_inches='tight')
    plt.savefig(out_path / "tool_call_accuracy_pct_explored.svg", bbox_inches='tight')
    plt.close()

    # False positives/negatives, we can report in text
    error_sum = df[["type_1_error", "type_2_error"]].sum().reset_index()
    error_sum.columns = ["Error Type", "Count"]
    error_sum["Error Type"] = error_sum["Error Type"].replace({"type_1_error": "False Positive (FP)", "type_2_error": "False Negative (FN)"})
    plt.figure(figsize=(8, 5))
    sns.barplot(data=error_sum, x="Error Type", y="Count", hue="Error Type", palette="Reds_r", legend=False)
    plt.title("Fig 9: Distribution of Failure Modes")
    plt.savefig(out_path / "error_distribution.png")

    # GPU and/or
    subset = df[df.gpu_logic != '']
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(16, 6))

    sns.barplot(
        data=subset, 
        x="gpu_logic", 
        y="is_correct", 
        hue="gpu_logic", 
        palette='Set1', 
        ax=ax1, 
        legend=False
    )
    ax1.set_title("Agent Accuracy by GPU Logic", fontsize=14)
    ax1.set_ylabel("% Agent Responses Correct")
    ax1.set_xlabel("GPU Request Logic (AND/OR)")

    sns.barplot(
        data=subset, 
        x="gpu_logic", 
        y="is_compatible", 
        hue="gpu_logic", 
        palette="Set1", 
        ax=ax2, 
        legend=False
    )
    ax2.set_title("System Compatibility by GPU Logic", fontsize=14)
    ax2.set_ylabel("% Proposal Matches (Satisfiability)")
    ax2.set_xlabel("GPU Request Logic (AND/OR)")
    plt.tight_layout()
    plt.savefig(out_path / "combined_gpu_logic_impact.png", bbox_inches='tight')
    plt.close()

def print_paper_statistics(df):
    print('stats')
    import IPython
    IPython.embed()

    perf_table = Table(title="[bold cyan]Descriptive Statistics[/bold cyan]")
    perf_table.add_column("Metric", style="white")
    perf_table.add_column("Mean", justify="right")
    perf_table.add_column("Std Dev", justify="right")
    perf_table.add_column("N", justify="right")

    for label, col in [("Accuracy", "is_correct"), ("Calls", "actual_calls"), ("Complexity", "complexity")]:
        perf_table.add_row(label, f"{df[col].mean():.3f}", f"{df[col].std():.3f}", str(len(df)))
    console.print(perf_table)

    # Create contingency table of Style (0,1,2) vs. Correctness (0,1)
    style_ct = pd.crosstab(df['specificity'], df['is_correct'])
    
    # Perform Chi-Square Test
    chi2, p_style, dof, ex = chi2_contingency(style_ct)
    
    # Calculate means for the paper summary
    style_accs = df.groupby('specificity')['is_correct'].mean()
    
    console.print("\n[bold cyan]Prompt Style Statistical Summary (Paper-Ready):[/bold cyan]")
    if p_style < 0.05:
        result_text = (
            f"A Chi-square test of independence revealed a significant effect of prompt style on agent accuracy "
            f"(X2({dof}) = {chi2:.2f}, p = {p_style:.4f}). Accuracy varied across styles: "
            f"Style 0 (M={style_accs.get(0, 0):.2f}), Style 1 (M={style_accs.get(1, 0):.2f}), "
            f"and Style 2 (M={style_accs.get(2, 0):.2f})."
        )
    else:
        result_text = (
            f"A Chi-square test of independence indicated no significant difference in agent accuracy across "
            f"the three prompt styles (X2({dof}) = {chi2:.2f}, p = {p_style:.4f}, ns). "
            f"Performance remained consistent regardless of phrasing (Overall M={df['is_correct'].mean():.2f})."
        )
    
    console.print(f"[white]{result_text}[/white]\n")

    # 2. Significance Tests
    stats_table = Table(title="[bold green]Hypothesis Testing (P-Values)[/bold green]")
    stats_table.add_column("Relationship", style="white")
    stats_table.add_column("Method", style="dim")
    stats_table.add_column("P-Value", justify="right", style="bold yellow")
    stats_table.add_column("Sig.", justify="center")

    # Complexity vs Accuracy
    _, p_comp = pointbiserialr(df['complexity'], df['is_correct'])
    stats_table.add_row("Complexity -> Accuracy", "Point-Biserial", f"{p_comp:.4f}", "*" if p_comp < 0.05 else "")

    # GPU Logic vs Accuracy
    ct = pd.crosstab(df['gpu_logic'], df['is_correct'])
    _, p_logic, _, _ = chi2_contingency(ct)
    stats_table.add_row("AND/OR Logic -> Accuracy", "Chi-Square", f"{p_logic:.4f}", "*" if p_logic < 0.05 else "")

    # Tool Calls: Correct vs Incorrect
    grp1 = df[df['is_correct'] == 1]['actual_calls']
    grp2 = df[df['is_correct'] == 0]['actual_calls']
    _, p_ttest = ttest_ind(grp1, grp2)
    stats_table.add_row("Correct vs Incorrect Call Vol", "T-Test", f"{p_ttest:.4f}", "*" if p_ttest < 0.05 else "")

    console.print(stats_table)
    
def main():
    args = parse_args()
    data_list = []
    calls_list = []

    # subdirectory is the experiment
    files = []
    for experiment in os.listdir(args.input_dir):
        print(experiment)
            
        files = list(Path(os.path.join(args.input_dir, experiment)).rglob("result-*.json"))
        with Progress() as progress:
            task = progress.add_task("[cyan]Parsing Fleet Data...", total=len(files))
            for f in files:
                with open(f) as j: 
                    features, calls_rows = extract_features(json.load(j), f)
                data_list.append(features)
                calls_list += calls_rows
                progress.update(task, advance=1)

    df = pd.DataFrame(data_list)
    calls_df = pd.DataFrame(calls_list)
    output_dir = os.path.join(args.output_dir, experiment)
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    if args.save_data: 
        save_file = os.path.join(output_dir, args.save_data)
        df.to_csv(save_file)
        calls_df.to_csv(save_file.replace('.csv', '-calls.csv'))

    generate_visualizations(df, calls_df, output_dir)
    print_paper_statistics(df, calls_df)
    print_stuff(df, calls_df)
    console.print(f"\n[bold green]Success: 11 Figures generated in {args.output_dir}[/bold green]")


def print_stuff(df, calls_df):
    """
    Print more stuff to look at later.
    """
    # Archetype breakdown
    print("Archetypes:")
    console.print(df.archetype.value_counts())
    print("Broken down")
    df.groupby('archetype')['worker_id'].agg(['nunique', 'count'])

if __name__ == "__main__":
    main()
