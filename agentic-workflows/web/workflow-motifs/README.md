# Scientific Archetypes

*   **Phenotype 44 (Validation):** `asm`, `vc`, `benchmarksets`, `dip`, `exclusions`.
    *   These are for variant calling benchmarking.
    *   *Motif* Transition `30 (QC) -> 44 (Validation)` with weight 28. This is like a diagnostic motif (Check quality $\rightarrow$ Validate variants).
*   **Phenotype 26 (BWA Indexing):** `bwt`, `pac`, `ann`, `bwa`, `bio/bwa/index`.
    *   Specific file extensions (`.ann`, `.pac`, `.bwt`) created only during BWA indexing. 
    *   *Motif* Transition `13 (Ref Prep) -> 26 (Indexing)` shows the start of a genome pipeline.
*   **Phenotype 12 (Duplicate Marking):** `picard`, `dedup`, `markduplicates`, `bam`.
    *   Picard MarkDuplicates is a shape for post-alignment processing.
*   **Phenotype 53 & 54 (Imputation):** `quilt`, `stitch`, `mspbwt`, `glimpse`.
    *   Niche but highly coherent. Maybe represent a low-coverage genotyping domain.
    *   *Motif* The link `53 -> 54` (weight 66).

### Population Genetics (81, 86, 90, 93)
Most "active" part of the graph based on the link weights. 

*   **Phenotypes:** All share `angsd`, `sfs`, `dp` (depth), and `population`.
*   **Discovery:** High-traffic Motif.
    *   `81 -> 86` (Weight **340**)
    *   `86 -> 93` (Weight **264**)
    *   `86 -> 90` (Weight **160**)
*   Evolutionary Biology Pipeline. Steps in 81 (Mapping/QC) feed into 86 (Filtering/ANGSD), which then fork into 90 and 93 (SFS and Diversity statistics). 

### Interesting Outliers
*   Phenotype 100: `ncit`, `signatures`, `chromosomes`, `vocab`.
    *   Maybe clinical oncology reporting. It’s distinct from the research phenotypes because it uses medical vocabularies (`ncit`).
*   Phenotype 0: `altair`, `vega`, `scipy`, `pysam`.
    *  Maybe visualization or dashboard archetype. 