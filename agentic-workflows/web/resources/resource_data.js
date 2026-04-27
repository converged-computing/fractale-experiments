const vizData = {
  "nodes": [
    {
      "id": "all",
      "label": "all",
      "type": "rule"
    },
    {
      "id": "slope_too_steep",
      "label": "slope_too_steep",
      "type": "rule"
    },
    {
      "id": "suitable_land_cover",
      "label": "suitable_land_cover",
      "type": "rule"
    },
    {
      "id": "resample_same_resolution",
      "label": "resample_same_resolution",
      "type": "rule"
    },
    {
      "id": "technical_mask",
      "label": "technical_mask",
      "type": "rule"
    },
    {
      "id": "area_potential",
      "label": "area_potential",
      "type": "rule"
    },
    {
      "id": "cutout_landcover",
      "label": "cutout_landcover",
      "type": "rule"
    },
    {
      "id": "cutout_landseamask",
      "label": "cutout_landseamask",
      "type": "rule"
    },
    {
      "id": "cutout_settlement",
      "label": "cutout_settlement",
      "type": "rule"
    },
    {
      "id": "download_cutout_slope",
      "label": "download_cutout_slope",
      "type": "rule"
    },
    {
      "id": "download_cutout_bathymetry",
      "label": "download_cutout_bathymetry",
      "type": "rule"
    },
    {
      "id": "download_wdpa",
      "label": "download_wdpa",
      "type": "rule"
    },
    {
      "id": "unzip_wdpa",
      "label": "unzip_wdpa",
      "type": "rule"
    },
    {
      "id": "download_globcover",
      "label": "download_globcover",
      "type": "rule"
    },
    {
      "id": "unzip_globcover",
      "label": "unzip_globcover",
      "type": "rule"
    },
    {
      "id": "download_ghsl",
      "label": "download_ghsl",
      "type": "rule"
    },
    {
      "id": "unzip_ghsl",
      "label": "unzip_ghsl",
      "type": "rule"
    },
    {
      "id": "get_genome",
      "label": "get_genome",
      "type": "rule"
    },
    {
      "id": "validate_genome",
      "label": "validate_genome",
      "type": "rule"
    },
    {
      "id": "simulate_reads",
      "label": "simulate_reads",
      "type": "rule"
    },
    {
      "id": "fastqc",
      "label": "fastqc",
      "type": "rule"
    },
    {
      "id": "multiqc",
      "label": "multiqc",
      "type": "rule"
    },
    {
      "id": "predict_genes",
      "label": "predict_genes",
      "type": "rule"
    },
    {
      "id": "run_spades",
      "label": "run_spades",
      "type": "rule"
    },
    {
      "id": "rename_contigs",
      "label": "rename_contigs",
      "type": "rule"
    },
    {
      "id": "calculate_contigs_stats",
      "label": "calculate_contigs_stats",
      "type": "rule"
    },
    {
      "id": "align_reads_to_final_contigs",
      "label": "align_reads_to_final_contigs",
      "type": "rule"
    },
    {
      "id": "pileup_contigs_sample",
      "label": "pileup_contigs_sample",
      "type": "rule"
    },
    {
      "id": "create_bam_index",
      "label": "create_bam_index",
      "type": "rule"
    },
    {
      "id": "run_megahit",
      "label": "run_megahit",
      "type": "rule"
    },
    {
      "id": "init_pre_assembly_processing",
      "label": "init_pre_assembly_processing",
      "type": "rule"
    },
    {
      "id": "error_correction",
      "label": "error_correction",
      "type": "rule"
    },
    {
      "id": "merge_pairs",
      "label": "merge_pairs",
      "type": "rule"
    },
    {
      "id": "kallisto_quant_to_gfold_input",
      "label": "kallisto_quant_to_gfold_input",
      "type": "rule"
    },
    {
      "id": "gfold",
      "label": "gfold",
      "type": "rule"
    },
    {
      "id": "clean_and_sort_gfold",
      "label": "clean_and_sort_gfold",
      "type": "rule"
    },
    {
      "id": "gfold_datavzrd",
      "label": "gfold_datavzrd",
      "type": "rule"
    },
    {
      "id": "spia_datavzrd",
      "label": "spia_datavzrd",
      "type": "rule"
    },
    {
      "id": "gseapy",
      "label": "gseapy",
      "type": "rule"
    },
    {
      "id": "annotate_variants",
      "label": "annotate_variants",
      "type": "rule"
    },
    {
      "id": "call_variants",
      "label": "call_variants",
      "type": "rule"
    },
    {
      "id": "combine_calls",
      "label": "combine_calls",
      "type": "rule"
    },
    {
      "id": "genotype_variants",
      "label": "genotype_variants",
      "type": "rule"
    },
    {
      "id": "merge_variants",
      "label": "merge_variants",
      "type": "rule"
    },
    {
      "id": "genome_faidx",
      "label": "genome_faidx",
      "type": "rule"
    },
    {
      "id": "get_known_variation",
      "label": "get_known_variation",
      "type": "rule"
    },
    {
      "id": "tabix_known_variants",
      "label": "tabix_known_variants",
      "type": "rule"
    },
    {
      "id": "bwa_index",
      "label": "bwa_index",
      "type": "rule"
    },
    {
      "id": "get_vep_cache",
      "label": "get_vep_cache",
      "type": "rule"
    },
    {
      "id": "get_vep_plugins",
      "label": "get_vep_plugins",
      "type": "rule"
    },
    {
      "id": "samtools_stats",
      "label": "samtools_stats",
      "type": "rule"
    },
    {
      "id": "trim_reads_se",
      "label": "trim_reads_se",
      "type": "rule"
    },
    {
      "id": "trim_reads_pe",
      "label": "trim_reads_pe",
      "type": "rule"
    },
    {
      "id": "map_reads",
      "label": "map_reads",
      "type": "rule"
    },
    {
      "id": "mark_duplicates",
      "label": "mark_duplicates",
      "type": "rule"
    },
    {
      "id": "recalibrate_base_qualities",
      "label": "recalibrate_base_qualities",
      "type": "rule"
    },
    {
      "id": "samtools_index",
      "label": "samtools_index",
      "type": "rule"
    },
    {
      "id": "select_calls",
      "label": "select_calls",
      "type": "rule"
    },
    {
      "id": "hard_filter_calls",
      "label": "hard_filter_calls",
      "type": "rule"
    },
    {
      "id": "recalibrate_calls",
      "label": "recalibrate_calls",
      "type": "rule"
    },
    {
      "id": "merge_calls",
      "label": "merge_calls",
      "type": "rule"
    },
    {
      "id": "glori_trim_dedup",
      "label": "glori_trim_dedup",
      "type": "rule"
    },
    {
      "id": "glori_uncompress_fastq",
      "label": "glori_uncompress_fastq",
      "type": "rule"
    },
    {
      "id": "glori_trim_umi",
      "label": "glori_trim_umi",
      "type": "rule"
    },
    {
      "id": "trimgalore",
      "label": "trimgalore",
      "type": "rule"
    },
    {
      "id": "aggregate_capacity",
      "label": "aggregate_capacity",
      "type": "rule"
    },
    {
      "id": "proxy_rooftop_pv",
      "label": "proxy_rooftop_pv",
      "type": "rule"
    },
    {
      "id": "impute_adjustment_solar",
      "label": "impute_adjustment_solar",
      "type": "rule"
    },
    {
      "id": "prepare_hydropower",
      "label": "prepare_hydropower",
      "type": "rule"
    },
    {
      "id": "prepare_large_solar",
      "label": "prepare_large_solar",
      "type": "rule"
    },
    {
      "id": "prepare_bioenergy",
      "label": "prepare_bioenergy",
      "type": "rule"
    },
    {
      "id": "prepare_fossil",
      "label": "prepare_fossil",
      "type": "rule"
    },
    {
      "id": "prepare_nuclear",
      "label": "prepare_nuclear",
      "type": "rule"
    },
    {
      "id": "prepare_geothermal",
      "label": "prepare_geothermal",
      "type": "rule"
    },
    {
      "id": "prepare_statistics",
      "label": "prepare_statistics",
      "type": "rule"
    },
    {
      "id": "prepare_fuel_classes",
      "label": "prepare_fuel_classes",
      "type": "rule"
    },
    {
      "id": "remap_fuel_classes",
      "label": "remap_fuel_classes",
      "type": "rule"
    },
    {
      "id": "prepare_shapes",
      "label": "prepare_shapes",
      "type": "rule"
    },
    {
      "id": "download_eia",
      "label": "download_eia",
      "type": "rule"
    },
    {
      "id": "download_tz_sam",
      "label": "download_tz_sam",
      "type": "rule"
    },
    {
      "id": "download_glohydrores",
      "label": "download_glohydrores",
      "type": "rule"
    },
    {
      "id": "download_gem",
      "label": "download_gem",
      "type": "rule"
    },
    {
      "id": "impute_location",
      "label": "impute_location",
      "type": "rule"
    },
    {
      "id": "impute_time",
      "label": "impute_time",
      "type": "rule"
    },
    {
      "id": "impute_capacity_adjustment",
      "label": "impute_capacity_adjustment",
      "type": "rule"
    },
    {
      "id": "aggregate_co2stop",
      "label": "aggregate_co2stop",
      "type": "rule"
    },
    {
      "id": "aggregate_totals",
      "label": "aggregate_totals",
      "type": "rule"
    },
    {
      "id": "prepare_co2stop_storage_units",
      "label": "prepare_co2stop_storage_units",
      "type": "rule"
    },
    {
      "id": "prepare_co2stop_traps",
      "label": "prepare_co2stop_traps",
      "type": "rule"
    },
    {
      "id": "download_co2stop",
      "label": "download_co2stop",
      "type": "rule"
    },
    {
      "id": "unzip_co2stop",
      "label": "unzip_co2stop",
      "type": "rule"
    },
    {
      "id": "picard_merge_sam",
      "label": "picard_merge_sam",
      "type": "rule"
    },
    {
      "id": "qc_multiqc",
      "label": "qc_multiqc",
      "type": "rule"
    },
    {
      "id": "qc_fastqc",
      "label": "qc_fastqc",
      "type": "rule"
    },
    {
      "id": "qc_samtools_coverage",
      "label": "qc_samtools_coverage",
      "type": "rule"
    },
    {
      "id": "qc_plot_samtools_coverage",
      "label": "qc_plot_samtools_coverage",
      "type": "rule"
    },
    {
      "id": "qc_notebook",
      "label": "qc_notebook",
      "type": "rule"
    },
    {
      "id": "map_bwa_index",
      "label": "map_bwa_index",
      "type": "rule"
    },
    {
      "id": "map_bwa_mem",
      "label": "map_bwa_mem",
      "type": "rule"
    },
    {
      "id": "pangolin_la",
      "label": "pangolin_la",
      "type": "rule"
    },
    {
      "id": "fastp_pe",
      "label": "fastp_pe",
      "type": "rule"
    },
    {
      "id": "bwa_mem",
      "label": "bwa_mem",
      "type": "rule"
    },
    {
      "id": "samtools_sort",
      "label": "samtools_sort",
      "type": "rule"
    },
    {
      "id": "metaspades_assembly",
      "label": "metaspades_assembly",
      "type": "rule"
    },
    {
      "id": "ragtag_scaffold",
      "label": "ragtag_scaffold",
      "type": "rule"
    },
    {
      "id": "bcftools_mpileup",
      "label": "bcftools_mpileup",
      "type": "rule"
    },
    {
      "id": "bcftools_call",
      "label": "bcftools_call",
      "type": "rule"
    },
    {
      "id": "bcftools_index",
      "label": "bcftools_index",
      "type": "rule"
    },
    {
      "id": "bcf_consensus",
      "label": "bcf_consensus",
      "type": "rule"
    },
    {
      "id": "csv_report",
      "label": "csv_report",
      "type": "rule"
    },
    {
      "id": "generate_report",
      "label": "generate_report",
      "type": "rule"
    },
    {
      "id": "faToTwoBit",
      "label": "faToTwoBit",
      "type": "rule"
    },
    {
      "id": "bam_to_cram",
      "label": "bam_to_cram",
      "type": "rule"
    },
    {
      "id": "index_cram",
      "label": "index_cram",
      "type": "rule"
    },
    {
      "id": "sort_umitools_input",
      "label": "sort_umitools_input",
      "type": "rule"
    },
    {
      "id": "index_umitools_input",
      "label": "index_umitools_input",
      "type": "rule"
    },
    {
      "id": "bam_to_cram_post_processing",
      "label": "bam_to_cram_post_processing",
      "type": "rule"
    },
    {
      "id": "index_cram_post_processing",
      "label": "index_cram_post_processing",
      "type": "rule"
    },
    {
      "id": "gffread_gff",
      "label": "gffread_gff",
      "type": "rule"
    },
    {
      "id": "rseqc_infer_experiment",
      "label": "rseqc_infer_experiment",
      "type": "rule"
    },
    {
      "id": "rseqc_bam_stat",
      "label": "rseqc_bam_stat",
      "type": "rule"
    },
    {
      "id": "deeptools_coverage",
      "label": "deeptools_coverage",
      "type": "rule"
    },
    {
      "id": "bwa_mem2_index",
      "label": "bwa_mem2_index",
      "type": "rule"
    },
    {
      "id": "bwa_mem2",
      "label": "bwa_mem2",
      "type": "rule"
    },
    {
      "id": "minimap2_index",
      "label": "minimap2_index",
      "type": "rule"
    },
    {
      "id": "minimap2_align",
      "label": "minimap2_align",
      "type": "rule"
    },
    {
      "id": "index_genome_with_overhang_chromosomes",
      "label": "index_genome_with_overhang_chromosomes",
      "type": "rule"
    },
    {
      "id": "get_fastq",
      "label": "get_fastq",
      "type": "rule"
    },
    {
      "id": "fastp",
      "label": "fastp",
      "type": "rule"
    },
    {
      "id": "trim_galore",
      "label": "trim_galore",
      "type": "rule"
    },
    {
      "id": "star_index",
      "label": "star_index",
      "type": "rule"
    },
    {
      "id": "star_align",
      "label": "star_align",
      "type": "rule"
    },
    {
      "id": "bowtie2_build",
      "label": "bowtie2_build",
      "type": "rule"
    },
    {
      "id": "bowtie2_align",
      "label": "bowtie2_align",
      "type": "rule"
    },
    {
      "id": "cutadapt1",
      "label": "cutadapt1",
      "type": "rule"
    },
    {
      "id": "cutadapt2",
      "label": "cutadapt2",
      "type": "rule"
    },
    {
      "id": "cutadapt3",
      "label": "cutadapt3",
      "type": "rule"
    },
    {
      "id": "cutadapt4",
      "label": "cutadapt4",
      "type": "rule"
    },
    {
      "id": "transfer",
      "label": "transfer",
      "type": "rule"
    },
    {
      "id": "calculate_checksums",
      "label": "calculate_checksums",
      "type": "rule"
    },
    {
      "id": "calculate_archive_checksums",
      "label": "calculate_archive_checksums",
      "type": "rule"
    },
    {
      "id": "tar_reports",
      "label": "tar_reports",
      "type": "rule"
    },
    {
      "id": "falco",
      "label": "falco",
      "type": "rule"
    },
    {
      "id": "download_univec",
      "label": "download_univec",
      "type": "rule"
    },
    {
      "id": "bam_2_unmapped_paired_fq",
      "label": "bam_2_unmapped_paired_fq",
      "type": "rule"
    },
    {
      "id": "gatk_haplotype_caller",
      "label": "gatk_haplotype_caller",
      "type": "rule"
    },
    {
      "id": "gatk_genomics_db_import",
      "label": "gatk_genomics_db_import",
      "type": "rule"
    },
    {
      "id": "gatk_genotype_gvcfs",
      "label": "gatk_genotype_gvcfs",
      "type": "rule"
    },
    {
      "id": "gatk_filter_variants",
      "label": "gatk_filter_variants",
      "type": "rule"
    },
    {
      "id": "gatk_left_align_and_trim_variants",
      "label": "gatk_left_align_and_trim_variants",
      "type": "rule"
    },
    {
      "id": "gatk_select_variants",
      "label": "gatk_select_variants",
      "type": "rule"
    },
    {
      "id": "gatk_variants_to_table",
      "label": "gatk_variants_to_table",
      "type": "rule"
    },
    {
      "id": "bwa_mem_mapping",
      "label": "bwa_mem_mapping",
      "type": "rule"
    },
    {
      "id": "sambamba_mark_duplicates",
      "label": "sambamba_mark_duplicates",
      "type": "rule"
    },
    {
      "id": "download_genome",
      "label": "download_genome",
      "type": "rule"
    },
    {
      "id": "samtools_genome_index",
      "label": "samtools_genome_index",
      "type": "rule"
    },
    {
      "id": "picard_create_dict",
      "label": "picard_create_dict",
      "type": "rule"
    },
    {
      "id": "barcode_snps",
      "label": "barcode_snps",
      "type": "rule"
    },
    {
      "id": "barcode_levels",
      "label": "barcode_levels",
      "type": "rule"
    },
    {
      "id": "compute_coverage",
      "label": "compute_coverage",
      "type": "rule"
    },
    {
      "id": "make_vcf",
      "label": "make_vcf",
      "type": "rule"
    },
    {
      "id": "clean_vcf",
      "label": "clean_vcf",
      "type": "rule"
    },
    {
      "id": "bgzip",
      "label": "bgzip",
      "type": "rule"
    },
    {
      "id": "filter_vcf",
      "label": "filter_vcf",
      "type": "rule"
    },
    {
      "id": "make_list",
      "label": "make_list",
      "type": "rule"
    },
    {
      "id": "merge_vcf",
      "label": "merge_vcf",
      "type": "rule"
    },
    {
      "id": "convert2table",
      "label": "convert2table",
      "type": "rule"
    },
    {
      "id": "annotate_rds",
      "label": "annotate_rds",
      "type": "rule"
    },
    {
      "id": "mosdepth_bed",
      "label": "mosdepth_bed",
      "type": "rule"
    },
    {
      "id": "calculate_proportion",
      "label": "calculate_proportion",
      "type": "rule"
    },
    {
      "id": "concatenate",
      "label": "concatenate",
      "type": "rule"
    },
    {
      "id": "make_tables",
      "label": "make_tables",
      "type": "rule"
    },
    {
      "id": "checksum_fq_headers",
      "label": "checksum_fq_headers",
      "type": "rule"
    },
    {
      "id": "mapping_overview",
      "label": "mapping_overview",
      "type": "rule"
    },
    {
      "id": "abund_table",
      "label": "abund_table",
      "type": "rule"
    },
    {
      "id": "concatenate_fastq",
      "label": "concatenate_fastq",
      "type": "rule"
    },
    {
      "id": "qfilter",
      "label": "qfilter",
      "type": "rule"
    },
    {
      "id": "map2db",
      "label": "map2db",
      "type": "rule"
    },
    {
      "id": "merge_lanes_pe",
      "label": "merge_lanes_pe",
      "type": "rule"
    },
    {
      "id": "consensus_peaks",
      "label": "consensus_peaks",
      "type": "rule"
    },
    {
      "id": "count_reads_on_peaks",
      "label": "count_reads_on_peaks",
      "type": "rule"
    },
    {
      "id": "peakAnnot_singleRep",
      "label": "peakAnnot_singleRep",
      "type": "rule"
    },
    {
      "id": "peakAnnot_singleRep_normPeaks",
      "label": "peakAnnot_singleRep_normPeaks",
      "type": "rule"
    },
    {
      "id": "return_genome_path",
      "label": "return_genome_path",
      "type": "rule"
    },
    {
      "id": "get_reference_genome",
      "label": "get_reference_genome",
      "type": "rule"
    },
    {
      "id": "create_bowtie_index",
      "label": "create_bowtie_index",
      "type": "rule"
    },
    {
      "id": "get_spike_genome",
      "label": "get_spike_genome",
      "type": "rule"
    },
    {
      "id": "calculate_norm_factors",
      "label": "calculate_norm_factors",
      "type": "rule"
    },
    {
      "id": "bam2bigwig_general",
      "label": "bam2bigwig_general",
      "type": "rule"
    },
    {
      "id": "plotFingerprint",
      "label": "plotFingerprint",
      "type": "rule"
    },
    {
      "id": "phantom_peak_qual",
      "label": "phantom_peak_qual",
      "type": "rule"
    },
    {
      "id": "create_qc_table_splitBam",
      "label": "create_qc_table_splitBam",
      "type": "rule"
    },
    {
      "id": "create_qc_table_epic2",
      "label": "create_qc_table_epic2",
      "type": "rule"
    },
    {
      "id": "create_qc_table_edd",
      "label": "create_qc_table_edd",
      "type": "rule"
    },
    {
      "id": "create_qc_table_macs2",
      "label": "create_qc_table_macs2",
      "type": "rule"
    },
    {
      "id": "create_qc_table_peakAnnot",
      "label": "create_qc_table_peakAnnot",
      "type": "rule"
    },
    {
      "id": "split_bam",
      "label": "split_bam",
      "type": "rule"
    },
    {
      "id": "macs2_callNarrowPeak",
      "label": "macs2_callNarrowPeak",
      "type": "rule"
    },
    {
      "id": "macs2_callNormPeaks_narrow",
      "label": "macs2_callNormPeaks_narrow",
      "type": "rule"
    },
    {
      "id": "macs2_callNormPeaks_broad",
      "label": "macs2_callNormPeaks_broad",
      "type": "rule"
    },
    {
      "id": "epic2_callBroadPeaks",
      "label": "epic2_callBroadPeaks",
      "type": "rule"
    },
    {
      "id": "edd_callVeryBroadPeaks",
      "label": "edd_callVeryBroadPeaks",
      "type": "rule"
    },
    {
      "id": "differential_peaks",
      "label": "differential_peaks",
      "type": "rule"
    },
    {
      "id": "install_te_small",
      "label": "install_te_small",
      "type": "rule"
    },
    {
      "id": "run_te_small",
      "label": "run_te_small",
      "type": "rule"
    },
    {
      "id": "deseq2",
      "label": "deseq2",
      "type": "rule"
    },
    {
      "id": "plot_pca",
      "label": "plot_pca",
      "type": "rule"
    },
    {
      "id": "trim_adapters",
      "label": "trim_adapters",
      "type": "rule"
    },
    {
      "id": "get_sequence",
      "label": "get_sequence",
      "type": "rule"
    },
    {
      "id": "count_unique_sequences",
      "label": "count_unique_sequences",
      "type": "rule"
    },
    {
      "id": "create_count_fasta",
      "label": "create_count_fasta",
      "type": "rule"
    },
    {
      "id": "download_ncrna_fasta",
      "label": "download_ncrna_fasta",
      "type": "rule"
    },
    {
      "id": "filter_ncrna_fasta",
      "label": "filter_ncrna_fasta",
      "type": "rule"
    },
    {
      "id": "bowtie_index_ncrna",
      "label": "bowtie_index_ncrna",
      "type": "rule"
    },
    {
      "id": "filter_ncrna_reads",
      "label": "filter_ncrna_reads",
      "type": "rule"
    },
    {
      "id": "bowtie_index",
      "label": "bowtie_index",
      "type": "rule"
    },
    {
      "id": "collapse_sequences",
      "label": "collapse_sequences",
      "type": "rule"
    },
    {
      "id": "align",
      "label": "align",
      "type": "rule"
    },
    {
      "id": "pingpong_analysis",
      "label": "pingpong_analysis",
      "type": "rule"
    },
    {
      "id": "plot_pingpong",
      "label": "plot_pingpong",
      "type": "rule"
    },
    {
      "id": "plot_sequence_bias_pirna",
      "label": "plot_sequence_bias_pirna",
      "type": "rule"
    },
    {
      "id": "te_pos_coverage",
      "label": "te_pos_coverage",
      "type": "rule"
    },
    {
      "id": "length_distribution_aligned_to_TE",
      "label": "length_distribution_aligned_to_TE",
      "type": "rule"
    },
    {
      "id": "download_mirna_fasta",
      "label": "download_mirna_fasta",
      "type": "rule"
    },
    {
      "id": "subset_mirna_fasta",
      "label": "subset_mirna_fasta",
      "type": "rule"
    },
    {
      "id": "mirna_index",
      "label": "mirna_index",
      "type": "rule"
    },
    {
      "id": "align_to_mirna",
      "label": "align_to_mirna",
      "type": "rule"
    },
    {
      "id": "length_counts",
      "label": "length_counts",
      "type": "rule"
    },
    {
      "id": "plot_length_distribution",
      "label": "plot_length_distribution",
      "type": "rule"
    },
    {
      "id": "dedup",
      "label": "dedup",
      "type": "rule"
    },
    {
      "id": "filter_bam",
      "label": "filter_bam",
      "type": "rule"
    },
    {
      "id": "pileup",
      "label": "pileup",
      "type": "rule"
    },
    {
      "id": "mosdepth",
      "label": "mosdepth",
      "type": "rule"
    },
    {
      "id": "flagstat",
      "label": "flagstat",
      "type": "rule"
    },
    {
      "id": "view_mappability",
      "label": "view_mappability",
      "type": "rule"
    },
    {
      "id": "view_mappability2",
      "label": "view_mappability2",
      "type": "rule"
    },
    {
      "id": "get_rid_of_unpaired",
      "label": "get_rid_of_unpaired",
      "type": "rule"
    },
    {
      "id": "mosdepth_octomom",
      "label": "mosdepth_octomom",
      "type": "rule"
    },
    {
      "id": "index_reference",
      "label": "index_reference",
      "type": "rule"
    },
    {
      "id": "mappability_index",
      "label": "mappability_index",
      "type": "rule"
    },
    {
      "id": "mappability",
      "label": "mappability",
      "type": "rule"
    },
    {
      "id": "extract_internal_kmers",
      "label": "extract_internal_kmers",
      "type": "rule"
    },
    {
      "id": "select_buckets",
      "label": "select_buckets",
      "type": "rule"
    },
    {
      "id": "run_bwafastmap",
      "label": "run_bwafastmap",
      "type": "rule"
    },
    {
      "id": "run_bwafastmap_isdb",
      "label": "run_bwafastmap_isdb",
      "type": "rule"
    },
    {
      "id": "analyze_bwafastmap",
      "label": "analyze_bwafastmap",
      "type": "rule"
    },
    {
      "id": "find_percentage_dist",
      "label": "find_percentage_dist",
      "type": "rule"
    },
    {
      "id": "find_passinggenes",
      "label": "find_passinggenes",
      "type": "rule"
    },
    {
      "id": "find_passinggenes_isdb",
      "label": "find_passinggenes_isdb",
      "type": "rule"
    },
    {
      "id": "genome_decompression",
      "label": "genome_decompression",
      "type": "rule"
    },
    {
      "id": "tiny_genome_decompression",
      "label": "tiny_genome_decompression",
      "type": "rule"
    },
    {
      "id": "tinydownsample_df",
      "label": "tinydownsample_df",
      "type": "rule"
    },
    {
      "id": "downsample_df",
      "label": "downsample_df",
      "type": "rule"
    },
    {
      "id": "downsample_clusterzerodf",
      "label": "downsample_clusterzerodf",
      "type": "rule"
    },
    {
      "id": "make_internal_fasta",
      "label": "make_internal_fasta",
      "type": "rule"
    },
    {
      "id": "filter_passinggenes_mge",
      "label": "filter_passinggenes_mge",
      "type": "rule"
    },
    {
      "id": "region_decompression",
      "label": "region_decompression",
      "type": "rule"
    },
    {
      "id": "itol_annottext",
      "label": "itol_annottext",
      "type": "rule"
    },
    {
      "id": "make_bwaidx",
      "label": "make_bwaidx",
      "type": "rule"
    },
    {
      "id": "fastmap",
      "label": "fastmap",
      "type": "rule"
    },
    {
      "id": "prefixsuffix_kmergen",
      "label": "prefixsuffix_kmergen",
      "type": "rule"
    },
    {
      "id": "fastmap_process",
      "label": "fastmap_process",
      "type": "rule"
    },
    {
      "id": "fastmap_distances",
      "label": "fastmap_distances",
      "type": "rule"
    },
    {
      "id": "parse_distances",
      "label": "parse_distances",
      "type": "rule"
    },
    {
      "id": "cluster_dists",
      "label": "cluster_dists",
      "type": "rule"
    },
    {
      "id": "passinggene_cluster_decompression",
      "label": "passinggene_cluster_decompression",
      "type": "rule"
    },
    {
      "id": "samtools_flagstat",
      "label": "samtools_flagstat",
      "type": "rule"
    },
    {
      "id": "samtools_idxstats",
      "label": "samtools_idxstats",
      "type": "rule"
    },
    {
      "id": "get_annotation",
      "label": "get_annotation",
      "type": "rule"
    },
    {
      "id": "sra_get_fastq_pe",
      "label": "sra_get_fastq_pe",
      "type": "rule"
    },
    {
      "id": "sra_get_fastq_se",
      "label": "sra_get_fastq_se",
      "type": "rule"
    },
    {
      "id": "gtf2bed",
      "label": "gtf2bed",
      "type": "rule"
    },
    {
      "id": "bedtools_sort_blacklist",
      "label": "bedtools_sort_blacklist",
      "type": "rule"
    },
    {
      "id": "bedtools_complement_blacklist",
      "label": "bedtools_complement_blacklist",
      "type": "rule"
    },
    {
      "id": "cutadapt_pe",
      "label": "cutadapt_pe",
      "type": "rule"
    },
    {
      "id": "cutadapt_se",
      "label": "cutadapt_se",
      "type": "rule"
    },
    {
      "id": "merge_bams",
      "label": "merge_bams",
      "type": "rule"
    },
    {
      "id": "mark_merged_duplicates",
      "label": "mark_merged_duplicates",
      "type": "rule"
    },
    {
      "id": "plot_fingerprint",
      "label": "plot_fingerprint",
      "type": "rule"
    },
    {
      "id": "macs2_callpeak_broad",
      "label": "macs2_callpeak_broad",
      "type": "rule"
    },
    {
      "id": "macs2_callpeak_narrow",
      "label": "macs2_callpeak_narrow",
      "type": "rule"
    },
    {
      "id": "peaks_count",
      "label": "peaks_count",
      "type": "rule"
    },
    {
      "id": "sm_report_peaks_count_plot",
      "label": "sm_report_peaks_count_plot",
      "type": "rule"
    },
    {
      "id": "bedtools_intersect",
      "label": "bedtools_intersect",
      "type": "rule"
    },
    {
      "id": "frip_score",
      "label": "frip_score",
      "type": "rule"
    },
    {
      "id": "sm_rep_frip_score",
      "label": "sm_rep_frip_score",
      "type": "rule"
    },
    {
      "id": "homer_annotatepeaks",
      "label": "homer_annotatepeaks",
      "type": "rule"
    },
    {
      "id": "plot_macs_qc",
      "label": "plot_macs_qc",
      "type": "rule"
    },
    {
      "id": "plot_homer_annotatepeaks",
      "label": "plot_homer_annotatepeaks",
      "type": "rule"
    },
    {
      "id": "plot_sum_annotatepeaks",
      "label": "plot_sum_annotatepeaks",
      "type": "rule"
    },
    {
      "id": "bedtools_merge_broad",
      "label": "bedtools_merge_broad",
      "type": "rule"
    },
    {
      "id": "bedtools_merge_narrow",
      "label": "bedtools_merge_narrow",
      "type": "rule"
    },
    {
      "id": "create_consensus_bed",
      "label": "create_consensus_bed",
      "type": "rule"
    },
    {
      "id": "create_consensus_saf",
      "label": "create_consensus_saf",
      "type": "rule"
    },
    {
      "id": "plot_peak_intersect",
      "label": "plot_peak_intersect",
      "type": "rule"
    },
    {
      "id": "homer_consensus_annotatepeaks",
      "label": "homer_consensus_annotatepeaks",
      "type": "rule"
    },
    {
      "id": "trim_homer_consensus_annotatepeaks",
      "label": "trim_homer_consensus_annotatepeaks",
      "type": "rule"
    },
    {
      "id": "merge_bool_and_annotatepeaks",
      "label": "merge_bool_and_annotatepeaks",
      "type": "rule"
    },
    {
      "id": "feature_counts",
      "label": "feature_counts",
      "type": "rule"
    },
    {
      "id": "featurecounts_deseq2",
      "label": "featurecounts_deseq2",
      "type": "rule"
    },
    {
      "id": "preseq_lc_extrap",
      "label": "preseq_lc_extrap",
      "type": "rule"
    },
    {
      "id": "collect_multiple_metrics",
      "label": "collect_multiple_metrics",
      "type": "rule"
    },
    {
      "id": "genomecov",
      "label": "genomecov",
      "type": "rule"
    },
    {
      "id": "bedGraphToBigWig",
      "label": "bedGraphToBigWig",
      "type": "rule"
    },
    {
      "id": "compute_matrix",
      "label": "compute_matrix",
      "type": "rule"
    },
    {
      "id": "plot_profile",
      "label": "plot_profile",
      "type": "rule"
    },
    {
      "id": "plot_heatmap",
      "label": "plot_heatmap",
      "type": "rule"
    },
    {
      "id": "phantompeakqualtools",
      "label": "phantompeakqualtools",
      "type": "rule"
    },
    {
      "id": "phantompeak_correlation",
      "label": "phantompeak_correlation",
      "type": "rule"
    },
    {
      "id": "phantompeak_multiqc",
      "label": "phantompeak_multiqc",
      "type": "rule"
    },
    {
      "id": "samtools_view_filter",
      "label": "samtools_view_filter",
      "type": "rule"
    },
    {
      "id": "bamtools_filter_json",
      "label": "bamtools_filter_json",
      "type": "rule"
    },
    {
      "id": "orphan_remove",
      "label": "orphan_remove",
      "type": "rule"
    },
    {
      "id": "samtools_sort_pe",
      "label": "samtools_sort_pe",
      "type": "rule"
    },
    {
      "id": "convert_idat",
      "label": "convert_idat",
      "type": "rule"
    },
    {
      "id": "generate_tsne",
      "label": "generate_tsne",
      "type": "rule"
    },
    {
      "id": "generate_umap",
      "label": "generate_umap",
      "type": "rule"
    },
    {
      "id": "rf_phyML",
      "label": "rf_phyML",
      "type": "rule"
    },
    {
      "id": "qc_windows",
      "label": "qc_windows",
      "type": "rule"
    },
    {
      "id": "runRaxML",
      "label": "runRaxML",
      "type": "rule"
    },
    {
      "id": "bootstrapFilter2",
      "label": "bootstrapFilter2",
      "type": "rule"
    },
    {
      "id": "rf_distance2",
      "label": "rf_distance2",
      "type": "rule"
    },
    {
      "id": "runFasttree",
      "label": "runFasttree",
      "type": "rule"
    },
    {
      "id": "bootstrapFilter_fasttree",
      "label": "bootstrapFilter_fasttree",
      "type": "rule"
    },
    {
      "id": "rf_distance_fasttree",
      "label": "rf_distance_fasttree",
      "type": "rule"
    },
    {
      "id": "rf_distance",
      "label": "rf_distance",
      "type": "rule"
    },
    {
      "id": "bootstrap_consensus",
      "label": "bootstrap_consensus",
      "type": "rule"
    },
    {
      "id": "sliding_windows",
      "label": "sliding_windows",
      "type": "rule"
    },
    {
      "id": "create_Matrix",
      "label": "create_Matrix",
      "type": "rule"
    },
    {
      "id": "prepare_barcode_reference",
      "label": "prepare_barcode_reference",
      "type": "rule"
    },
    {
      "id": "chunk_pypileup",
      "label": "chunk_pypileup",
      "type": "rule"
    },
    {
      "id": "write_ab1",
      "label": "write_ab1",
      "type": "rule"
    },
    {
      "id": "ab1_done",
      "label": "ab1_done",
      "type": "rule"
    },
    {
      "id": "fastq_to_fastq_subreads",
      "label": "fastq_to_fastq_subreads",
      "type": "rule"
    },
    {
      "id": "medaka_consensus_from_subreads",
      "label": "medaka_consensus_from_subreads",
      "type": "rule"
    },
    {
      "id": "split_fastq",
      "label": "split_fastq",
      "type": "rule"
    },
    {
      "id": "consensus_summary_csv",
      "label": "consensus_summary_csv",
      "type": "rule"
    },
    {
      "id": "aln_to_consensus",
      "label": "aln_to_consensus",
      "type": "rule"
    },
    {
      "id": "parse_mpileup_ref_match",
      "label": "parse_mpileup_ref_match",
      "type": "rule"
    },
    {
      "id": "plot_coverage",
      "label": "plot_coverage",
      "type": "rule"
    },
    {
      "id": "coverage_done",
      "label": "coverage_done",
      "type": "rule"
    },
    {
      "id": "plot_done",
      "label": "plot_done",
      "type": "rule"
    },
    {
      "id": "filter_reads_by_length",
      "label": "filter_reads_by_length",
      "type": "rule"
    },
    {
      "id": "count_filtered_reads",
      "label": "count_filtered_reads",
      "type": "rule"
    },
    {
      "id": "cutadapt_demux_linked",
      "label": "cutadapt_demux_linked",
      "type": "rule"
    },
    {
      "id": "demux_stats",
      "label": "demux_stats",
      "type": "rule"
    },
    {
      "id": "move_low_depth_subreads",
      "label": "move_low_depth_subreads",
      "type": "rule"
    },
    {
      "id": "move_file",
      "label": "move_file",
      "type": "rule"
    },
    {
      "id": "finalize_demux",
      "label": "finalize_demux",
      "type": "rule"
    },
    {
      "id": "make_pppp_output_dir",
      "label": "make_pppp_output_dir",
      "type": "rule"
    },
    {
      "id": "alignment_clean",
      "label": "alignment_clean",
      "type": "rule"
    },
    {
      "id": "demux_clean",
      "label": "demux_clean",
      "type": "rule"
    },
    {
      "id": "consensus_clean",
      "label": "consensus_clean",
      "type": "rule"
    },
    {
      "id": "logs_clean",
      "label": "logs_clean",
      "type": "rule"
    },
    {
      "id": "report_clean",
      "label": "report_clean",
      "type": "rule"
    },
    {
      "id": "ab1_clean",
      "label": "ab1_clean",
      "type": "rule"
    },
    {
      "id": "clean",
      "label": "clean",
      "type": "rule"
    },
    {
      "id": "bwameth_index",
      "label": "bwameth_index",
      "type": "rule"
    },
    {
      "id": "align_reads_pe",
      "label": "align_reads_pe",
      "type": "rule"
    },
    {
      "id": "align_reads_se",
      "label": "align_reads_se",
      "type": "rule"
    },
    {
      "id": "aligned_reads_sort",
      "label": "aligned_reads_sort",
      "type": "rule"
    },
    {
      "id": "aligned_reads_index",
      "label": "aligned_reads_index",
      "type": "rule"
    },
    {
      "id": "aligned_reads_focus_on_chromosome",
      "label": "aligned_reads_focus_on_chromosome",
      "type": "rule"
    },
    {
      "id": "aligned_reads_filter_on_mapq",
      "label": "aligned_reads_filter_on_mapq",
      "type": "rule"
    },
    {
      "id": "aligned_reads_markduplicates",
      "label": "aligned_reads_markduplicates",
      "type": "rule"
    },
    {
      "id": "aligned_reads_merge_sras",
      "label": "aligned_reads_merge_sras",
      "type": "rule"
    },
    {
      "id": "aligned_reads_downsample",
      "label": "aligned_reads_downsample",
      "type": "rule"
    },
    {
      "id": "aligned_reads_downsampled_index",
      "label": "aligned_reads_downsampled_index",
      "type": "rule"
    },
    {
      "id": "aligned_reads_rename_chromosomes",
      "label": "aligned_reads_rename_chromosomes",
      "type": "rule"
    },
    {
      "id": "aligned_reads_renamed_index",
      "label": "aligned_reads_renamed_index",
      "type": "rule"
    },
    {
      "id": "aligned_reads_candidates_region",
      "label": "aligned_reads_candidates_region",
      "type": "rule"
    },
    {
      "id": "aligned_reads_candidates_region_index",
      "label": "aligned_reads_candidates_region_index",
      "type": "rule"
    },
    {
      "id": "compute_pandas_df",
      "label": "compute_pandas_df",
      "type": "rule"
    },
    {
      "id": "compute_varlo_df",
      "label": "compute_varlo_df",
      "type": "rule"
    },
    {
      "id": "common_tool_df",
      "label": "common_tool_df",
      "type": "rule"
    },
    {
      "id": "merge_replicates",
      "label": "merge_replicates",
      "type": "rule"
    },
    {
      "id": "prepare_plot_df",
      "label": "prepare_plot_df",
      "type": "rule"
    },
    {
      "id": "plot_heatmaps",
      "label": "plot_heatmaps",
      "type": "rule"
    },
    {
      "id": "plots_bars_illumina",
      "label": "plots_bars_illumina",
      "type": "rule"
    },
    {
      "id": "plot_bias",
      "label": "plot_bias",
      "type": "rule"
    },
    {
      "id": "plot_runtime_comparison",
      "label": "plot_runtime_comparison",
      "type": "rule"
    },
    {
      "id": "methylDackel_compute_meth",
      "label": "methylDackel_compute_meth",
      "type": "rule"
    },
    {
      "id": "methylDackel_rename_output",
      "label": "methylDackel_rename_output",
      "type": "rule"
    },
    {
      "id": "find_candidates",
      "label": "find_candidates",
      "type": "rule"
    },
    {
      "id": "split_candidates",
      "label": "split_candidates",
      "type": "rule"
    },
    {
      "id": "index_candidates",
      "label": "index_candidates",
      "type": "rule"
    },
    {
      "id": "mason_download",
      "label": "mason_download",
      "type": "rule"
    },
    {
      "id": "mason_fake_methylation",
      "label": "mason_fake_methylation",
      "type": "rule"
    },
    {
      "id": "mason_fake_variants",
      "label": "mason_fake_variants",
      "type": "rule"
    },
    {
      "id": "mason_fake_reads",
      "label": "mason_fake_reads",
      "type": "rule"
    },
    {
      "id": "mason_align_reads",
      "label": "mason_align_reads",
      "type": "rule"
    },
    {
      "id": "mason_sam_to_bam",
      "label": "mason_sam_to_bam",
      "type": "rule"
    },
    {
      "id": "mason_sort_reads",
      "label": "mason_sort_reads",
      "type": "rule"
    },
    {
      "id": "mason_alignment_forward",
      "label": "mason_alignment_forward",
      "type": "rule"
    },
    {
      "id": "mason_alignment_reverse",
      "label": "mason_alignment_reverse",
      "type": "rule"
    },
    {
      "id": "mason_sort_oriented_reads",
      "label": "mason_sort_oriented_reads",
      "type": "rule"
    },
    {
      "id": "mason_index_oriented_alignment",
      "label": "mason_index_oriented_alignment",
      "type": "rule"
    },
    {
      "id": "mason_coverage",
      "label": "mason_coverage",
      "type": "rule"
    },
    {
      "id": "mason_unzip_coverage",
      "label": "mason_unzip_coverage",
      "type": "rule"
    },
    {
      "id": "mason_compute_truth",
      "label": "mason_compute_truth",
      "type": "rule"
    },
    {
      "id": "varlociraptor_preprocess",
      "label": "varlociraptor_preprocess",
      "type": "rule"
    },
    {
      "id": "varlociraptor_call",
      "label": "varlociraptor_call",
      "type": "rule"
    },
    {
      "id": "calls_to_vcf",
      "label": "calls_to_vcf",
      "type": "rule"
    },
    {
      "id": "gather_calls",
      "label": "gather_calls",
      "type": "rule"
    },
    {
      "id": "genome_index",
      "label": "genome_index",
      "type": "rule"
    },
    {
      "id": "focus_genome_on_chromosome",
      "label": "focus_genome_on_chromosome",
      "type": "rule"
    },
    {
      "id": "chromosome_index",
      "label": "chromosome_index",
      "type": "rule"
    },
    {
      "id": "rename_chromosome_in_fasta",
      "label": "rename_chromosome_in_fasta",
      "type": "rule"
    },
    {
      "id": "get_fastq_pe",
      "label": "get_fastq_pe",
      "type": "rule"
    },
    {
      "id": "get_fastq_se",
      "label": "get_fastq_se",
      "type": "rule"
    },
    {
      "id": "trim_fastq_pe",
      "label": "trim_fastq_pe",
      "type": "rule"
    },
    {
      "id": "trim_fastq_se",
      "label": "trim_fastq_se",
      "type": "rule"
    },
    {
      "id": "get_pacbio_data",
      "label": "get_pacbio_data",
      "type": "rule"
    },
    {
      "id": "get_nanopore_data",
      "label": "get_nanopore_data",
      "type": "rule"
    },
    {
      "id": "call_methylation_together_np_pb",
      "label": "call_methylation_together_np_pb",
      "type": "rule"
    },
    {
      "id": "call_methylation_together_np_trueOX",
      "label": "call_methylation_together_np_trueOX",
      "type": "rule"
    },
    {
      "id": "call_methylation_together_pb_trueOX",
      "label": "call_methylation_together_pb_trueOX",
      "type": "rule"
    },
    {
      "id": "bissnp_download",
      "label": "bissnp_download",
      "type": "rule"
    },
    {
      "id": "bissnp_prepare",
      "label": "bissnp_prepare",
      "type": "rule"
    },
    {
      "id": "bissnp_extract",
      "label": "bissnp_extract",
      "type": "rule"
    },
    {
      "id": "gather_bisSnp",
      "label": "gather_bisSnp",
      "type": "rule"
    },
    {
      "id": "bissnp_create_bedgraph",
      "label": "bissnp_create_bedgraph",
      "type": "rule"
    },
    {
      "id": "bissnp_merge_positions",
      "label": "bissnp_merge_positions",
      "type": "rule"
    },
    {
      "id": "bsmapz_clone_and_build",
      "label": "bsmapz_clone_and_build",
      "type": "rule"
    },
    {
      "id": "bsmapz_compute_meth",
      "label": "bsmapz_compute_meth",
      "type": "rule"
    },
    {
      "id": "bsmapz_extract",
      "label": "bsmapz_extract",
      "type": "rule"
    },
    {
      "id": "bsmapz_rename_output",
      "label": "bsmapz_rename_output",
      "type": "rule"
    },
    {
      "id": "modkit_compute_methylation",
      "label": "modkit_compute_methylation",
      "type": "rule"
    },
    {
      "id": "pb_CpG_download",
      "label": "pb_CpG_download",
      "type": "rule"
    },
    {
      "id": "pb_CpG_compute_methylation",
      "label": "pb_CpG_compute_methylation",
      "type": "rule"
    },
    {
      "id": "pb_CpG_rename_output",
      "label": "pb_CpG_rename_output",
      "type": "rule"
    },
    {
      "id": "bismark_copy_genome",
      "label": "bismark_copy_genome",
      "type": "rule"
    },
    {
      "id": "bismark_copy_chromosome",
      "label": "bismark_copy_chromosome",
      "type": "rule"
    },
    {
      "id": "bismark_prepare_genome",
      "label": "bismark_prepare_genome",
      "type": "rule"
    },
    {
      "id": "bismark_align",
      "label": "bismark_align",
      "type": "rule"
    },
    {
      "id": "samtools_merge",
      "label": "samtools_merge",
      "type": "rule"
    },
    {
      "id": "deduplicate_bismark",
      "label": "deduplicate_bismark",
      "type": "rule"
    },
    {
      "id": "bismark_extract",
      "label": "bismark_extract",
      "type": "rule"
    },
    {
      "id": "bismark_merge_positions",
      "label": "bismark_merge_positions",
      "type": "rule"
    },
    {
      "id": "processImageData",
      "label": "processImageData",
      "type": "rule"
    },
    {
      "id": "trim_reads",
      "label": "trim_reads",
      "type": "rule"
    },
    {
      "id": "parse_demux",
      "label": "parse_demux",
      "type": "rule"
    },
    {
      "id": "mirtrace",
      "label": "mirtrace",
      "type": "rule"
    },
    {
      "id": "starsolo",
      "label": "starsolo",
      "type": "rule"
    },
    {
      "id": "format_starsolo",
      "label": "format_starsolo",
      "type": "rule"
    },
    {
      "id": "convert_sheet",
      "label": "convert_sheet",
      "type": "rule"
    },
    {
      "id": "demux",
      "label": "demux",
      "type": "rule"
    },
    {
      "id": "merge_fastq",
      "label": "merge_fastq",
      "type": "rule"
    },
    {
      "id": "collapse_reads",
      "label": "collapse_reads",
      "type": "rule"
    },
    {
      "id": "fasta_to_chrom_gtf",
      "label": "fasta_to_chrom_gtf",
      "type": "rule"
    },
    {
      "id": "star_index_hairpin",
      "label": "star_index_hairpin",
      "type": "rule"
    },
    {
      "id": "star_align_hairpin",
      "label": "star_align_hairpin",
      "type": "rule"
    },
    {
      "id": "mirtop",
      "label": "mirtop",
      "type": "rule"
    },
    {
      "id": "starsolo_align_hairpin",
      "label": "starsolo_align_hairpin",
      "type": "rule"
    },
    {
      "id": "deduplicate_reads",
      "label": "deduplicate_reads",
      "type": "rule"
    },
    {
      "id": "split_bam_by_barcode",
      "label": "split_bam_by_barcode",
      "type": "rule"
    },
    {
      "id": "mirtop_counts_per_barcode",
      "label": "mirtop_counts_per_barcode",
      "type": "rule"
    },
    {
      "id": "aggregate_mirtop_counts",
      "label": "aggregate_mirtop_counts",
      "type": "rule"
    },
    {
      "id": "vcf_to_tsv",
      "label": "vcf_to_tsv",
      "type": "rule"
    },
    {
      "id": "plot_stats",
      "label": "plot_stats",
      "type": "rule"
    },
    {
      "id": "genome_dict",
      "label": "genome_dict",
      "type": "rule"
    },
    {
      "id": "remove_iupac_codes",
      "label": "remove_iupac_codes",
      "type": "rule"
    },
    {
      "id": "apply_base_quality_recalibration",
      "label": "apply_base_quality_recalibration",
      "type": "rule"
    },
    {
      "id": "get_reads",
      "label": "get_reads",
      "type": "rule"
    },
    {
      "id": "get_archive",
      "label": "get_archive",
      "type": "rule"
    },
    {
      "id": "get_truth",
      "label": "get_truth",
      "type": "rule"
    },
    {
      "id": "rename_truth_contigs",
      "label": "rename_truth_contigs",
      "type": "rule"
    },
    {
      "id": "merge_truthsets",
      "label": "merge_truthsets",
      "type": "rule"
    },
    {
      "id": "normalize_truth",
      "label": "normalize_truth",
      "type": "rule"
    },
    {
      "id": "get_confidence_bed",
      "label": "get_confidence_bed",
      "type": "rule"
    },
    {
      "id": "get_liftover_track",
      "label": "get_liftover_track",
      "type": "rule"
    },
    {
      "id": "get_target_bed",
      "label": "get_target_bed",
      "type": "rule"
    },
    {
      "id": "postprocess_target_bed",
      "label": "postprocess_target_bed",
      "type": "rule"
    },
    {
      "id": "get_reference",
      "label": "get_reference",
      "type": "rule"
    },
    {
      "id": "get_liftover_chain",
      "label": "get_liftover_chain",
      "type": "rule"
    },
    {
      "id": "samtools_faidx",
      "label": "samtools_faidx",
      "type": "rule"
    },
    {
      "id": "stratify_regions",
      "label": "stratify_regions",
      "type": "rule"
    },
    {
      "id": "extract_fp_fn",
      "label": "extract_fp_fn",
      "type": "rule"
    },
    {
      "id": "extract_fp_fn_tp",
      "label": "extract_fp_fn_tp",
      "type": "rule"
    },
    {
      "id": "reformat_fp_fn_tp_tables",
      "label": "reformat_fp_fn_tp_tables",
      "type": "rule"
    },
    {
      "id": "calc_precision_recall",
      "label": "calc_precision_recall",
      "type": "rule"
    },
    {
      "id": "collect_precision_recall",
      "label": "collect_precision_recall",
      "type": "rule"
    },
    {
      "id": "report_precision_recall",
      "label": "report_precision_recall",
      "type": "rule"
    },
    {
      "id": "collect_fp_fn_benchmark",
      "label": "collect_fp_fn_benchmark",
      "type": "rule"
    },
    {
      "id": "filter_shared_fn",
      "label": "filter_shared_fn",
      "type": "rule"
    },
    {
      "id": "filter_unique",
      "label": "filter_unique",
      "type": "rule"
    },
    {
      "id": "write_shared_fn_vcf",
      "label": "write_shared_fn_vcf",
      "type": "rule"
    },
    {
      "id": "write_unique_fn_vcf",
      "label": "write_unique_fn_vcf",
      "type": "rule"
    },
    {
      "id": "write_unique_fp_vcf",
      "label": "write_unique_fp_vcf",
      "type": "rule"
    },
    {
      "id": "report_fp_fn",
      "label": "report_fp_fn",
      "type": "rule"
    },
    {
      "id": "report_fp_fn_callset",
      "label": "report_fp_fn_callset",
      "type": "rule"
    },
    {
      "id": "get_downsampled_vep_cache",
      "label": "get_downsampled_vep_cache",
      "type": "rule"
    },
    {
      "id": "download_revel",
      "label": "download_revel",
      "type": "rule"
    },
    {
      "id": "process_revel_scores",
      "label": "process_revel_scores",
      "type": "rule"
    },
    {
      "id": "tabix_revel_scores",
      "label": "tabix_revel_scores",
      "type": "rule"
    },
    {
      "id": "annotate_shared_fn",
      "label": "annotate_shared_fn",
      "type": "rule"
    },
    {
      "id": "annotate_unique_fp_fn",
      "label": "annotate_unique_fp_fn",
      "type": "rule"
    },
    {
      "id": "vembrane_table_shared_fn",
      "label": "vembrane_table_shared_fn",
      "type": "rule"
    },
    {
      "id": "vembrane_table_unique_fp_fn",
      "label": "vembrane_table_unique_fp_fn",
      "type": "rule"
    },
    {
      "id": "norm_vcf",
      "label": "norm_vcf",
      "type": "rule"
    },
    {
      "id": "index_vcf",
      "label": "index_vcf",
      "type": "rule"
    },
    {
      "id": "index_bcf",
      "label": "index_bcf",
      "type": "rule"
    },
    {
      "id": "sort_vcf",
      "label": "sort_vcf",
      "type": "rule"
    },
    {
      "id": "get_reference_dict",
      "label": "get_reference_dict",
      "type": "rule"
    },
    {
      "id": "merge_callsets",
      "label": "merge_callsets",
      "type": "rule"
    },
    {
      "id": "liftover_callset",
      "label": "liftover_callset",
      "type": "rule"
    },
    {
      "id": "add_format_field",
      "label": "add_format_field",
      "type": "rule"
    },
    {
      "id": "remove_non_pass",
      "label": "remove_non_pass",
      "type": "rule"
    },
    {
      "id": "intersect_calls_with_target_regions",
      "label": "intersect_calls_with_target_regions",
      "type": "rule"
    },
    {
      "id": "restrict_to_reference_contigs",
      "label": "restrict_to_reference_contigs",
      "type": "rule"
    },
    {
      "id": "normalize_calls",
      "label": "normalize_calls",
      "type": "rule"
    },
    {
      "id": "stratify_truth",
      "label": "stratify_truth",
      "type": "rule"
    },
    {
      "id": "stratify_results",
      "label": "stratify_results",
      "type": "rule"
    },
    {
      "id": "index_stratified_truth",
      "label": "index_stratified_truth",
      "type": "rule"
    },
    {
      "id": "stat_truth",
      "label": "stat_truth",
      "type": "rule"
    },
    {
      "id": "generate_sdf",
      "label": "generate_sdf",
      "type": "rule"
    },
    {
      "id": "benchmark_variants_germline",
      "label": "benchmark_variants_germline",
      "type": "rule"
    },
    {
      "id": "benchmark_variants_somatic",
      "label": "benchmark_variants_somatic",
      "type": "rule"
    },
    {
      "id": "blast2threshold_table",
      "label": "blast2threshold_table",
      "type": "rule"
    },
    {
      "id": "report_threshold",
      "label": "report_threshold",
      "type": "rule"
    },
    {
      "id": "fetch_proteins_database",
      "label": "fetch_proteins_database",
      "type": "rule"
    },
    {
      "id": "fetch_fasta_from_seed",
      "label": "fetch_fasta_from_seed",
      "type": "rule"
    },
    {
      "id": "make_fasta",
      "label": "make_fasta",
      "type": "rule"
    },
    {
      "id": "make_seed_psiblast",
      "label": "make_seed_psiblast",
      "type": "rule"
    },
    {
      "id": "extract_protein",
      "label": "extract_protein",
      "type": "rule"
    },
    {
      "id": "merge_databases",
      "label": "merge_databases",
      "type": "rule"
    },
    {
      "id": "psiblast",
      "label": "psiblast",
      "type": "rule"
    },
    {
      "id": "blast",
      "label": "blast",
      "type": "rule"
    },
    {
      "id": "read_psiblast",
      "label": "read_psiblast",
      "type": "rule"
    },
    {
      "id": "read_hmmsearch",
      "label": "read_hmmsearch",
      "type": "rule"
    },
    {
      "id": "prepare_for_silix",
      "label": "prepare_for_silix",
      "type": "rule"
    },
    {
      "id": "find_family",
      "label": "find_family",
      "type": "rule"
    },
    {
      "id": "make_PA_table",
      "label": "make_PA_table",
      "type": "rule"
    },
    {
      "id": "silix",
      "label": "silix",
      "type": "rule"
    },
    {
      "id": "plots",
      "label": "plots",
      "type": "rule"
    },
    {
      "id": "user_plots",
      "label": "user_plots",
      "type": "rule"
    },
    {
      "id": "hmmsearch",
      "label": "hmmsearch",
      "type": "rule"
    },
    {
      "id": "sample_prep",
      "label": "sample_prep",
      "type": "rule"
    },
    {
      "id": "concatenate_total_reads_files",
      "label": "concatenate_total_reads_files",
      "type": "rule"
    },
    {
      "id": "merge_abund_tables",
      "label": "merge_abund_tables",
      "type": "rule"
    },
    {
      "id": "rarefy_abund_table",
      "label": "rarefy_abund_table",
      "type": "rule"
    },
    {
      "id": "sintax",
      "label": "sintax",
      "type": "rule"
    },
    {
      "id": "concat_all",
      "label": "concat_all",
      "type": "rule"
    },
    {
      "id": "cutadapt",
      "label": "cutadapt",
      "type": "rule"
    },
    {
      "id": "derep",
      "label": "derep",
      "type": "rule"
    },
    {
      "id": "unoise",
      "label": "unoise",
      "type": "rule"
    },
    {
      "id": "sintax_classify",
      "label": "sintax_classify",
      "type": "rule"
    },
    {
      "id": "savont_classify",
      "label": "savont_classify",
      "type": "rule"
    },
    {
      "id": "savont_asv",
      "label": "savont_asv",
      "type": "rule"
    },
    {
      "id": "minimap2",
      "label": "minimap2",
      "type": "rule"
    },
    {
      "id": "samtools_view",
      "label": "samtools_view",
      "type": "rule"
    },
    {
      "id": "noderad",
      "label": "noderad",
      "type": "rule"
    },
    {
      "id": "simulated_data_to_fasta",
      "label": "simulated_data_to_fasta",
      "type": "rule"
    },
    {
      "id": "blast_database",
      "label": "blast_database",
      "type": "rule"
    },
    {
      "id": "plots_blast",
      "label": "plots_blast",
      "type": "rule"
    },
    {
      "id": "rseqc_make_bed",
      "label": "rseqc_make_bed",
      "type": "rule"
    },
    {
      "id": "rseqc_junction_annotation",
      "label": "rseqc_junction_annotation",
      "type": "rule"
    },
    {
      "id": "rseqc_junction_saturation",
      "label": "rseqc_junction_saturation",
      "type": "rule"
    },
    {
      "id": "rseqc_inner_distance",
      "label": "rseqc_inner_distance",
      "type": "rule"
    },
    {
      "id": "rseqc_read_distribution",
      "label": "rseqc_read_distribution",
      "type": "rule"
    },
    {
      "id": "rseqc_read_duplication",
      "label": "rseqc_read_duplication",
      "type": "rule"
    },
    {
      "id": "rseqc_readgc",
      "label": "rseqc_readgc",
      "type": "rule"
    },
    {
      "id": "rseqc_gene_body_coverage",
      "label": "rseqc_gene_body_coverage",
      "type": "rule"
    },
    {
      "id": "deseq",
      "label": "deseq",
      "type": "rule"
    },
    {
      "id": "star",
      "label": "star",
      "type": "rule"
    },
    {
      "id": "star_index_bam",
      "label": "star_index_bam",
      "type": "rule"
    },
    {
      "id": "count_matrix",
      "label": "count_matrix",
      "type": "rule"
    },
    {
      "id": "star_index_genome",
      "label": "star_index_genome",
      "type": "rule"
    },
    {
      "id": "nanoplot_rawfastq",
      "label": "nanoplot_rawfastq",
      "type": "rule"
    },
    {
      "id": "nanoplot_filteredfastq",
      "label": "nanoplot_filteredfastq",
      "type": "rule"
    },
    {
      "id": "nanoplot_aligned",
      "label": "nanoplot_aligned",
      "type": "rule"
    },
    {
      "id": "filtlong",
      "label": "filtlong",
      "type": "rule"
    },
    {
      "id": "mapping",
      "label": "mapping",
      "type": "rule"
    },
    {
      "id": "genomecoverage",
      "label": "genomecoverage",
      "type": "rule"
    },
    {
      "id": "alignmentends",
      "label": "alignmentends",
      "type": "rule"
    },
    {
      "id": "snv_medaka",
      "label": "snv_medaka",
      "type": "rule"
    },
    {
      "id": "models_clair3",
      "label": "models_clair3",
      "type": "rule"
    },
    {
      "id": "snv_clair3",
      "label": "snv_clair3",
      "type": "rule"
    },
    {
      "id": "sniffles2",
      "label": "sniffles2",
      "type": "rule"
    },
    {
      "id": "cutesv",
      "label": "cutesv",
      "type": "rule"
    },
    {
      "id": "collect_vcfs",
      "label": "collect_vcfs",
      "type": "rule"
    },
    {
      "id": "prepare_vcfs",
      "label": "prepare_vcfs",
      "type": "rule"
    },
    {
      "id": "igv_reports",
      "label": "igv_reports",
      "type": "rule"
    },
    {
      "id": "report",
      "label": "report",
      "type": "rule"
    },
    {
      "id": "bcftools_pileup",
      "label": "bcftools_pileup",
      "type": "rule"
    },
    {
      "id": "bcftools_view",
      "label": "bcftools_view",
      "type": "rule"
    },
    {
      "id": "bcftools_filter",
      "label": "bcftools_filter",
      "type": "rule"
    },
    {
      "id": "bcftools_stats",
      "label": "bcftools_stats",
      "type": "rule"
    },
    {
      "id": "freebayes",
      "label": "freebayes",
      "type": "rule"
    },
    {
      "id": "vep_prepare",
      "label": "vep_prepare",
      "type": "rule"
    },
    {
      "id": "vep_plugins",
      "label": "vep_plugins",
      "type": "rule"
    },
    {
      "id": "vep_annotate_variants",
      "label": "vep_annotate_variants",
      "type": "rule"
    },
    {
      "id": "snpeff_prepare",
      "label": "snpeff_prepare",
      "type": "rule"
    },
    {
      "id": "snpeff",
      "label": "snpeff",
      "type": "rule"
    },
    {
      "id": "bcftools_bcf_and_index",
      "label": "bcftools_bcf_and_index",
      "type": "rule"
    },
    {
      "id": "bcftools_intersection",
      "label": "bcftools_intersection",
      "type": "rule"
    },
    {
      "id": "report_html",
      "label": "report_html",
      "type": "rule"
    },
    {
      "id": "report_pdf",
      "label": "report_pdf",
      "type": "rule"
    },
    {
      "id": "database",
      "label": "database",
      "type": "rule"
    },
    {
      "id": "decoypyrat",
      "label": "decoypyrat",
      "type": "rule"
    },
    {
      "id": "samplesheet",
      "label": "samplesheet",
      "type": "rule"
    },
    {
      "id": "workflow",
      "label": "workflow",
      "type": "rule"
    },
    {
      "id": "fragpipe",
      "label": "fragpipe",
      "type": "rule"
    },
    {
      "id": "msstats",
      "label": "msstats",
      "type": "rule"
    },
    {
      "id": "clean_up",
      "label": "clean_up",
      "type": "rule"
    },
    {
      "id": "versions",
      "label": "versions",
      "type": "rule"
    },
    {
      "id": "module_logs",
      "label": "module_logs",
      "type": "rule"
    },
    {
      "id": "email",
      "label": "email",
      "type": "rule"
    },
    {
      "id": "prepare_summary",
      "label": "prepare_summary",
      "type": "rule"
    },
    {
      "id": "pycoQC_report",
      "label": "pycoQC_report",
      "type": "rule"
    },
    {
      "id": "nanoplot_report",
      "label": "nanoplot_report",
      "type": "rule"
    },
    {
      "id": "download_model",
      "label": "download_model",
      "type": "rule"
    },
    {
      "id": "dorado_simplex",
      "label": "dorado_simplex",
      "type": "rule"
    },
    {
      "id": "samtools_bamtofq",
      "label": "samtools_bamtofq",
      "type": "rule"
    },
    {
      "id": "dorado_summary",
      "label": "dorado_summary",
      "type": "rule"
    },
    {
      "id": "gzip",
      "label": "gzip",
      "type": "rule"
    },
    {
      "id": "dorado_demux",
      "label": "dorado_demux",
      "type": "rule"
    },
    {
      "id": "collect_demuxed_fastq",
      "label": "collect_demuxed_fastq",
      "type": "rule"
    },
    {
      "id": "aggregrate_file",
      "label": "aggregrate_file",
      "type": "rule"
    },
    {
      "id": "aggregrate_barcode",
      "label": "aggregrate_barcode",
      "type": "rule"
    },
    {
      "id": "breakup_shape",
      "label": "breakup_shape",
      "type": "rule"
    },
    {
      "id": "prepare_resampled_inputs",
      "label": "prepare_resampled_inputs",
      "type": "rule"
    },
    {
      "id": "aggregate_area_potential",
      "label": "aggregate_area_potential",
      "type": "rule"
    },
    {
      "id": "plot_aggregated_area_potential",
      "label": "plot_aggregated_area_potential",
      "type": "rule"
    },
    {
      "id": "area_potential_report",
      "label": "area_potential_report",
      "type": "rule"
    },
    {
      "id": "clip_landcover",
      "label": "clip_landcover",
      "type": "rule"
    },
    {
      "id": "clip_settlement",
      "label": "clip_settlement",
      "type": "rule"
    },
    {
      "id": "rasterise_clip_wdpa",
      "label": "rasterise_clip_wdpa",
      "type": "rule"
    },
    {
      "id": "download_netherlands_shapes",
      "label": "download_netherlands_shapes",
      "type": "rule"
    },
    {
      "id": "download_netherlands_protected_areas",
      "label": "download_netherlands_protected_areas",
      "type": "rule"
    },
    {
      "id": "unzip_netherlands_protected_areas",
      "label": "unzip_netherlands_protected_areas",
      "type": "rule"
    },
    {
      "id": "sintax_subset",
      "label": "sintax_subset",
      "type": "rule"
    },
    {
      "id": "append_asv_counts",
      "label": "append_asv_counts",
      "type": "rule"
    },
    {
      "id": "derep_subset",
      "label": "derep_subset",
      "type": "rule"
    },
    {
      "id": "unoise_subset",
      "label": "unoise_subset",
      "type": "rule"
    },
    {
      "id": "trim_primers",
      "label": "trim_primers",
      "type": "rule"
    },
    {
      "id": "concat_all_trimmed",
      "label": "concat_all_trimmed",
      "type": "rule"
    },
    {
      "id": "subsample_reads",
      "label": "subsample_reads",
      "type": "rule"
    },
    {
      "id": "quilt_prepare_regular",
      "label": "quilt_prepare_regular",
      "type": "rule"
    },
    {
      "id": "quilt_run_regular",
      "label": "quilt_run_regular",
      "type": "rule"
    },
    {
      "id": "quilt_ligate_regular",
      "label": "quilt_ligate_regular",
      "type": "rule"
    },
    {
      "id": "quilt_prepare_mspbwt",
      "label": "quilt_prepare_mspbwt",
      "type": "rule"
    },
    {
      "id": "quilt_run_mspbwt",
      "label": "quilt_run_mspbwt",
      "type": "rule"
    },
    {
      "id": "quilt_ligate_mspbwt",
      "label": "quilt_ligate_mspbwt",
      "type": "rule"
    },
    {
      "id": "subset_sample_list",
      "label": "subset_sample_list",
      "type": "rule"
    },
    {
      "id": "subset_refpanel_by_chrom",
      "label": "subset_refpanel_by_chrom",
      "type": "rule"
    },
    {
      "id": "subset_refpanel_by_chunkid",
      "label": "subset_refpanel_by_chunkid",
      "type": "rule"
    },
    {
      "id": "concat_refpanel_sites_by_chunks",
      "label": "concat_refpanel_sites_by_chunks",
      "type": "rule"
    },
    {
      "id": "collect_truth_gts",
      "label": "collect_truth_gts",
      "type": "rule"
    },
    {
      "id": "collect_quilt_regular_imputed_gts",
      "label": "collect_quilt_regular_imputed_gts",
      "type": "rule"
    },
    {
      "id": "collect_quilt_mspbwt_imputed_gts",
      "label": "collect_quilt_mspbwt_imputed_gts",
      "type": "rule"
    },
    {
      "id": "plot_quilt_regular",
      "label": "plot_quilt_regular",
      "type": "rule"
    },
    {
      "id": "plot_quilt_mspbwt",
      "label": "plot_quilt_mspbwt",
      "type": "rule"
    },
    {
      "id": "plot_quilt_accuracy",
      "label": "plot_quilt_accuracy",
      "type": "rule"
    },
    {
      "id": "collect_glimpse_imputed_gts",
      "label": "collect_glimpse_imputed_gts",
      "type": "rule"
    },
    {
      "id": "collect_glimpse2_imputed_gts",
      "label": "collect_glimpse2_imputed_gts",
      "type": "rule"
    },
    {
      "id": "plot_glimpse2_accuracy",
      "label": "plot_glimpse2_accuracy",
      "type": "rule"
    },
    {
      "id": "plot_glimpse_accuracy",
      "label": "plot_glimpse_accuracy",
      "type": "rule"
    },
    {
      "id": "plot_accuracy_panelsize",
      "label": "plot_accuracy_panelsize",
      "type": "rule"
    },
    {
      "id": "plot_accuracy_depth",
      "label": "plot_accuracy_depth",
      "type": "rule"
    },
    {
      "id": "plot_accuracy_v2",
      "label": "plot_accuracy_v2",
      "type": "rule"
    },
    {
      "id": "plot_accuracy_f1",
      "label": "plot_accuracy_f1",
      "type": "rule"
    },
    {
      "id": "downsample_bam",
      "label": "downsample_bam",
      "type": "rule"
    },
    {
      "id": "bamlist",
      "label": "bamlist",
      "type": "rule"
    },
    {
      "id": "glimpse2_prepare_panel",
      "label": "glimpse2_prepare_panel",
      "type": "rule"
    },
    {
      "id": "glimpse2_phase",
      "label": "glimpse2_phase",
      "type": "rule"
    },
    {
      "id": "glimpse2_ligate",
      "label": "glimpse2_ligate",
      "type": "rule"
    },
    {
      "id": "glimpse_prepare_glvcf",
      "label": "glimpse_prepare_glvcf",
      "type": "rule"
    },
    {
      "id": "glimpse_phase",
      "label": "glimpse_phase",
      "type": "rule"
    },
    {
      "id": "glimpse_ligate",
      "label": "glimpse_ligate",
      "type": "rule"
    },
    {
      "id": "collect_quilt_regular_speed_log",
      "label": "collect_quilt_regular_speed_log",
      "type": "rule"
    },
    {
      "id": "collect_quilt_mspbwt_speed_log",
      "label": "collect_quilt_mspbwt_speed_log",
      "type": "rule"
    },
    {
      "id": "collect_glimpse2_speed_log",
      "label": "collect_glimpse2_speed_log",
      "type": "rule"
    },
    {
      "id": "collect_glimpse_speed_log",
      "label": "collect_glimpse_speed_log",
      "type": "rule"
    },
    {
      "id": "plot_speed_quilt_regular",
      "label": "plot_speed_quilt_regular",
      "type": "rule"
    },
    {
      "id": "plot_speed_quilt_mspbwt",
      "label": "plot_speed_quilt_mspbwt",
      "type": "rule"
    },
    {
      "id": "plot_speed_glimpse2",
      "label": "plot_speed_glimpse2",
      "type": "rule"
    },
    {
      "id": "plot_speed_glimpse",
      "label": "plot_speed_glimpse",
      "type": "rule"
    },
    {
      "id": "plot_speed_by_panelsize",
      "label": "plot_speed_by_panelsize",
      "type": "rule"
    },
    {
      "id": "plot_speed_by_depth",
      "label": "plot_speed_by_depth",
      "type": "rule"
    },
    {
      "id": "download_fastq",
      "label": "download_fastq",
      "type": "rule"
    },
    {
      "id": "prokka_annotation",
      "label": "prokka_annotation",
      "type": "rule"
    },
    {
      "id": "flye_assembly",
      "label": "flye_assembly",
      "type": "rule"
    },
    {
      "id": "gffread",
      "label": "gffread",
      "type": "rule"
    },
    {
      "id": "extract_sp",
      "label": "extract_sp",
      "type": "rule"
    },
    {
      "id": "extract_ex",
      "label": "extract_ex",
      "type": "rule"
    },
    {
      "id": "index",
      "label": "index",
      "type": "rule"
    },
    {
      "id": "trimm",
      "label": "trimm",
      "type": "rule"
    },
    {
      "id": "map",
      "label": "map",
      "type": "rule"
    },
    {
      "id": "sort",
      "label": "sort",
      "type": "rule"
    },
    {
      "id": "addReadGroups",
      "label": "addReadGroups",
      "type": "rule"
    },
    {
      "id": "deduplicate",
      "label": "deduplicate",
      "type": "rule"
    },
    {
      "id": "count",
      "label": "count",
      "type": "rule"
    },
    {
      "id": "multiqc_dir",
      "label": "multiqc_dir",
      "type": "rule"
    },
    {
      "id": "taxonomy_sintax",
      "label": "taxonomy_sintax",
      "type": "rule"
    },
    {
      "id": "taxonomy_blast",
      "label": "taxonomy_blast",
      "type": "rule"
    },
    {
      "id": "without_taxonomy",
      "label": "without_taxonomy",
      "type": "rule"
    },
    {
      "id": "convert_to_fasta",
      "label": "convert_to_fasta",
      "type": "rule"
    },
    {
      "id": "vsearch_cluster",
      "label": "vsearch_cluster",
      "type": "rule"
    },
    {
      "id": "concatenate_otus",
      "label": "concatenate_otus",
      "type": "rule"
    },
    {
      "id": "individual_outputs_blast",
      "label": "individual_outputs_blast",
      "type": "rule"
    },
    {
      "id": "fix_tax_blast",
      "label": "fix_tax_blast",
      "type": "rule"
    },
    {
      "id": "cluster_ID",
      "label": "cluster_ID",
      "type": "rule"
    },
    {
      "id": "ampvis2_std_plots_sintax",
      "label": "ampvis2_std_plots_sintax",
      "type": "rule"
    },
    {
      "id": "ampvis2_std_plots_blast",
      "label": "ampvis2_std_plots_blast",
      "type": "rule"
    },
    {
      "id": "polish_racon",
      "label": "polish_racon",
      "type": "rule"
    },
    {
      "id": "prep_for_ampvis2_sintax",
      "label": "prep_for_ampvis2_sintax",
      "type": "rule"
    },
    {
      "id": "ampvis2_modifications_sintax",
      "label": "ampvis2_modifications_sintax",
      "type": "rule"
    },
    {
      "id": "phyloseq_abund_sintax",
      "label": "phyloseq_abund_sintax",
      "type": "rule"
    },
    {
      "id": "phyloseq_sintax",
      "label": "phyloseq_sintax",
      "type": "rule"
    },
    {
      "id": "fix_otu_table_sintax",
      "label": "fix_otu_table_sintax",
      "type": "rule"
    },
    {
      "id": "prep_input_blast",
      "label": "prep_input_blast",
      "type": "rule"
    },
    {
      "id": "relabel",
      "label": "relabel",
      "type": "rule"
    },
    {
      "id": "relabel_merge",
      "label": "relabel_merge",
      "type": "rule"
    },
    {
      "id": "filter_fastq",
      "label": "filter_fastq",
      "type": "rule"
    },
    {
      "id": "merge_read_count",
      "label": "merge_read_count",
      "type": "rule"
    },
    {
      "id": "sambamba",
      "label": "sambamba",
      "type": "rule"
    },
    {
      "id": "gtf_to_bed",
      "label": "gtf_to_bed",
      "type": "rule"
    },
    {
      "id": "slamdunk_map",
      "label": "slamdunk_map",
      "type": "rule"
    },
    {
      "id": "slamdunk_filter",
      "label": "slamdunk_filter",
      "type": "rule"
    },
    {
      "id": "slamdunk_snp",
      "label": "slamdunk_snp",
      "type": "rule"
    },
    {
      "id": "slamdunk_count",
      "label": "slamdunk_count",
      "type": "rule"
    },
    {
      "id": "collapse",
      "label": "collapse",
      "type": "rule"
    },
    {
      "id": "rates",
      "label": "rates",
      "type": "rule"
    },
    {
      "id": "tccontext",
      "label": "tccontext",
      "type": "rule"
    },
    {
      "id": "utrrates",
      "label": "utrrates",
      "type": "rule"
    },
    {
      "id": "snpeval",
      "label": "snpeval",
      "type": "rule"
    },
    {
      "id": "summary",
      "label": "summary",
      "type": "rule"
    },
    {
      "id": "tcperreadpos",
      "label": "tcperreadpos",
      "type": "rule"
    },
    {
      "id": "tcperutrpos",
      "label": "tcperutrpos",
      "type": "rule"
    },
    {
      "id": "dump",
      "label": "dump",
      "type": "rule"
    },
    {
      "id": "index_ref",
      "label": "index_ref",
      "type": "rule"
    },
    {
      "id": "compress_vcf",
      "label": "compress_vcf",
      "type": "rule"
    },
    {
      "id": "tabix",
      "label": "tabix",
      "type": "rule"
    },
    {
      "id": "sort_bed",
      "label": "sort_bed",
      "type": "rule"
    },
    {
      "id": "index_dip_bam",
      "label": "index_dip_bam",
      "type": "rule"
    },
    {
      "id": "sort_exclusion_beds",
      "label": "sort_exclusion_beds",
      "type": "rule"
    },
    {
      "id": "run_assembly_stats",
      "label": "run_assembly_stats",
      "type": "rule"
    },
    {
      "id": "ncbi_download",
      "label": "ncbi_download",
      "type": "rule"
    },
    {
      "id": "fastp_mergedout",
      "label": "fastp_mergedout",
      "type": "rule"
    },
    {
      "id": "fastp_pairedout",
      "label": "fastp_pairedout",
      "type": "rule"
    },
    {
      "id": "mapDamage2_rescaling",
      "label": "mapDamage2_rescaling",
      "type": "rule"
    },
    {
      "id": "bwa_aln_merged",
      "label": "bwa_aln_merged",
      "type": "rule"
    },
    {
      "id": "bwa_samse_merged",
      "label": "bwa_samse_merged",
      "type": "rule"
    },
    {
      "id": "bwa_mem_paired",
      "label": "bwa_mem_paired",
      "type": "rule"
    },
    {
      "id": "bwa_mem_merged",
      "label": "bwa_mem_merged",
      "type": "rule"
    },
    {
      "id": "samtools_merge_collapsed_libs",
      "label": "samtools_merge_collapsed_libs",
      "type": "rule"
    },
    {
      "id": "samtools_merge_paired_units",
      "label": "samtools_merge_paired_units",
      "type": "rule"
    },
    {
      "id": "dedup_merged",
      "label": "dedup_merged",
      "type": "rule"
    },
    {
      "id": "samtools_merge_dedup",
      "label": "samtools_merge_dedup",
      "type": "rule"
    },
    {
      "id": "realignertargetcreator",
      "label": "realignertargetcreator",
      "type": "rule"
    },
    {
      "id": "indelrealigner",
      "label": "indelrealigner",
      "type": "rule"
    },
    {
      "id": "picard_dict",
      "label": "picard_dict",
      "type": "rule"
    },
    {
      "id": "gmap_build",
      "label": "gmap_build",
      "type": "rule"
    },
    {
      "id": "gmap_map",
      "label": "gmap_map",
      "type": "rule"
    },
    {
      "id": "curl",
      "label": "curl",
      "type": "software"
    },
    {
      "id": "netcdf4",
      "label": "netcdf4",
      "type": "software"
    },
    {
      "id": "pandas",
      "label": "pandas",
      "type": "software"
    },
    {
      "id": "xarray",
      "label": "xarray",
      "type": "software"
    },
    {
      "id": "python",
      "label": "python",
      "type": "software"
    },
    {
      "id": "pyarrow",
      "label": "pyarrow",
      "type": "software"
    },
    {
      "id": "libgdal-hdf5",
      "label": "libgdal-hdf5",
      "type": "software"
    },
    {
      "id": "libgdal-arrow-parquet",
      "label": "libgdal-arrow-parquet",
      "type": "software"
    },
    {
      "id": "fiona",
      "label": "fiona",
      "type": "software"
    },
    {
      "id": "matplotlib",
      "label": "matplotlib",
      "type": "software"
    },
    {
      "id": "geopandas",
      "label": "geopandas",
      "type": "software"
    },
    {
      "id": "pyyaml",
      "label": "pyyaml",
      "type": "software"
    },
    {
      "id": "click",
      "label": "click",
      "type": "software"
    },
    {
      "id": "rioxarray",
      "label": "rioxarray",
      "type": "software"
    },
    {
      "id": "rasterio",
      "label": "rasterio",
      "type": "software"
    },
    {
      "id": "geo/rasterio/clip-geotiff\"",
      "label": "geo/rasterio/clip-geotiff\"",
      "type": "software"
    },
    {
      "id": "gzip",
      "label": "gzip",
      "type": "software"
    },
    {
      "id": "wget",
      "label": "wget",
      "type": "software"
    },
    {
      "id": "biopython",
      "label": "biopython",
      "type": "software"
    },
    {
      "id": "dwgsim",
      "label": "dwgsim",
      "type": "software"
    },
    {
      "id": "bio/fastqc\"",
      "label": "bio/fastqc\"",
      "type": "software"
    },
    {
      "id": "bio/multiqc\"",
      "label": "bio/multiqc\"",
      "type": "software"
    },
    {
      "id": "prodigal",
      "label": "prodigal",
      "type": "software"
    },
    {
      "id": "spades",
      "label": "spades",
      "type": "software"
    },
    {
      "id": "sambamba",
      "label": "sambamba",
      "type": "software"
    },
    {
      "id": "bzip2",
      "label": "bzip2",
      "type": "software"
    },
    {
      "id": "bbmap",
      "label": "bbmap",
      "type": "software"
    },
    {
      "id": "pigz",
      "label": "pigz",
      "type": "software"
    },
    {
      "id": "samtools",
      "label": "samtools",
      "type": "software"
    },
    {
      "id": "bio/minimap2/aligner\"",
      "label": "bio/minimap2/aligner\"",
      "type": "software"
    },
    {
      "id": "megahit",
      "label": "megahit",
      "type": "software"
    },
    {
      "id": "r-tidyverse",
      "label": "r-tidyverse",
      "type": "software"
    },
    {
      "id": "gfold",
      "label": "gfold",
      "type": "software"
    },
    {
      "id": "utils/datavzrd\"",
      "label": "utils/datavzrd\"",
      "type": "software"
    },
    {
      "id": "jupyter",
      "label": "jupyter",
      "type": "software"
    },
    {
      "id": "gseapy",
      "label": "gseapy",
      "type": "software"
    },
    {
      "id": "ipykernel",
      "label": "ipykernel",
      "type": "software"
    },
    {
      "id": "bio/vep/annotate\"",
      "label": "bio/vep/annotate\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/haplotypecaller\"",
      "label": "bio/gatk/haplotypecaller\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/combinegvcfs\"",
      "label": "bio/gatk/combinegvcfs\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/genotypegvcfs\"",
      "label": "bio/gatk/genotypegvcfs\"",
      "type": "software"
    },
    {
      "id": "bio/picard/mergevcfs\"",
      "label": "bio/picard/mergevcfs\"",
      "type": "software"
    },
    {
      "id": "bio/reference/ensembl-sequence\"",
      "label": "bio/reference/ensembl-sequence\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/faidx\"",
      "label": "bio/samtools/faidx\"",
      "type": "software"
    },
    {
      "id": "bio/reference/ensembl-variation\"",
      "label": "bio/reference/ensembl-variation\"",
      "type": "software"
    },
    {
      "id": "bio/tabix\"",
      "label": "bio/tabix\"",
      "type": "software"
    },
    {
      "id": "bio/bwa/index\"",
      "label": "bio/bwa/index\"",
      "type": "software"
    },
    {
      "id": "bio/vep/cache\"",
      "label": "bio/vep/cache\"",
      "type": "software"
    },
    {
      "id": "bio/vep/plugins\"",
      "label": "bio/vep/plugins\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/stats\"",
      "label": "bio/samtools/stats\"",
      "type": "software"
    },
    {
      "id": "bio/trimmomatic/se\"",
      "label": "bio/trimmomatic/se\"",
      "type": "software"
    },
    {
      "id": "bio/trimmomatic/pe\"",
      "label": "bio/trimmomatic/pe\"",
      "type": "software"
    },
    {
      "id": "bio/bwa/mem\"",
      "label": "bio/bwa/mem\"",
      "type": "software"
    },
    {
      "id": "bio/picard/markduplicates\"",
      "label": "bio/picard/markduplicates\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/baserecalibrator\"",
      "label": "bio/gatk/baserecalibrator\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/index\"",
      "label": "bio/samtools/index\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/selectvariants\"",
      "label": "bio/gatk/selectvariants\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/variantfiltration\"",
      "label": "bio/gatk/variantfiltration\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/variantrecalibrator\"",
      "label": "bio/gatk/variantrecalibrator\"",
      "type": "software"
    },
    {
      "id": "fastp",
      "label": "fastp",
      "type": "software"
    },
    {
      "id": "fastx_toolkit",
      "label": "fastx_toolkit",
      "type": "software"
    },
    {
      "id": "trim-galore",
      "label": "trim-galore",
      "type": "software"
    },
    {
      "id": "pandera-geopandas",
      "label": "pandera-geopandas",
      "type": "software"
    },
    {
      "id": "pyproj",
      "label": "pyproj",
      "type": "software"
    },
    {
      "id": "openpyxl",
      "label": "openpyxl",
      "type": "software"
    },
    {
      "id": "dask",
      "label": "dask",
      "type": "software"
    },
    {
      "id": "ipdb",
      "label": "ipdb",
      "type": "software"
    },
    {
      "id": "xlrd",
      "label": "xlrd",
      "type": "software"
    },
    {
      "id": "pip",
      "label": "pip",
      "type": "software"
    },
    {
      "id": "numpy",
      "label": "numpy",
      "type": "software"
    },
    {
      "id": "cmap",
      "label": "cmap",
      "type": "software"
    },
    {
      "id": "pandera",
      "label": "pandera",
      "type": "software"
    },
    {
      "id": "pandera-pandas",
      "label": "pandera-pandas",
      "type": "software"
    },
    {
      "id": "pandera-base",
      "label": "pandera-base",
      "type": "software"
    },
    {
      "id": "pytz",
      "label": "pytz",
      "type": "software"
    },
    {
      "id": "bio/picard/mergesamfiles\"",
      "label": "bio/picard/mergesamfiles\"",
      "type": "software"
    },
    {
      "id": "multiqc",
      "label": "multiqc",
      "type": "software"
    },
    {
      "id": "r-ggplot2",
      "label": "r-ggplot2",
      "type": "software"
    },
    {
      "id": "jupyter_contrib_nbextensions",
      "label": "jupyter_contrib_nbextensions",
      "type": "software"
    },
    {
      "id": "jupyterlab_code_formatter",
      "label": "jupyterlab_code_formatter",
      "type": "software"
    },
    {
      "id": "bwa",
      "label": "bwa",
      "type": "software"
    },
    {
      "id": "pangolin",
      "label": "pangolin",
      "type": "software"
    },
    {
      "id": "bio/fastp\"",
      "label": "bio/fastp\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/sort\"",
      "label": "bio/samtools/sort\"",
      "type": "software"
    },
    {
      "id": "bio/spades/metaspades\"",
      "label": "bio/spades/metaspades\"",
      "type": "software"
    },
    {
      "id": "ragtag",
      "label": "ragtag",
      "type": "software"
    },
    {
      "id": "minimap2",
      "label": "minimap2",
      "type": "software"
    },
    {
      "id": "bio/bcftools/mpileup\"",
      "label": "bio/bcftools/mpileup\"",
      "type": "software"
    },
    {
      "id": "bio/bcftools/call\"",
      "label": "bio/bcftools/call\"",
      "type": "software"
    },
    {
      "id": "bio/bcftools/index\"",
      "label": "bio/bcftools/index\"",
      "type": "software"
    },
    {
      "id": "bcftools",
      "label": "bcftools",
      "type": "software"
    },
    {
      "id": "bio/rbt/csvreport\"",
      "label": "bio/rbt/csvreport\"",
      "type": "software"
    },
    {
      "id": "igv-reports",
      "label": "igv-reports",
      "type": "software"
    },
    {
      "id": "bio/ucsc/faToTwoBit\"",
      "label": "bio/ucsc/faToTwoBit\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/view\"",
      "label": "bio/samtools/view\"",
      "type": "software"
    },
    {
      "id": "bio/gffread\"",
      "label": "bio/gffread\"",
      "type": "software"
    },
    {
      "id": "bio/rseqc/infer_experiment\"",
      "label": "bio/rseqc/infer_experiment\"",
      "type": "software"
    },
    {
      "id": "bio/rseqc/bam_stat\"",
      "label": "bio/rseqc/bam_stat\"",
      "type": "software"
    },
    {
      "id": "bio/deeptools/bamcoverage\"",
      "label": "bio/deeptools/bamcoverage\"",
      "type": "software"
    },
    {
      "id": "bio/bwa-mem2/index\"",
      "label": "bio/bwa-mem2/index\"",
      "type": "software"
    },
    {
      "id": "bio/bwa-mem2/mem\"",
      "label": "bio/bwa-mem2/mem\"",
      "type": "software"
    },
    {
      "id": "bio/minimap2/index\"",
      "label": "bio/minimap2/index\"",
      "type": "software"
    },
    {
      "id": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/get_genome\"",
      "label": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/get_genome\"",
      "type": "software"
    },
    {
      "id": "bio/trim_galore/pe\"",
      "label": "bio/trim_galore/pe\"",
      "type": "software"
    },
    {
      "id": "bio/star/index\"",
      "label": "bio/star/index\"",
      "type": "software"
    },
    {
      "id": "bio/star/align\"",
      "label": "bio/star/align\"",
      "type": "software"
    },
    {
      "id": "bio/bowtie2/build\"",
      "label": "bio/bowtie2/build\"",
      "type": "software"
    },
    {
      "id": "bio/bowtie2/align\"",
      "label": "bio/bowtie2/align\"",
      "type": "software"
    },
    {
      "id": "cutadapt",
      "label": "cutadapt",
      "type": "software"
    },
    {
      "id": "fastqc",
      "label": "fastqc",
      "type": "software"
    },
    {
      "id": "globus-cli",
      "label": "globus-cli",
      "type": "software"
    },
    {
      "id": "tar",
      "label": "tar",
      "type": "software"
    },
    {
      "id": "falco",
      "label": "falco",
      "type": "software"
    },
    {
      "id": "bio/gatk/genomicsdbimport\"",
      "label": "bio/gatk/genomicsdbimport\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/leftalignandtrimvariants\"",
      "label": "bio/gatk/leftalignandtrimvariants\"",
      "type": "software"
    },
    {
      "id": "bio/gatk/variantstotable\"",
      "label": "bio/gatk/variantstotable\"",
      "type": "software"
    },
    {
      "id": "bio/sambamba/markdup\"",
      "label": "bio/sambamba/markdup\"",
      "type": "software"
    },
    {
      "id": "entrez-direct",
      "label": "entrez-direct",
      "type": "software"
    },
    {
      "id": "bio/picard/createsequencedictionary\"",
      "label": "bio/picard/createsequencedictionary\"",
      "type": "software"
    },
    {
      "id": "survivor",
      "label": "survivor",
      "type": "software"
    },
    {
      "id": "sed",
      "label": "sed",
      "type": "software"
    },
    {
      "id": "bedtools",
      "label": "bedtools",
      "type": "software"
    },
    {
      "id": "bio/bgzip\"",
      "label": "bio/bgzip\"",
      "type": "software"
    },
    {
      "id": "bio/bcftools/filter\"",
      "label": "bio/bcftools/filter\"",
      "type": "software"
    },
    {
      "id": "gatk4",
      "label": "gatk4",
      "type": "software"
    },
    {
      "id": "bio/bwa/mem-samblaster\"",
      "label": "bio/bwa/mem-samblaster\"",
      "type": "software"
    },
    {
      "id": "bio/mosdepth\"",
      "label": "bio/mosdepth\"",
      "type": "software"
    },
    {
      "id": "r-base",
      "label": "r-base",
      "type": "software"
    },
    {
      "id": "r-openxlsx",
      "label": "r-openxlsx",
      "type": "software"
    },
    {
      "id": "perl",
      "label": "perl",
      "type": "software"
    },
    {
      "id": "r-dplyr",
      "label": "r-dplyr",
      "type": "software"
    },
    {
      "id": "r-data.table",
      "label": "r-data.table",
      "type": "software"
    },
    {
      "id": "filtlong",
      "label": "filtlong",
      "type": "software"
    },
    {
      "id": "deeptoolsintervals",
      "label": "deeptoolsintervals",
      "type": "software"
    },
    {
      "id": "epic2",
      "label": "epic2",
      "type": "software"
    },
    {
      "id": "macs2",
      "label": "macs2",
      "type": "software"
    },
    {
      "id": "cython",
      "label": "cython",
      "type": "software"
    },
    {
      "id": "pysam",
      "label": "pysam",
      "type": "software"
    },
    {
      "id": "py2bit",
      "label": "py2bit",
      "type": "software"
    },
    {
      "id": "deeptools",
      "label": "deeptools",
      "type": "software"
    },
    {
      "id": "bioconductor-DESeq2",
      "label": "bioconductor-DESeq2",
      "type": "software"
    },
    {
      "id": "gawk",
      "label": "gawk",
      "type": "software"
    },
    {
      "id": "bioconductor-txdb.hsapiens.ucsc.hg38.knowngene",
      "label": "bioconductor-txdb.hsapiens.ucsc.hg38.knowngene",
      "type": "software"
    },
    {
      "id": "bioconductor-txdb.hsapiens.ucsc.hg19.knowngene",
      "label": "bioconductor-txdb.hsapiens.ucsc.hg19.knowngene",
      "type": "software"
    },
    {
      "id": "bioconductor-txdb.mmusculus.ucsc.mm10.knowngene",
      "label": "bioconductor-txdb.mmusculus.ucsc.mm10.knowngene",
      "type": "software"
    },
    {
      "id": "bioconductor-org.mm.eg.db",
      "label": "bioconductor-org.mm.eg.db",
      "type": "software"
    },
    {
      "id": "bioconductor-chipseeker",
      "label": "bioconductor-chipseeker",
      "type": "software"
    },
    {
      "id": "bioconductor-org.hs.eg.db",
      "label": "bioconductor-org.hs.eg.db",
      "type": "software"
    },
    {
      "id": "bioconductor-txdb.mmusculus.ucsc.mm9.knowngene",
      "label": "bioconductor-txdb.mmusculus.ucsc.mm9.knowngene",
      "type": "software"
    },
    {
      "id": "r-spp",
      "label": "r-spp",
      "type": "software"
    },
    {
      "id": "bioconda::samblaster",
      "label": "bioconda::samblaster",
      "type": "software"
    },
    {
      "id": "bioconda::bowtie2",
      "label": "bioconda::bowtie2",
      "type": "software"
    },
    {
      "id": "bioconda::samtools",
      "label": "bioconda::samtools",
      "type": "software"
    },
    {
      "id": "edd",
      "label": "edd",
      "type": "software"
    },
    {
      "id": "bokeh",
      "label": "bokeh",
      "type": "software"
    },
    {
      "id": "scipy",
      "label": "scipy",
      "type": "software"
    },
    {
      "id": "seaborn",
      "label": "seaborn",
      "type": "software"
    },
    {
      "id": "pybedtools",
      "label": "pybedtools",
      "type": "software"
    },
    {
      "id": "git",
      "label": "git",
      "type": "software"
    },
    {
      "id": "bioconda::bowtie",
      "label": "bioconda::bowtie",
      "type": "software"
    },
    {
      "id": "r-cowplot",
      "label": "r-cowplot",
      "type": "software"
    },
    {
      "id": "bioconda::bioconductor-deseq2",
      "label": "bioconda::bioconductor-deseq2",
      "type": "software"
    },
    {
      "id": "r-ggseqlogo",
      "label": "r-ggseqlogo",
      "type": "software"
    },
    {
      "id": "bioconda::bioconductor-biostrings",
      "label": "bioconda::bioconductor-biostrings",
      "type": "software"
    },
    {
      "id": "bioconda::bioconductor-rsamtools",
      "label": "bioconda::bioconductor-rsamtools",
      "type": "software"
    },
    {
      "id": "conda-forge::r-gridextra",
      "label": "conda-forge::r-gridextra",
      "type": "software"
    },
    {
      "id": "bioconda::seqkit",
      "label": "bioconda::seqkit",
      "type": "software"
    },
    {
      "id": "bioconda::cutadapt",
      "label": "bioconda::cutadapt",
      "type": "software"
    },
    {
      "id": "bioconda::seqtk",
      "label": "bioconda::seqtk",
      "type": "software"
    },
    {
      "id": "bioconda::pysam",
      "label": "bioconda::pysam",
      "type": "software"
    },
    {
      "id": "conda-forge::wget",
      "label": "conda-forge::wget",
      "type": "software"
    },
    {
      "id": "conda-forge::python",
      "label": "conda-forge::python",
      "type": "software"
    },
    {
      "id": "bioconda::fastx_toolkit",
      "label": "bioconda::fastx_toolkit",
      "type": "software"
    },
    {
      "id": "bio/cutadapt/se\"",
      "label": "bio/cutadapt/se\"",
      "type": "software"
    },
    {
      "id": "genmap",
      "label": "genmap",
      "type": "software"
    },
    {
      "id": "mosdepth",
      "label": "mosdepth",
      "type": "software"
    },
    {
      "id": "loguru",
      "label": "loguru",
      "type": "software"
    },
    {
      "id": "psutil",
      "label": "psutil",
      "type": "software"
    },
    {
      "id": "python-duckdb",
      "label": "python-duckdb",
      "type": "software"
    },
    {
      "id": "bio/samtools/flagstat\"",
      "label": "bio/samtools/flagstat\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/idxstats\"",
      "label": "bio/samtools/idxstats\"",
      "type": "software"
    },
    {
      "id": "bio/reference/ensembl-annotation\"",
      "label": "bio/reference/ensembl-annotation\"",
      "type": "software"
    },
    {
      "id": "bio/sra-tools/fasterq-dump\"",
      "label": "bio/sra-tools/fasterq-dump\"",
      "type": "software"
    },
    {
      "id": "perl-getopt-long",
      "label": "perl-getopt-long",
      "type": "software"
    },
    {
      "id": "bio/bedtools/sort\"",
      "label": "bio/bedtools/sort\"",
      "type": "software"
    },
    {
      "id": "bio/bedtools/complement\"",
      "label": "bio/bedtools/complement\"",
      "type": "software"
    },
    {
      "id": "bio/cutadapt/pe\"",
      "label": "bio/cutadapt/pe\"",
      "type": "software"
    },
    {
      "id": "bio/deeptools/plotfingerprint\"",
      "label": "bio/deeptools/plotfingerprint\"",
      "type": "software"
    },
    {
      "id": "bio/macs2/callpeak\"",
      "label": "bio/macs2/callpeak\"",
      "type": "software"
    },
    {
      "id": "bio/bedtools/intersect\"",
      "label": "bio/bedtools/intersect\"",
      "type": "software"
    },
    {
      "id": "bio/homer/annotatePeaks\"",
      "label": "bio/homer/annotatePeaks\"",
      "type": "software"
    },
    {
      "id": "r-reshape2",
      "label": "r-reshape2",
      "type": "software"
    },
    {
      "id": "r-optparse",
      "label": "r-optparse",
      "type": "software"
    },
    {
      "id": "bio/bedtools/merge\"",
      "label": "bio/bedtools/merge\"",
      "type": "software"
    },
    {
      "id": "r-upsetr",
      "label": "r-upsetr",
      "type": "software"
    },
    {
      "id": "bio/subread/featurecounts\"",
      "label": "bio/subread/featurecounts\"",
      "type": "software"
    },
    {
      "id": "bioconductor-biocparallel",
      "label": "bioconductor-biocparallel",
      "type": "software"
    },
    {
      "id": "r-pheatmap",
      "label": "r-pheatmap",
      "type": "software"
    },
    {
      "id": "bioconductor-deseq2",
      "label": "bioconductor-deseq2",
      "type": "software"
    },
    {
      "id": "r-lattice",
      "label": "r-lattice",
      "type": "software"
    },
    {
      "id": "bioconductor-vsn",
      "label": "bioconductor-vsn",
      "type": "software"
    },
    {
      "id": "r-rcolorbrewer",
      "label": "r-rcolorbrewer",
      "type": "software"
    },
    {
      "id": "bio/preseq/lc_extrap\"",
      "label": "bio/preseq/lc_extrap\"",
      "type": "software"
    },
    {
      "id": "bio/picard/collectmultiplemetrics\"",
      "label": "bio/picard/collectmultiplemetrics\"",
      "type": "software"
    },
    {
      "id": "bio/bedtools/genomecov\"",
      "label": "bio/bedtools/genomecov\"",
      "type": "software"
    },
    {
      "id": "bio/ucsc/bedGraphToBigWig\"",
      "label": "bio/ucsc/bedGraphToBigWig\"",
      "type": "software"
    },
    {
      "id": "bio/deeptools/computematrix\"",
      "label": "bio/deeptools/computematrix\"",
      "type": "software"
    },
    {
      "id": "bio/deeptools/plotprofile\"",
      "label": "bio/deeptools/plotprofile\"",
      "type": "software"
    },
    {
      "id": "bio/deeptools/plotheatmap\"",
      "label": "bio/deeptools/plotheatmap\"",
      "type": "software"
    },
    {
      "id": "r-snow",
      "label": "r-snow",
      "type": "software"
    },
    {
      "id": "r-bitops",
      "label": "r-bitops",
      "type": "software"
    },
    {
      "id": "phantompeakqualtools",
      "label": "phantompeakqualtools",
      "type": "software"
    },
    {
      "id": "r-catools",
      "label": "r-catools",
      "type": "software"
    },
    {
      "id": "r-snowfall",
      "label": "r-snowfall",
      "type": "software"
    },
    {
      "id": "bioconductor-rsamtools",
      "label": "bioconductor-rsamtools",
      "type": "software"
    },
    {
      "id": "bio/bamtools/filter_json\"",
      "label": "bio/bamtools/filter_json\"",
      "type": "software"
    },
    {
      "id": "pkg-config",
      "label": "pkg-config",
      "type": "software"
    },
    {
      "id": "r-remotes",
      "label": "r-remotes",
      "type": "software"
    },
    {
      "id": "make",
      "label": "make",
      "type": "software"
    },
    {
      "id": "bioconductor-sesame",
      "label": "bioconductor-sesame",
      "type": "software"
    },
    {
      "id": "compilers",
      "label": "compilers",
      "type": "software"
    },
    {
      "id": "r-biocmanager",
      "label": "r-biocmanager",
      "type": "software"
    },
    {
      "id": "bioconductor-sesamedata",
      "label": "bioconductor-sesamedata",
      "type": "software"
    },
    {
      "id": "scikit-learn",
      "label": "scikit-learn",
      "type": "software"
    },
    {
      "id": "umap-learn",
      "label": "umap-learn",
      "type": "software"
    },
    {
      "id": "raxml-ng",
      "label": "raxml-ng",
      "type": "software"
    },
    {
      "id": "fasttree",
      "label": "fasttree",
      "type": "software"
    },
    {
      "id": "medaka",
      "label": "medaka",
      "type": "software"
    },
    {
      "id": "seqkit",
      "label": "seqkit",
      "type": "software"
    },
    {
      "id": "bio/bwameth/index\"",
      "label": "bio/bwameth/index\"",
      "type": "software"
    },
    {
      "id": "bwameth",
      "label": "bwameth",
      "type": "software"
    },
    {
      "id": "ncurses",
      "label": "ncurses",
      "type": "software"
    },
    {
      "id": "bwa-mem2",
      "label": "bwa-mem2",
      "type": "software"
    },
    {
      "id": "pytables",
      "label": "pytables",
      "type": "software"
    },
    {
      "id": "vl-convert-python",
      "label": "vl-convert-python",
      "type": "software"
    },
    {
      "id": "altair",
      "label": "altair",
      "type": "software"
    },
    {
      "id": "altair_saver",
      "label": "altair_saver",
      "type": "software"
    },
    {
      "id": "vega_datasets",
      "label": "vega_datasets",
      "type": "software"
    },
    {
      "id": "cyvcf2",
      "label": "cyvcf2",
      "type": "software"
    },
    {
      "id": "vegafusion",
      "label": "vegafusion",
      "type": "software"
    },
    {
      "id": "methyldackel",
      "label": "methyldackel",
      "type": "software"
    },
    {
      "id": "varlociraptor",
      "label": "varlociraptor",
      "type": "software"
    },
    {
      "id": "rust-bio-tools",
      "label": "rust-bio-tools",
      "type": "software"
    },
    {
      "id": "cat",
      "label": "cat",
      "type": "software"
    },
    {
      "id": "mason",
      "label": "mason",
      "type": "software"
    },
    {
      "id": "openjdk",
      "label": "openjdk",
      "type": "software"
    },
    {
      "id": "bsmapz",
      "label": "bsmapz",
      "type": "software"
    },
    {
      "id": "ont-modkit",
      "label": "ont-modkit",
      "type": "software"
    },
    {
      "id": "bowtie2",
      "label": "bowtie2",
      "type": "software"
    },
    {
      "id": "bismark",
      "label": "bismark",
      "type": "software"
    },
    {
      "id": "bio/bismark/bismark\"",
      "label": "bio/bismark/bismark\"",
      "type": "software"
    },
    {
      "id": "bio/samtools/merge\"",
      "label": "bio/samtools/merge\"",
      "type": "software"
    },
    {
      "id": "bio/bismark/deduplicate_bismark\"",
      "label": "bio/bismark/deduplicate_bismark\"",
      "type": "software"
    },
    {
      "id": "meshio",
      "label": "meshio",
      "type": "software"
    },
    {
      "id": "pyacvd",
      "label": "pyacvd",
      "type": "software"
    },
    {
      "id": "dask-image",
      "label": "dask-image",
      "type": "software"
    },
    {
      "id": "pyvista",
      "label": "pyvista",
      "type": "software"
    },
    {
      "id": "scikit-image",
      "label": "scikit-image",
      "type": "software"
    },
    {
      "id": "mirtrace",
      "label": "mirtrace",
      "type": "software"
    },
    {
      "id": "procps-ng",
      "label": "procps-ng",
      "type": "software"
    },
    {
      "id": "humanfriendly",
      "label": "humanfriendly",
      "type": "software"
    },
    {
      "id": "star",
      "label": "star",
      "type": "software"
    },
    {
      "id": "bcl2fastq",
      "label": "bcl2fastq",
      "type": "software"
    },
    {
      "id": "setuptools",
      "label": "setuptools",
      "type": "software"
    },
    {
      "id": "seqcluster",
      "label": "seqcluster",
      "type": "software"
    },
    {
      "id": "mirtop",
      "label": "mirtop",
      "type": "software"
    },
    {
      "id": "bio/gatk/applybqsr\"",
      "label": "bio/gatk/applybqsr\"",
      "type": "software"
    },
    {
      "id": "dnaio",
      "label": "dnaio",
      "type": "software"
    },
    {
      "id": "ucsc-liftover",
      "label": "ucsc-liftover",
      "type": "software"
    },
    {
      "id": "bio/bcftools/norm\"",
      "label": "bio/bcftools/norm\"",
      "type": "software"
    },
    {
      "id": "vembrane",
      "label": "vembrane",
      "type": "software"
    },
    {
      "id": "bio/vembrane/table\"",
      "label": "bio/vembrane/table\"",
      "type": "software"
    },
    {
      "id": "statsmodels",
      "label": "statsmodels",
      "type": "software"
    },
    {
      "id": "bio/tabix/index\"",
      "label": "bio/tabix/index\"",
      "type": "software"
    },
    {
      "id": "bio/bcftools/sort\"",
      "label": "bio/bcftools/sort\"",
      "type": "software"
    },
    {
      "id": "picard",
      "label": "picard",
      "type": "software"
    },
    {
      "id": "bio/bcftools/view\"",
      "label": "bio/bcftools/view\"",
      "type": "software"
    },
    {
      "id": "rtg-tools",
      "label": "rtg-tools",
      "type": "software"
    },
    {
      "id": "numba",
      "label": "numba",
      "type": "software"
    },
    {
      "id": "plotly",
      "label": "plotly",
      "type": "software"
    },
    {
      "id": "ete3",
      "label": "ete3",
      "type": "software"
    },
    {
      "id": "ncbi-genome-download",
      "label": "ncbi-genome-download",
      "type": "software"
    },
    {
      "id": "blast",
      "label": "blast",
      "type": "software"
    },
    {
      "id": "silix",
      "label": "silix",
      "type": "software"
    },
    {
      "id": "hmmer",
      "label": "hmmer",
      "type": "software"
    },
    {
      "id": "usearch",
      "label": "usearch",
      "type": "software"
    },
    {
      "id": "savont",
      "label": "savont",
      "type": "software"
    },
    {
      "id": "xorg-libxcomposite",
      "label": "xorg-libxcomposite",
      "type": "software"
    },
    {
      "id": "xorg-libxau",
      "label": "xorg-libxau",
      "type": "software"
    },
    {
      "id": "xorg-libxinerama",
      "label": "xorg-libxinerama",
      "type": "software"
    },
    {
      "id": "xorg-libxcursor",
      "label": "xorg-libxcursor",
      "type": "software"
    },
    {
      "id": "xorg-libxi",
      "label": "xorg-libxi",
      "type": "software"
    },
    {
      "id": "xorg-libxrandr",
      "label": "xorg-libxrandr",
      "type": "software"
    },
    {
      "id": "graph-tool",
      "label": "graph-tool",
      "type": "software"
    },
    {
      "id": "xorg-libxdamage",
      "label": "xorg-libxdamage",
      "type": "software"
    },
    {
      "id": "xopen",
      "label": "xopen",
      "type": "software"
    },
    {
      "id": "openssl",
      "label": "openssl",
      "type": "software"
    },
    {
      "id": "r-stringr",
      "label": "r-stringr",
      "type": "software"
    },
    {
      "id": "gffutils",
      "label": "gffutils",
      "type": "software"
    },
    {
      "id": "rseqc",
      "label": "rseqc",
      "type": "software"
    },
    {
      "id": "bioconductor-fgsea",
      "label": "bioconductor-fgsea",
      "type": "software"
    },
    {
      "id": "r-ggrepel",
      "label": "r-ggrepel",
      "type": "software"
    },
    {
      "id": "r-writexls",
      "label": "r-writexls",
      "type": "software"
    },
    {
      "id": "r-ashr",
      "label": "r-ashr",
      "type": "software"
    },
    {
      "id": "r-yaml",
      "label": "r-yaml",
      "type": "software"
    },
    {
      "id": "radian",
      "label": "radian",
      "type": "software"
    },
    {
      "id": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/nanoplot\"",
      "label": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/nanoplot\"",
      "type": "software"
    },
    {
      "id": "rich-click",
      "label": "rich-click",
      "type": "software"
    },
    {
      "id": "ngmlr",
      "label": "ngmlr",
      "type": "software"
    },
    {
      "id": "clair3",
      "label": "clair3",
      "type": "software"
    },
    {
      "id": "sniffles",
      "label": "sniffles",
      "type": "software"
    },
    {
      "id": "cutesv",
      "label": "cutesv",
      "type": "software"
    },
    {
      "id": "r-dt",
      "label": "r-dt",
      "type": "software"
    },
    {
      "id": "r-rmarkdown",
      "label": "r-rmarkdown",
      "type": "software"
    },
    {
      "id": "bio/bcftools/stats\"",
      "label": "bio/bcftools/stats\"",
      "type": "software"
    },
    {
      "id": "bio/freebayes\"",
      "label": "bio/freebayes\"",
      "type": "software"
    },
    {
      "id": "htslib",
      "label": "htslib",
      "type": "software"
    },
    {
      "id": "snakemake-wrapper-utils",
      "label": "snakemake-wrapper-utils",
      "type": "software"
    },
    {
      "id": "snpeff",
      "label": "snpeff",
      "type": "software"
    },
    {
      "id": "bio/snpeff/annotate\"",
      "label": "bio/snpeff/annotate\"",
      "type": "software"
    },
    {
      "id": "bioconductor-genomicranges",
      "label": "bioconductor-genomicranges",
      "type": "software"
    },
    {
      "id": "r-ggpubr",
      "label": "r-ggpubr",
      "type": "software"
    },
    {
      "id": "bioconductor-biostrings",
      "label": "bioconductor-biostrings",
      "type": "software"
    },
    {
      "id": "r-essentials",
      "label": "r-essentials",
      "type": "software"
    },
    {
      "id": "bioconductor-genomicfeatures",
      "label": "bioconductor-genomicfeatures",
      "type": "software"
    },
    {
      "id": "r-ggupset",
      "label": "r-ggupset",
      "type": "software"
    },
    {
      "id": "r-rstatix",
      "label": "r-rstatix",
      "type": "software"
    },
    {
      "id": "weasyprint",
      "label": "weasyprint",
      "type": "software"
    },
    {
      "id": "ncbi-datasets-cli",
      "label": "ncbi-datasets-cli",
      "type": "software"
    },
    {
      "id": "decoypyrat",
      "label": "decoypyrat",
      "type": "software"
    },
    {
      "id": "mono",
      "label": "mono",
      "type": "software"
    },
    {
      "id": "bioconductor-msstats",
      "label": "bioconductor-msstats",
      "type": "software"
    },
    {
      "id": "r-dendextend",
      "label": "r-dendextend",
      "type": "software"
    },
    {
      "id": "r-scales",
      "label": "r-scales",
      "type": "software"
    },
    {
      "id": "pydyf",
      "label": "pydyf",
      "type": "software"
    },
    {
      "id": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/pycoqc\"",
      "label": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/pycoqc\"",
      "type": "software"
    },
    {
      "id": "glom",
      "label": "glom",
      "type": "software"
    },
    {
      "id": "utm",
      "label": "utm",
      "type": "software"
    },
    {
      "id": "gdal",
      "label": "gdal",
      "type": "software"
    },
    {
      "id": "r",
      "label": "r",
      "type": "software"
    },
    {
      "id": "r-quilt",
      "label": "r-quilt",
      "type": "software"
    },
    {
      "id": "r-mspbwt",
      "label": "r-mspbwt",
      "type": "software"
    },
    {
      "id": "r-stitch",
      "label": "r-stitch",
      "type": "software"
    },
    {
      "id": "sra-tools",
      "label": "sra-tools",
      "type": "software"
    },
    {
      "id": "prokka",
      "label": "prokka",
      "type": "software"
    },
    {
      "id": "flye",
      "label": "flye",
      "type": "software"
    },
    {
      "id": "\"file:///share/home/ychi/dev/dna-seq-gatk-variant-calling/wrappers/haplotypcaller\"",
      "label": "\"file:///share/home/ychi/dev/dna-seq-gatk-variant-calling/wrappers/haplotypcaller\"",
      "type": "software"
    },
    {
      "id": "gffread",
      "label": "gffread",
      "type": "software"
    },
    {
      "id": "hisat2",
      "label": "hisat2",
      "type": "software"
    },
    {
      "id": "trimmomatic",
      "label": "trimmomatic",
      "type": "software"
    },
    {
      "id": "htseq",
      "label": "htseq",
      "type": "software"
    },
    {
      "id": "vsearch",
      "label": "vsearch",
      "type": "software"
    },
    {
      "id": "r-ampvis2",
      "label": "r-ampvis2",
      "type": "software"
    },
    {
      "id": "racon",
      "label": "racon",
      "type": "software"
    },
    {
      "id": "chopper",
      "label": "chopper",
      "type": "software"
    },
    {
      "id": "bio/sambamba/sort\"",
      "label": "bio/sambamba/sort\"",
      "type": "software"
    },
    {
      "id": "bedops",
      "label": "bedops",
      "type": "software"
    },
    {
      "id": "slamdunk",
      "label": "slamdunk",
      "type": "software"
    },
    {
      "id": "bio/assembly-stats\"",
      "label": "bio/assembly-stats\"",
      "type": "software"
    },
    {
      "id": "bio/mapdamage2\"",
      "label": "bio/mapdamage2\"",
      "type": "software"
    },
    {
      "id": "bio/bwa/aln\"",
      "label": "bio/bwa/aln\"",
      "type": "software"
    },
    {
      "id": "bio/bwa/samse\"",
      "label": "bio/bwa/samse\"",
      "type": "software"
    },
    {
      "id": "dedup",
      "label": "dedup",
      "type": "software"
    },
    {
      "id": "bio/gatk3/realignertargetcreator\"",
      "label": "bio/gatk3/realignertargetcreator\"",
      "type": "software"
    },
    {
      "id": "bio/gatk3/indelrealigner\"",
      "label": "bio/gatk3/indelrealigner\"",
      "type": "software"
    },
    {
      "id": "gmap",
      "label": "gmap",
      "type": "software"
    },
    {
      "id": "bio/gmap/build\"",
      "label": "bio/gmap/build\"",
      "type": "software"
    },
    {
      "id": "bio/gmap/map\"",
      "label": "bio/gmap/map\"",
      "type": "software"
    }
  ],
  "links": [
    {
      "source": "all",
      "target": "click"
    },
    {
      "source": "all",
      "target": "python"
    },
    {
      "source": "all",
      "target": "curl"
    },
    {
      "source": "slope_too_steep",
      "target": "netcdf4"
    },
    {
      "source": "slope_too_steep",
      "target": "pandas"
    },
    {
      "source": "slope_too_steep",
      "target": "xarray"
    },
    {
      "source": "slope_too_steep",
      "target": "python"
    },
    {
      "source": "slope_too_steep",
      "target": "pyarrow"
    },
    {
      "source": "slope_too_steep",
      "target": "libgdal-hdf5"
    },
    {
      "source": "slope_too_steep",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "slope_too_steep",
      "target": "fiona"
    },
    {
      "source": "slope_too_steep",
      "target": "matplotlib"
    },
    {
      "source": "slope_too_steep",
      "target": "geopandas"
    },
    {
      "source": "slope_too_steep",
      "target": "pyyaml"
    },
    {
      "source": "slope_too_steep",
      "target": "click"
    },
    {
      "source": "slope_too_steep",
      "target": "rioxarray"
    },
    {
      "source": "slope_too_steep",
      "target": "rasterio"
    },
    {
      "source": "suitable_land_cover",
      "target": "netcdf4"
    },
    {
      "source": "suitable_land_cover",
      "target": "pandas"
    },
    {
      "source": "suitable_land_cover",
      "target": "xarray"
    },
    {
      "source": "suitable_land_cover",
      "target": "python"
    },
    {
      "source": "suitable_land_cover",
      "target": "pyarrow"
    },
    {
      "source": "suitable_land_cover",
      "target": "libgdal-hdf5"
    },
    {
      "source": "suitable_land_cover",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "suitable_land_cover",
      "target": "fiona"
    },
    {
      "source": "suitable_land_cover",
      "target": "matplotlib"
    },
    {
      "source": "suitable_land_cover",
      "target": "geopandas"
    },
    {
      "source": "suitable_land_cover",
      "target": "pyyaml"
    },
    {
      "source": "suitable_land_cover",
      "target": "click"
    },
    {
      "source": "suitable_land_cover",
      "target": "rioxarray"
    },
    {
      "source": "suitable_land_cover",
      "target": "rasterio"
    },
    {
      "source": "resample_same_resolution",
      "target": "netcdf4"
    },
    {
      "source": "resample_same_resolution",
      "target": "pandas"
    },
    {
      "source": "resample_same_resolution",
      "target": "xarray"
    },
    {
      "source": "resample_same_resolution",
      "target": "python"
    },
    {
      "source": "resample_same_resolution",
      "target": "pyarrow"
    },
    {
      "source": "resample_same_resolution",
      "target": "libgdal-hdf5"
    },
    {
      "source": "resample_same_resolution",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "resample_same_resolution",
      "target": "fiona"
    },
    {
      "source": "resample_same_resolution",
      "target": "matplotlib"
    },
    {
      "source": "resample_same_resolution",
      "target": "geopandas"
    },
    {
      "source": "resample_same_resolution",
      "target": "pyyaml"
    },
    {
      "source": "resample_same_resolution",
      "target": "click"
    },
    {
      "source": "resample_same_resolution",
      "target": "rioxarray"
    },
    {
      "source": "resample_same_resolution",
      "target": "rasterio"
    },
    {
      "source": "technical_mask",
      "target": "netcdf4"
    },
    {
      "source": "technical_mask",
      "target": "pandas"
    },
    {
      "source": "technical_mask",
      "target": "xarray"
    },
    {
      "source": "technical_mask",
      "target": "python"
    },
    {
      "source": "technical_mask",
      "target": "pyarrow"
    },
    {
      "source": "technical_mask",
      "target": "libgdal-hdf5"
    },
    {
      "source": "technical_mask",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "technical_mask",
      "target": "fiona"
    },
    {
      "source": "technical_mask",
      "target": "matplotlib"
    },
    {
      "source": "technical_mask",
      "target": "geopandas"
    },
    {
      "source": "technical_mask",
      "target": "pyyaml"
    },
    {
      "source": "technical_mask",
      "target": "click"
    },
    {
      "source": "technical_mask",
      "target": "rioxarray"
    },
    {
      "source": "technical_mask",
      "target": "rasterio"
    },
    {
      "source": "area_potential",
      "target": "glom"
    },
    {
      "source": "area_potential",
      "target": "pyproj"
    },
    {
      "source": "area_potential",
      "target": "dask"
    },
    {
      "source": "area_potential",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "area_potential",
      "target": "pyarrow"
    },
    {
      "source": "area_potential",
      "target": "rasterio"
    },
    {
      "source": "area_potential",
      "target": "netcdf4"
    },
    {
      "source": "area_potential",
      "target": "xarray"
    },
    {
      "source": "area_potential",
      "target": "fiona"
    },
    {
      "source": "area_potential",
      "target": "pyyaml"
    },
    {
      "source": "area_potential",
      "target": "utm"
    },
    {
      "source": "area_potential",
      "target": "python"
    },
    {
      "source": "area_potential",
      "target": "gdal"
    },
    {
      "source": "area_potential",
      "target": "pandera-geopandas"
    },
    {
      "source": "area_potential",
      "target": "pandas"
    },
    {
      "source": "area_potential",
      "target": "libgdal-hdf5"
    },
    {
      "source": "area_potential",
      "target": "matplotlib"
    },
    {
      "source": "area_potential",
      "target": "geopandas"
    },
    {
      "source": "area_potential",
      "target": "click"
    },
    {
      "source": "area_potential",
      "target": "rioxarray"
    },
    {
      "source": "cutout_landcover",
      "target": "netcdf4"
    },
    {
      "source": "cutout_landcover",
      "target": "pandas"
    },
    {
      "source": "cutout_landcover",
      "target": "xarray"
    },
    {
      "source": "cutout_landcover",
      "target": "python"
    },
    {
      "source": "cutout_landcover",
      "target": "pyarrow"
    },
    {
      "source": "cutout_landcover",
      "target": "libgdal-hdf5"
    },
    {
      "source": "cutout_landcover",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "cutout_landcover",
      "target": "fiona"
    },
    {
      "source": "cutout_landcover",
      "target": "matplotlib"
    },
    {
      "source": "cutout_landcover",
      "target": "geopandas"
    },
    {
      "source": "cutout_landcover",
      "target": "pyyaml"
    },
    {
      "source": "cutout_landcover",
      "target": "click"
    },
    {
      "source": "cutout_landcover",
      "target": "rioxarray"
    },
    {
      "source": "cutout_landcover",
      "target": "rasterio"
    },
    {
      "source": "cutout_landseamask",
      "target": "netcdf4"
    },
    {
      "source": "cutout_landseamask",
      "target": "pandas"
    },
    {
      "source": "cutout_landseamask",
      "target": "xarray"
    },
    {
      "source": "cutout_landseamask",
      "target": "python"
    },
    {
      "source": "cutout_landseamask",
      "target": "pyarrow"
    },
    {
      "source": "cutout_landseamask",
      "target": "libgdal-hdf5"
    },
    {
      "source": "cutout_landseamask",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "cutout_landseamask",
      "target": "fiona"
    },
    {
      "source": "cutout_landseamask",
      "target": "matplotlib"
    },
    {
      "source": "cutout_landseamask",
      "target": "geopandas"
    },
    {
      "source": "cutout_landseamask",
      "target": "pyyaml"
    },
    {
      "source": "cutout_landseamask",
      "target": "click"
    },
    {
      "source": "cutout_landseamask",
      "target": "rioxarray"
    },
    {
      "source": "cutout_landseamask",
      "target": "rasterio"
    },
    {
      "source": "cutout_settlement",
      "target": "netcdf4"
    },
    {
      "source": "cutout_settlement",
      "target": "pandas"
    },
    {
      "source": "cutout_settlement",
      "target": "xarray"
    },
    {
      "source": "cutout_settlement",
      "target": "python"
    },
    {
      "source": "cutout_settlement",
      "target": "pyarrow"
    },
    {
      "source": "cutout_settlement",
      "target": "libgdal-hdf5"
    },
    {
      "source": "cutout_settlement",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "cutout_settlement",
      "target": "fiona"
    },
    {
      "source": "cutout_settlement",
      "target": "matplotlib"
    },
    {
      "source": "cutout_settlement",
      "target": "geopandas"
    },
    {
      "source": "cutout_settlement",
      "target": "pyyaml"
    },
    {
      "source": "cutout_settlement",
      "target": "click"
    },
    {
      "source": "cutout_settlement",
      "target": "rioxarray"
    },
    {
      "source": "cutout_settlement",
      "target": "rasterio"
    },
    {
      "source": "download_cutout_slope",
      "target": "geo/rasterio/clip-geotiff\""
    },
    {
      "source": "download_cutout_bathymetry",
      "target": "geo/rasterio/clip-geotiff\""
    },
    {
      "source": "download_wdpa",
      "target": "curl"
    },
    {
      "source": "unzip_wdpa",
      "target": "curl"
    },
    {
      "source": "download_globcover",
      "target": "click"
    },
    {
      "source": "download_globcover",
      "target": "python"
    },
    {
      "source": "download_globcover",
      "target": "curl"
    },
    {
      "source": "unzip_globcover",
      "target": "click"
    },
    {
      "source": "unzip_globcover",
      "target": "python"
    },
    {
      "source": "unzip_globcover",
      "target": "curl"
    },
    {
      "source": "download_ghsl",
      "target": "click"
    },
    {
      "source": "download_ghsl",
      "target": "python"
    },
    {
      "source": "download_ghsl",
      "target": "curl"
    },
    {
      "source": "unzip_ghsl",
      "target": "click"
    },
    {
      "source": "unzip_ghsl",
      "target": "python"
    },
    {
      "source": "unzip_ghsl",
      "target": "curl"
    },
    {
      "source": "get_genome",
      "target": "bio/reference/ensembl-sequence\""
    },
    {
      "source": "get_genome",
      "target": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/get_genome\""
    },
    {
      "source": "get_genome",
      "target": "gzip"
    },
    {
      "source": "get_genome",
      "target": "wget"
    },
    {
      "source": "validate_genome",
      "target": "python"
    },
    {
      "source": "validate_genome",
      "target": "biopython"
    },
    {
      "source": "simulate_reads",
      "target": "dwgsim"
    },
    {
      "source": "fastqc",
      "target": "multiqc"
    },
    {
      "source": "fastqc",
      "target": "pandas"
    },
    {
      "source": "fastqc",
      "target": "deeptools"
    },
    {
      "source": "fastqc",
      "target": "bio/fastqc\""
    },
    {
      "source": "fastqc",
      "target": "fastqc"
    },
    {
      "source": "fastqc",
      "target": "bedtools"
    },
    {
      "source": "fastqc",
      "target": "numpy"
    },
    {
      "source": "multiqc",
      "target": "bio/multiqc\""
    },
    {
      "source": "multiqc",
      "target": "multiqc"
    },
    {
      "source": "multiqc",
      "target": "pandas"
    },
    {
      "source": "multiqc",
      "target": "deeptools"
    },
    {
      "source": "multiqc",
      "target": "fastqc"
    },
    {
      "source": "multiqc",
      "target": "bedtools"
    },
    {
      "source": "multiqc",
      "target": "numpy"
    },
    {
      "source": "multiqc",
      "target": "procps-ng"
    },
    {
      "source": "multiqc",
      "target": "rich-click"
    },
    {
      "source": "predict_genes",
      "target": "prodigal"
    },
    {
      "source": "run_spades",
      "target": "spades"
    },
    {
      "source": "rename_contigs",
      "target": "pandas"
    },
    {
      "source": "rename_contigs",
      "target": "python"
    },
    {
      "source": "rename_contigs",
      "target": "sambamba"
    },
    {
      "source": "rename_contigs",
      "target": "bcftools"
    },
    {
      "source": "rename_contigs",
      "target": "bzip2"
    },
    {
      "source": "rename_contigs",
      "target": "curl"
    },
    {
      "source": "rename_contigs",
      "target": "bbmap"
    },
    {
      "source": "rename_contigs",
      "target": "pigz"
    },
    {
      "source": "rename_contigs",
      "target": "samtools"
    },
    {
      "source": "rename_contigs",
      "target": "bedtools"
    },
    {
      "source": "rename_contigs",
      "target": "ucsc-liftover"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "bbmap"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "pigz"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "samtools"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "pandas"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "python"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "sambamba"
    },
    {
      "source": "calculate_contigs_stats",
      "target": "bzip2"
    },
    {
      "source": "align_reads_to_final_contigs",
      "target": "bio/minimap2/aligner\""
    },
    {
      "source": "pileup_contigs_sample",
      "target": "bbmap"
    },
    {
      "source": "pileup_contigs_sample",
      "target": "pigz"
    },
    {
      "source": "pileup_contigs_sample",
      "target": "samtools"
    },
    {
      "source": "pileup_contigs_sample",
      "target": "pandas"
    },
    {
      "source": "pileup_contigs_sample",
      "target": "python"
    },
    {
      "source": "pileup_contigs_sample",
      "target": "sambamba"
    },
    {
      "source": "pileup_contigs_sample",
      "target": "bzip2"
    },
    {
      "source": "create_bam_index",
      "target": "bbmap"
    },
    {
      "source": "create_bam_index",
      "target": "pigz"
    },
    {
      "source": "create_bam_index",
      "target": "samtools"
    },
    {
      "source": "create_bam_index",
      "target": "pandas"
    },
    {
      "source": "create_bam_index",
      "target": "python"
    },
    {
      "source": "create_bam_index",
      "target": "sambamba"
    },
    {
      "source": "create_bam_index",
      "target": "bzip2"
    },
    {
      "source": "run_megahit",
      "target": "megahit"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "bbmap"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "pigz"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "samtools"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "pandas"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "python"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "sambamba"
    },
    {
      "source": "init_pre_assembly_processing",
      "target": "bzip2"
    },
    {
      "source": "error_correction",
      "target": "bbmap"
    },
    {
      "source": "error_correction",
      "target": "pigz"
    },
    {
      "source": "error_correction",
      "target": "samtools"
    },
    {
      "source": "error_correction",
      "target": "pandas"
    },
    {
      "source": "error_correction",
      "target": "python"
    },
    {
      "source": "error_correction",
      "target": "sambamba"
    },
    {
      "source": "error_correction",
      "target": "bzip2"
    },
    {
      "source": "merge_pairs",
      "target": "bbmap"
    },
    {
      "source": "merge_pairs",
      "target": "pigz"
    },
    {
      "source": "merge_pairs",
      "target": "samtools"
    },
    {
      "source": "merge_pairs",
      "target": "pandas"
    },
    {
      "source": "merge_pairs",
      "target": "python"
    },
    {
      "source": "merge_pairs",
      "target": "sambamba"
    },
    {
      "source": "merge_pairs",
      "target": "bzip2"
    },
    {
      "source": "kallisto_quant_to_gfold_input",
      "target": "r-tidyverse"
    },
    {
      "source": "gfold",
      "target": "gfold"
    },
    {
      "source": "clean_and_sort_gfold",
      "target": "r-tidyverse"
    },
    {
      "source": "gfold_datavzrd",
      "target": "utils/datavzrd\""
    },
    {
      "source": "spia_datavzrd",
      "target": "utils/datavzrd\""
    },
    {
      "source": "gseapy",
      "target": "jupyter"
    },
    {
      "source": "gseapy",
      "target": "gseapy"
    },
    {
      "source": "gseapy",
      "target": "python"
    },
    {
      "source": "gseapy",
      "target": "ipykernel"
    },
    {
      "source": "annotate_variants",
      "target": "bio/vep/annotate\""
    },
    {
      "source": "call_variants",
      "target": "\"file:///share/home/ychi/dev/dna-seq-gatk-variant-calling/wrappers/haplotypcaller\""
    },
    {
      "source": "call_variants",
      "target": "bio/gatk/haplotypecaller\""
    },
    {
      "source": "combine_calls",
      "target": "bio/gatk/combinegvcfs\""
    },
    {
      "source": "genotype_variants",
      "target": "bio/gatk/genotypegvcfs\""
    },
    {
      "source": "merge_variants",
      "target": "bio/picard/mergevcfs\""
    },
    {
      "source": "genome_faidx",
      "target": "samtools"
    },
    {
      "source": "genome_faidx",
      "target": "bio/samtools/faidx\""
    },
    {
      "source": "get_known_variation",
      "target": "bio/reference/ensembl-variation\""
    },
    {
      "source": "tabix_known_variants",
      "target": "bio/tabix\""
    },
    {
      "source": "tabix_known_variants",
      "target": "bio/tabix/index\""
    },
    {
      "source": "bwa_index",
      "target": "bio/bwa/index\""
    },
    {
      "source": "get_vep_cache",
      "target": "bio/vep/cache\""
    },
    {
      "source": "get_vep_plugins",
      "target": "bio/vep/plugins\""
    },
    {
      "source": "samtools_stats",
      "target": "bio/samtools/stats\""
    },
    {
      "source": "trim_reads_se",
      "target": "bio/trimmomatic/se\""
    },
    {
      "source": "trim_reads_pe",
      "target": "bio/trimmomatic/pe\""
    },
    {
      "source": "map_reads",
      "target": "bio/bwa/mem\""
    },
    {
      "source": "mark_duplicates",
      "target": "bio/picard/markduplicates\""
    },
    {
      "source": "recalibrate_base_qualities",
      "target": "bio/gatk/baserecalibrator\""
    },
    {
      "source": "samtools_index",
      "target": "bio/samtools/faidx\""
    },
    {
      "source": "samtools_index",
      "target": "bio/samtools/index\""
    },
    {
      "source": "select_calls",
      "target": "bio/gatk/selectvariants\""
    },
    {
      "source": "hard_filter_calls",
      "target": "bio/gatk/variantfiltration\""
    },
    {
      "source": "recalibrate_calls",
      "target": "bio/gatk/variantrecalibrator\""
    },
    {
      "source": "merge_calls",
      "target": "bio/picard/mergevcfs\""
    },
    {
      "source": "glori_trim_dedup",
      "target": "fastp"
    },
    {
      "source": "glori_uncompress_fastq",
      "target": "fastp"
    },
    {
      "source": "glori_trim_umi",
      "target": "fastx_toolkit"
    },
    {
      "source": "trimgalore",
      "target": "trim-galore"
    },
    {
      "source": "aggregate_capacity",
      "target": "pyproj"
    },
    {
      "source": "aggregate_capacity",
      "target": "openpyxl"
    },
    {
      "source": "aggregate_capacity",
      "target": "dask"
    },
    {
      "source": "aggregate_capacity",
      "target": "ipdb"
    },
    {
      "source": "aggregate_capacity",
      "target": "python"
    },
    {
      "source": "aggregate_capacity",
      "target": "xlrd"
    },
    {
      "source": "aggregate_capacity",
      "target": "pyarrow"
    },
    {
      "source": "aggregate_capacity",
      "target": "pandera-geopandas"
    },
    {
      "source": "aggregate_capacity",
      "target": "pandas"
    },
    {
      "source": "aggregate_capacity",
      "target": "matplotlib"
    },
    {
      "source": "aggregate_capacity",
      "target": "geopandas"
    },
    {
      "source": "aggregate_capacity",
      "target": "numpy"
    },
    {
      "source": "aggregate_capacity",
      "target": "click"
    },
    {
      "source": "aggregate_capacity",
      "target": "pip"
    },
    {
      "source": "aggregate_capacity",
      "target": "cmap"
    },
    {
      "source": "aggregate_capacity",
      "target": "pyyaml"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "pyproj"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "openpyxl"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "dask"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "ipdb"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "python"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "xlrd"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "pyarrow"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "pandera-geopandas"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "pandas"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "matplotlib"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "geopandas"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "numpy"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "click"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "pip"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "cmap"
    },
    {
      "source": "proxy_rooftop_pv",
      "target": "pyyaml"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "pyproj"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "openpyxl"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "dask"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "ipdb"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "python"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "xlrd"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "pyarrow"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "pandera-geopandas"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "pandas"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "matplotlib"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "geopandas"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "numpy"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "click"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "pip"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "cmap"
    },
    {
      "source": "impute_adjustment_solar",
      "target": "pyyaml"
    },
    {
      "source": "prepare_hydropower",
      "target": "pyproj"
    },
    {
      "source": "prepare_hydropower",
      "target": "openpyxl"
    },
    {
      "source": "prepare_hydropower",
      "target": "dask"
    },
    {
      "source": "prepare_hydropower",
      "target": "ipdb"
    },
    {
      "source": "prepare_hydropower",
      "target": "python"
    },
    {
      "source": "prepare_hydropower",
      "target": "xlrd"
    },
    {
      "source": "prepare_hydropower",
      "target": "pyarrow"
    },
    {
      "source": "prepare_hydropower",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_hydropower",
      "target": "pandas"
    },
    {
      "source": "prepare_hydropower",
      "target": "matplotlib"
    },
    {
      "source": "prepare_hydropower",
      "target": "geopandas"
    },
    {
      "source": "prepare_hydropower",
      "target": "numpy"
    },
    {
      "source": "prepare_hydropower",
      "target": "click"
    },
    {
      "source": "prepare_hydropower",
      "target": "pip"
    },
    {
      "source": "prepare_hydropower",
      "target": "cmap"
    },
    {
      "source": "prepare_hydropower",
      "target": "pyyaml"
    },
    {
      "source": "prepare_large_solar",
      "target": "pyproj"
    },
    {
      "source": "prepare_large_solar",
      "target": "openpyxl"
    },
    {
      "source": "prepare_large_solar",
      "target": "dask"
    },
    {
      "source": "prepare_large_solar",
      "target": "ipdb"
    },
    {
      "source": "prepare_large_solar",
      "target": "python"
    },
    {
      "source": "prepare_large_solar",
      "target": "xlrd"
    },
    {
      "source": "prepare_large_solar",
      "target": "pyarrow"
    },
    {
      "source": "prepare_large_solar",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_large_solar",
      "target": "pandas"
    },
    {
      "source": "prepare_large_solar",
      "target": "matplotlib"
    },
    {
      "source": "prepare_large_solar",
      "target": "geopandas"
    },
    {
      "source": "prepare_large_solar",
      "target": "numpy"
    },
    {
      "source": "prepare_large_solar",
      "target": "click"
    },
    {
      "source": "prepare_large_solar",
      "target": "pip"
    },
    {
      "source": "prepare_large_solar",
      "target": "cmap"
    },
    {
      "source": "prepare_large_solar",
      "target": "pyyaml"
    },
    {
      "source": "prepare_bioenergy",
      "target": "pyproj"
    },
    {
      "source": "prepare_bioenergy",
      "target": "openpyxl"
    },
    {
      "source": "prepare_bioenergy",
      "target": "dask"
    },
    {
      "source": "prepare_bioenergy",
      "target": "ipdb"
    },
    {
      "source": "prepare_bioenergy",
      "target": "python"
    },
    {
      "source": "prepare_bioenergy",
      "target": "xlrd"
    },
    {
      "source": "prepare_bioenergy",
      "target": "pyarrow"
    },
    {
      "source": "prepare_bioenergy",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_bioenergy",
      "target": "pandas"
    },
    {
      "source": "prepare_bioenergy",
      "target": "matplotlib"
    },
    {
      "source": "prepare_bioenergy",
      "target": "geopandas"
    },
    {
      "source": "prepare_bioenergy",
      "target": "numpy"
    },
    {
      "source": "prepare_bioenergy",
      "target": "click"
    },
    {
      "source": "prepare_bioenergy",
      "target": "pip"
    },
    {
      "source": "prepare_bioenergy",
      "target": "cmap"
    },
    {
      "source": "prepare_bioenergy",
      "target": "pyyaml"
    },
    {
      "source": "prepare_fossil",
      "target": "pyproj"
    },
    {
      "source": "prepare_fossil",
      "target": "openpyxl"
    },
    {
      "source": "prepare_fossil",
      "target": "dask"
    },
    {
      "source": "prepare_fossil",
      "target": "ipdb"
    },
    {
      "source": "prepare_fossil",
      "target": "python"
    },
    {
      "source": "prepare_fossil",
      "target": "xlrd"
    },
    {
      "source": "prepare_fossil",
      "target": "pyarrow"
    },
    {
      "source": "prepare_fossil",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_fossil",
      "target": "pandas"
    },
    {
      "source": "prepare_fossil",
      "target": "matplotlib"
    },
    {
      "source": "prepare_fossil",
      "target": "geopandas"
    },
    {
      "source": "prepare_fossil",
      "target": "numpy"
    },
    {
      "source": "prepare_fossil",
      "target": "click"
    },
    {
      "source": "prepare_fossil",
      "target": "pip"
    },
    {
      "source": "prepare_fossil",
      "target": "cmap"
    },
    {
      "source": "prepare_fossil",
      "target": "pyyaml"
    },
    {
      "source": "prepare_nuclear",
      "target": "pyproj"
    },
    {
      "source": "prepare_nuclear",
      "target": "openpyxl"
    },
    {
      "source": "prepare_nuclear",
      "target": "dask"
    },
    {
      "source": "prepare_nuclear",
      "target": "ipdb"
    },
    {
      "source": "prepare_nuclear",
      "target": "python"
    },
    {
      "source": "prepare_nuclear",
      "target": "xlrd"
    },
    {
      "source": "prepare_nuclear",
      "target": "pyarrow"
    },
    {
      "source": "prepare_nuclear",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_nuclear",
      "target": "pandas"
    },
    {
      "source": "prepare_nuclear",
      "target": "matplotlib"
    },
    {
      "source": "prepare_nuclear",
      "target": "geopandas"
    },
    {
      "source": "prepare_nuclear",
      "target": "numpy"
    },
    {
      "source": "prepare_nuclear",
      "target": "click"
    },
    {
      "source": "prepare_nuclear",
      "target": "pip"
    },
    {
      "source": "prepare_nuclear",
      "target": "cmap"
    },
    {
      "source": "prepare_nuclear",
      "target": "pyyaml"
    },
    {
      "source": "prepare_geothermal",
      "target": "pyproj"
    },
    {
      "source": "prepare_geothermal",
      "target": "openpyxl"
    },
    {
      "source": "prepare_geothermal",
      "target": "dask"
    },
    {
      "source": "prepare_geothermal",
      "target": "ipdb"
    },
    {
      "source": "prepare_geothermal",
      "target": "python"
    },
    {
      "source": "prepare_geothermal",
      "target": "xlrd"
    },
    {
      "source": "prepare_geothermal",
      "target": "pyarrow"
    },
    {
      "source": "prepare_geothermal",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_geothermal",
      "target": "pandas"
    },
    {
      "source": "prepare_geothermal",
      "target": "matplotlib"
    },
    {
      "source": "prepare_geothermal",
      "target": "geopandas"
    },
    {
      "source": "prepare_geothermal",
      "target": "numpy"
    },
    {
      "source": "prepare_geothermal",
      "target": "click"
    },
    {
      "source": "prepare_geothermal",
      "target": "pip"
    },
    {
      "source": "prepare_geothermal",
      "target": "cmap"
    },
    {
      "source": "prepare_geothermal",
      "target": "pyyaml"
    },
    {
      "source": "prepare_statistics",
      "target": "pyproj"
    },
    {
      "source": "prepare_statistics",
      "target": "openpyxl"
    },
    {
      "source": "prepare_statistics",
      "target": "dask"
    },
    {
      "source": "prepare_statistics",
      "target": "ipdb"
    },
    {
      "source": "prepare_statistics",
      "target": "python"
    },
    {
      "source": "prepare_statistics",
      "target": "xlrd"
    },
    {
      "source": "prepare_statistics",
      "target": "pyarrow"
    },
    {
      "source": "prepare_statistics",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_statistics",
      "target": "pandas"
    },
    {
      "source": "prepare_statistics",
      "target": "matplotlib"
    },
    {
      "source": "prepare_statistics",
      "target": "geopandas"
    },
    {
      "source": "prepare_statistics",
      "target": "numpy"
    },
    {
      "source": "prepare_statistics",
      "target": "click"
    },
    {
      "source": "prepare_statistics",
      "target": "pip"
    },
    {
      "source": "prepare_statistics",
      "target": "cmap"
    },
    {
      "source": "prepare_statistics",
      "target": "pyyaml"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "pyproj"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "openpyxl"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "dask"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "ipdb"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "python"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "xlrd"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "pyarrow"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "pandas"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "matplotlib"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "geopandas"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "numpy"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "click"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "pip"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "cmap"
    },
    {
      "source": "prepare_fuel_classes",
      "target": "pyyaml"
    },
    {
      "source": "remap_fuel_classes",
      "target": "pyproj"
    },
    {
      "source": "remap_fuel_classes",
      "target": "openpyxl"
    },
    {
      "source": "remap_fuel_classes",
      "target": "dask"
    },
    {
      "source": "remap_fuel_classes",
      "target": "ipdb"
    },
    {
      "source": "remap_fuel_classes",
      "target": "python"
    },
    {
      "source": "remap_fuel_classes",
      "target": "xlrd"
    },
    {
      "source": "remap_fuel_classes",
      "target": "pyarrow"
    },
    {
      "source": "remap_fuel_classes",
      "target": "pandera-geopandas"
    },
    {
      "source": "remap_fuel_classes",
      "target": "pandas"
    },
    {
      "source": "remap_fuel_classes",
      "target": "matplotlib"
    },
    {
      "source": "remap_fuel_classes",
      "target": "geopandas"
    },
    {
      "source": "remap_fuel_classes",
      "target": "numpy"
    },
    {
      "source": "remap_fuel_classes",
      "target": "click"
    },
    {
      "source": "remap_fuel_classes",
      "target": "pip"
    },
    {
      "source": "remap_fuel_classes",
      "target": "cmap"
    },
    {
      "source": "remap_fuel_classes",
      "target": "pyyaml"
    },
    {
      "source": "prepare_shapes",
      "target": "pyproj"
    },
    {
      "source": "prepare_shapes",
      "target": "openpyxl"
    },
    {
      "source": "prepare_shapes",
      "target": "dask"
    },
    {
      "source": "prepare_shapes",
      "target": "ipdb"
    },
    {
      "source": "prepare_shapes",
      "target": "python"
    },
    {
      "source": "prepare_shapes",
      "target": "xlrd"
    },
    {
      "source": "prepare_shapes",
      "target": "pyarrow"
    },
    {
      "source": "prepare_shapes",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_shapes",
      "target": "pandas"
    },
    {
      "source": "prepare_shapes",
      "target": "matplotlib"
    },
    {
      "source": "prepare_shapes",
      "target": "geopandas"
    },
    {
      "source": "prepare_shapes",
      "target": "numpy"
    },
    {
      "source": "prepare_shapes",
      "target": "click"
    },
    {
      "source": "prepare_shapes",
      "target": "pip"
    },
    {
      "source": "prepare_shapes",
      "target": "cmap"
    },
    {
      "source": "prepare_shapes",
      "target": "pyyaml"
    },
    {
      "source": "download_eia",
      "target": "curl"
    },
    {
      "source": "download_tz_sam",
      "target": "curl"
    },
    {
      "source": "download_glohydrores",
      "target": "curl"
    },
    {
      "source": "download_gem",
      "target": "curl"
    },
    {
      "source": "impute_location",
      "target": "pyproj"
    },
    {
      "source": "impute_location",
      "target": "openpyxl"
    },
    {
      "source": "impute_location",
      "target": "dask"
    },
    {
      "source": "impute_location",
      "target": "ipdb"
    },
    {
      "source": "impute_location",
      "target": "python"
    },
    {
      "source": "impute_location",
      "target": "xlrd"
    },
    {
      "source": "impute_location",
      "target": "pyarrow"
    },
    {
      "source": "impute_location",
      "target": "pandera-geopandas"
    },
    {
      "source": "impute_location",
      "target": "pandas"
    },
    {
      "source": "impute_location",
      "target": "matplotlib"
    },
    {
      "source": "impute_location",
      "target": "geopandas"
    },
    {
      "source": "impute_location",
      "target": "numpy"
    },
    {
      "source": "impute_location",
      "target": "click"
    },
    {
      "source": "impute_location",
      "target": "pip"
    },
    {
      "source": "impute_location",
      "target": "cmap"
    },
    {
      "source": "impute_location",
      "target": "pyyaml"
    },
    {
      "source": "impute_time",
      "target": "pyproj"
    },
    {
      "source": "impute_time",
      "target": "openpyxl"
    },
    {
      "source": "impute_time",
      "target": "dask"
    },
    {
      "source": "impute_time",
      "target": "ipdb"
    },
    {
      "source": "impute_time",
      "target": "python"
    },
    {
      "source": "impute_time",
      "target": "xlrd"
    },
    {
      "source": "impute_time",
      "target": "pyarrow"
    },
    {
      "source": "impute_time",
      "target": "pandera-geopandas"
    },
    {
      "source": "impute_time",
      "target": "pandas"
    },
    {
      "source": "impute_time",
      "target": "matplotlib"
    },
    {
      "source": "impute_time",
      "target": "geopandas"
    },
    {
      "source": "impute_time",
      "target": "numpy"
    },
    {
      "source": "impute_time",
      "target": "click"
    },
    {
      "source": "impute_time",
      "target": "pip"
    },
    {
      "source": "impute_time",
      "target": "cmap"
    },
    {
      "source": "impute_time",
      "target": "pyyaml"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "pyproj"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "openpyxl"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "dask"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "ipdb"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "python"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "xlrd"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "pyarrow"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "pandera-geopandas"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "pandas"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "matplotlib"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "geopandas"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "numpy"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "click"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "pip"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "cmap"
    },
    {
      "source": "impute_capacity_adjustment",
      "target": "pyyaml"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pyproj"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pandera"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pandas"
    },
    {
      "source": "aggregate_co2stop",
      "target": "ipdb"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pyarrow"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pandera-pandas"
    },
    {
      "source": "aggregate_co2stop",
      "target": "matplotlib"
    },
    {
      "source": "aggregate_co2stop",
      "target": "python"
    },
    {
      "source": "aggregate_co2stop",
      "target": "fiona"
    },
    {
      "source": "aggregate_co2stop",
      "target": "geopandas"
    },
    {
      "source": "aggregate_co2stop",
      "target": "numpy"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pandera-base"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pytz"
    },
    {
      "source": "aggregate_co2stop",
      "target": "cmap"
    },
    {
      "source": "aggregate_co2stop",
      "target": "pandera-geopandas"
    },
    {
      "source": "aggregate_totals",
      "target": "pyproj"
    },
    {
      "source": "aggregate_totals",
      "target": "pandera"
    },
    {
      "source": "aggregate_totals",
      "target": "pandas"
    },
    {
      "source": "aggregate_totals",
      "target": "ipdb"
    },
    {
      "source": "aggregate_totals",
      "target": "pyarrow"
    },
    {
      "source": "aggregate_totals",
      "target": "pandera-pandas"
    },
    {
      "source": "aggregate_totals",
      "target": "matplotlib"
    },
    {
      "source": "aggregate_totals",
      "target": "python"
    },
    {
      "source": "aggregate_totals",
      "target": "fiona"
    },
    {
      "source": "aggregate_totals",
      "target": "geopandas"
    },
    {
      "source": "aggregate_totals",
      "target": "numpy"
    },
    {
      "source": "aggregate_totals",
      "target": "pandera-base"
    },
    {
      "source": "aggregate_totals",
      "target": "pytz"
    },
    {
      "source": "aggregate_totals",
      "target": "cmap"
    },
    {
      "source": "aggregate_totals",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pyproj"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pandera"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pandas"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "ipdb"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pyarrow"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pandera-pandas"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "matplotlib"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "python"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "fiona"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "geopandas"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "numpy"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pandera-base"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pytz"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "cmap"
    },
    {
      "source": "prepare_co2stop_storage_units",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pyproj"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pandera"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pandas"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "ipdb"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pyarrow"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pandera-pandas"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "matplotlib"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "python"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "fiona"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "geopandas"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "numpy"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pandera-base"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pytz"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "cmap"
    },
    {
      "source": "prepare_co2stop_traps",
      "target": "pandera-geopandas"
    },
    {
      "source": "download_co2stop",
      "target": "curl"
    },
    {
      "source": "unzip_co2stop",
      "target": "pyproj"
    },
    {
      "source": "unzip_co2stop",
      "target": "pandera"
    },
    {
      "source": "unzip_co2stop",
      "target": "pandas"
    },
    {
      "source": "unzip_co2stop",
      "target": "ipdb"
    },
    {
      "source": "unzip_co2stop",
      "target": "pyarrow"
    },
    {
      "source": "unzip_co2stop",
      "target": "pandera-pandas"
    },
    {
      "source": "unzip_co2stop",
      "target": "matplotlib"
    },
    {
      "source": "unzip_co2stop",
      "target": "python"
    },
    {
      "source": "unzip_co2stop",
      "target": "fiona"
    },
    {
      "source": "unzip_co2stop",
      "target": "geopandas"
    },
    {
      "source": "unzip_co2stop",
      "target": "numpy"
    },
    {
      "source": "unzip_co2stop",
      "target": "pandera-base"
    },
    {
      "source": "unzip_co2stop",
      "target": "pytz"
    },
    {
      "source": "unzip_co2stop",
      "target": "cmap"
    },
    {
      "source": "unzip_co2stop",
      "target": "pandera-geopandas"
    },
    {
      "source": "picard_merge_sam",
      "target": "bio/picard/mergesamfiles\""
    },
    {
      "source": "qc_multiqc",
      "target": "multiqc"
    },
    {
      "source": "qc_fastqc",
      "target": "bio/fastqc\""
    },
    {
      "source": "qc_samtools_coverage",
      "target": "samtools"
    },
    {
      "source": "qc_plot_samtools_coverage",
      "target": "r-ggplot2"
    },
    {
      "source": "qc_notebook",
      "target": "pandas"
    },
    {
      "source": "qc_notebook",
      "target": "jupyter_contrib_nbextensions"
    },
    {
      "source": "qc_notebook",
      "target": "jupyter"
    },
    {
      "source": "qc_notebook",
      "target": "jupyterlab_code_formatter"
    },
    {
      "source": "qc_notebook",
      "target": "python"
    },
    {
      "source": "map_bwa_index",
      "target": "bwa"
    },
    {
      "source": "map_bwa_mem",
      "target": "bio/bwa/mem\""
    },
    {
      "source": "pangolin_la",
      "target": "pangolin"
    },
    {
      "source": "fastp_pe",
      "target": "bio/fastp\""
    },
    {
      "source": "bwa_mem",
      "target": "bwa"
    },
    {
      "source": "bwa_mem",
      "target": "bio/bwa/mem-samblaster\""
    },
    {
      "source": "bwa_mem",
      "target": "sambamba"
    },
    {
      "source": "bwa_mem",
      "target": "samtools"
    },
    {
      "source": "bwa_mem",
      "target": "genmap"
    },
    {
      "source": "bwa_mem",
      "target": "fastp"
    },
    {
      "source": "bwa_mem",
      "target": "bio/bwa/mem\""
    },
    {
      "source": "bwa_mem",
      "target": "mosdepth"
    },
    {
      "source": "samtools_sort",
      "target": "bio/samtools/sort\""
    },
    {
      "source": "metaspades_assembly",
      "target": "bio/spades/metaspades\""
    },
    {
      "source": "ragtag_scaffold",
      "target": "ragtag"
    },
    {
      "source": "ragtag_scaffold",
      "target": "minimap2"
    },
    {
      "source": "bcftools_mpileup",
      "target": "bio/bcftools/mpileup\""
    },
    {
      "source": "bcftools_call",
      "target": "bio/bcftools/call\""
    },
    {
      "source": "bcftools_index",
      "target": "bio/bcftools/index\""
    },
    {
      "source": "bcf_consensus",
      "target": "bcftools"
    },
    {
      "source": "csv_report",
      "target": "bio/rbt/csvreport\""
    },
    {
      "source": "generate_report",
      "target": "igv-reports"
    },
    {
      "source": "faToTwoBit",
      "target": "bio/ucsc/faToTwoBit\""
    },
    {
      "source": "bam_to_cram",
      "target": "bio/samtools/view\""
    },
    {
      "source": "index_cram",
      "target": "bio/samtools/index\""
    },
    {
      "source": "sort_umitools_input",
      "target": "bio/samtools/sort\""
    },
    {
      "source": "index_umitools_input",
      "target": "bio/samtools/index\""
    },
    {
      "source": "bam_to_cram_post_processing",
      "target": "bio/samtools/view\""
    },
    {
      "source": "index_cram_post_processing",
      "target": "bio/samtools/index\""
    },
    {
      "source": "gffread_gff",
      "target": "bio/gffread\""
    },
    {
      "source": "rseqc_infer_experiment",
      "target": "bio/rseqc/infer_experiment\""
    },
    {
      "source": "rseqc_infer_experiment",
      "target": "rseqc"
    },
    {
      "source": "rseqc_bam_stat",
      "target": "bio/rseqc/bam_stat\""
    },
    {
      "source": "rseqc_bam_stat",
      "target": "rseqc"
    },
    {
      "source": "deeptools_coverage",
      "target": "bio/deeptools/bamcoverage\""
    },
    {
      "source": "bwa_mem2_index",
      "target": "bio/bwa-mem2/index\""
    },
    {
      "source": "bwa_mem2",
      "target": "bio/bwa-mem2/mem\""
    },
    {
      "source": "minimap2_index",
      "target": "bio/minimap2/index\""
    },
    {
      "source": "minimap2_align",
      "target": "bio/minimap2/aligner\""
    },
    {
      "source": "index_genome_with_overhang_chromosomes",
      "target": "bio/samtools/faidx\""
    },
    {
      "source": "get_fastq",
      "target": "python"
    },
    {
      "source": "fastp",
      "target": "bwa"
    },
    {
      "source": "fastp",
      "target": "bio/fastp\""
    },
    {
      "source": "fastp",
      "target": "samtools"
    },
    {
      "source": "fastp",
      "target": "genmap"
    },
    {
      "source": "fastp",
      "target": "fastp"
    },
    {
      "source": "fastp",
      "target": "sambamba"
    },
    {
      "source": "fastp",
      "target": "mosdepth"
    },
    {
      "source": "trim_galore",
      "target": "bio/trim_galore/pe\""
    },
    {
      "source": "star_index",
      "target": "bio/star/index\""
    },
    {
      "source": "star_align",
      "target": "bio/star/align\""
    },
    {
      "source": "bowtie2_build",
      "target": "bio/bowtie2/build\""
    },
    {
      "source": "bowtie2_align",
      "target": "bio/bowtie2/align\""
    },
    {
      "source": "cutadapt1",
      "target": "python"
    },
    {
      "source": "cutadapt1",
      "target": "cutadapt"
    },
    {
      "source": "cutadapt2",
      "target": "python"
    },
    {
      "source": "cutadapt2",
      "target": "cutadapt"
    },
    {
      "source": "cutadapt3",
      "target": "python"
    },
    {
      "source": "cutadapt3",
      "target": "cutadapt"
    },
    {
      "source": "cutadapt4",
      "target": "python"
    },
    {
      "source": "cutadapt4",
      "target": "cutadapt"
    },
    {
      "source": "transfer",
      "target": "globus-cli"
    },
    {
      "source": "calculate_checksums",
      "target": "pigz"
    },
    {
      "source": "calculate_checksums",
      "target": "tar"
    },
    {
      "source": "calculate_archive_checksums",
      "target": "pigz"
    },
    {
      "source": "calculate_archive_checksums",
      "target": "tar"
    },
    {
      "source": "tar_reports",
      "target": "pigz"
    },
    {
      "source": "tar_reports",
      "target": "tar"
    },
    {
      "source": "falco",
      "target": "falco"
    },
    {
      "source": "download_univec",
      "target": "curl"
    },
    {
      "source": "bam_2_unmapped_paired_fq",
      "target": "samtools"
    },
    {
      "source": "gatk_haplotype_caller",
      "target": "bio/gatk/haplotypecaller\""
    },
    {
      "source": "gatk_genomics_db_import",
      "target": "bio/gatk/genomicsdbimport\""
    },
    {
      "source": "gatk_genotype_gvcfs",
      "target": "bio/gatk/genotypegvcfs\""
    },
    {
      "source": "gatk_filter_variants",
      "target": "bio/gatk/variantfiltration\""
    },
    {
      "source": "gatk_left_align_and_trim_variants",
      "target": "bio/gatk/leftalignandtrimvariants\""
    },
    {
      "source": "gatk_select_variants",
      "target": "bio/gatk/selectvariants\""
    },
    {
      "source": "gatk_variants_to_table",
      "target": "bio/gatk/variantstotable\""
    },
    {
      "source": "bwa_mem_mapping",
      "target": "bio/bwa/mem\""
    },
    {
      "source": "sambamba_mark_duplicates",
      "target": "bio/sambamba/markdup\""
    },
    {
      "source": "download_genome",
      "target": "bio/reference/ensembl-sequence\""
    },
    {
      "source": "download_genome",
      "target": "entrez-direct"
    },
    {
      "source": "samtools_genome_index",
      "target": "bio/samtools/faidx\""
    },
    {
      "source": "picard_create_dict",
      "target": "bio/picard/createsequencedictionary\""
    },
    {
      "source": "barcode_snps",
      "target": "python"
    },
    {
      "source": "barcode_snps",
      "target": "pandas"
    },
    {
      "source": "barcode_snps",
      "target": "numpy"
    },
    {
      "source": "barcode_levels",
      "target": "python"
    },
    {
      "source": "barcode_levels",
      "target": "pandas"
    },
    {
      "source": "barcode_levels",
      "target": "numpy"
    },
    {
      "source": "compute_coverage",
      "target": "samtools"
    },
    {
      "source": "compute_coverage",
      "target": "sed"
    },
    {
      "source": "compute_coverage",
      "target": "survivor"
    },
    {
      "source": "compute_coverage",
      "target": "pandas"
    },
    {
      "source": "compute_coverage",
      "target": "bedtools"
    },
    {
      "source": "compute_coverage",
      "target": "numpy"
    },
    {
      "source": "compute_coverage",
      "target": "python"
    },
    {
      "source": "make_vcf",
      "target": "samtools"
    },
    {
      "source": "make_vcf",
      "target": "sed"
    },
    {
      "source": "make_vcf",
      "target": "survivor"
    },
    {
      "source": "make_vcf",
      "target": "pandas"
    },
    {
      "source": "make_vcf",
      "target": "bedtools"
    },
    {
      "source": "make_vcf",
      "target": "numpy"
    },
    {
      "source": "make_vcf",
      "target": "python"
    },
    {
      "source": "clean_vcf",
      "target": "samtools"
    },
    {
      "source": "clean_vcf",
      "target": "sed"
    },
    {
      "source": "clean_vcf",
      "target": "survivor"
    },
    {
      "source": "clean_vcf",
      "target": "pandas"
    },
    {
      "source": "clean_vcf",
      "target": "bedtools"
    },
    {
      "source": "clean_vcf",
      "target": "numpy"
    },
    {
      "source": "clean_vcf",
      "target": "python"
    },
    {
      "source": "bgzip",
      "target": "bio/bgzip\""
    },
    {
      "source": "filter_vcf",
      "target": "bio/bcftools/filter\""
    },
    {
      "source": "make_list",
      "target": "samtools"
    },
    {
      "source": "make_list",
      "target": "sed"
    },
    {
      "source": "make_list",
      "target": "survivor"
    },
    {
      "source": "make_list",
      "target": "pandas"
    },
    {
      "source": "make_list",
      "target": "bedtools"
    },
    {
      "source": "make_list",
      "target": "numpy"
    },
    {
      "source": "make_list",
      "target": "python"
    },
    {
      "source": "merge_vcf",
      "target": "samtools"
    },
    {
      "source": "merge_vcf",
      "target": "sed"
    },
    {
      "source": "merge_vcf",
      "target": "survivor"
    },
    {
      "source": "merge_vcf",
      "target": "pandas"
    },
    {
      "source": "merge_vcf",
      "target": "bedtools"
    },
    {
      "source": "merge_vcf",
      "target": "numpy"
    },
    {
      "source": "merge_vcf",
      "target": "python"
    },
    {
      "source": "convert2table",
      "target": "gatk4"
    },
    {
      "source": "annotate_rds",
      "target": "samtools"
    },
    {
      "source": "annotate_rds",
      "target": "sed"
    },
    {
      "source": "annotate_rds",
      "target": "survivor"
    },
    {
      "source": "annotate_rds",
      "target": "pandas"
    },
    {
      "source": "annotate_rds",
      "target": "bedtools"
    },
    {
      "source": "annotate_rds",
      "target": "numpy"
    },
    {
      "source": "annotate_rds",
      "target": "python"
    },
    {
      "source": "mosdepth_bed",
      "target": "bio/mosdepth\""
    },
    {
      "source": "calculate_proportion",
      "target": "samtools"
    },
    {
      "source": "calculate_proportion",
      "target": "sed"
    },
    {
      "source": "calculate_proportion",
      "target": "survivor"
    },
    {
      "source": "calculate_proportion",
      "target": "pandas"
    },
    {
      "source": "calculate_proportion",
      "target": "bedtools"
    },
    {
      "source": "calculate_proportion",
      "target": "numpy"
    },
    {
      "source": "calculate_proportion",
      "target": "python"
    },
    {
      "source": "concatenate",
      "target": "samtools"
    },
    {
      "source": "concatenate",
      "target": "sed"
    },
    {
      "source": "concatenate",
      "target": "survivor"
    },
    {
      "source": "concatenate",
      "target": "pandas"
    },
    {
      "source": "concatenate",
      "target": "bedtools"
    },
    {
      "source": "concatenate",
      "target": "numpy"
    },
    {
      "source": "concatenate",
      "target": "python"
    },
    {
      "source": "make_tables",
      "target": "r-base"
    },
    {
      "source": "make_tables",
      "target": "r-tidyverse"
    },
    {
      "source": "make_tables",
      "target": "r-openxlsx"
    },
    {
      "source": "checksum_fq_headers",
      "target": "perl"
    },
    {
      "source": "mapping_overview",
      "target": "perl"
    },
    {
      "source": "abund_table",
      "target": "r-base"
    },
    {
      "source": "abund_table",
      "target": "usearch"
    },
    {
      "source": "abund_table",
      "target": "gzip"
    },
    {
      "source": "abund_table",
      "target": "cutadapt"
    },
    {
      "source": "abund_table",
      "target": "savont"
    },
    {
      "source": "abund_table",
      "target": "filtlong"
    },
    {
      "source": "abund_table",
      "target": "r-dplyr"
    },
    {
      "source": "abund_table",
      "target": "r-data.table"
    },
    {
      "source": "concatenate_fastq",
      "target": "python"
    },
    {
      "source": "concatenate_fastq",
      "target": "gzip"
    },
    {
      "source": "qfilter",
      "target": "filtlong"
    },
    {
      "source": "map2db",
      "target": "samtools"
    },
    {
      "source": "map2db",
      "target": "minimap2"
    },
    {
      "source": "merge_lanes_pe",
      "target": "deeptoolsintervals"
    },
    {
      "source": "merge_lanes_pe",
      "target": "epic2"
    },
    {
      "source": "merge_lanes_pe",
      "target": "pandas"
    },
    {
      "source": "merge_lanes_pe",
      "target": "macs2"
    },
    {
      "source": "merge_lanes_pe",
      "target": "cython"
    },
    {
      "source": "merge_lanes_pe",
      "target": "pysam"
    },
    {
      "source": "merge_lanes_pe",
      "target": "py2bit"
    },
    {
      "source": "merge_lanes_pe",
      "target": "fastp"
    },
    {
      "source": "merge_lanes_pe",
      "target": "numpy"
    },
    {
      "source": "merge_lanes_pe",
      "target": "pip"
    },
    {
      "source": "consensus_peaks",
      "target": "fastqc"
    },
    {
      "source": "consensus_peaks",
      "target": "multiqc"
    },
    {
      "source": "consensus_peaks",
      "target": "pandas"
    },
    {
      "source": "consensus_peaks",
      "target": "deeptools"
    },
    {
      "source": "consensus_peaks",
      "target": "bedtools"
    },
    {
      "source": "consensus_peaks",
      "target": "numpy"
    },
    {
      "source": "count_reads_on_peaks",
      "target": "fastqc"
    },
    {
      "source": "count_reads_on_peaks",
      "target": "multiqc"
    },
    {
      "source": "count_reads_on_peaks",
      "target": "pandas"
    },
    {
      "source": "count_reads_on_peaks",
      "target": "deeptools"
    },
    {
      "source": "count_reads_on_peaks",
      "target": "bedtools"
    },
    {
      "source": "count_reads_on_peaks",
      "target": "numpy"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-DESeq2"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "r-base"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "gawk"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg38.knowngene"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg19.knowngene"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm10.knowngene"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "samtools"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-org.mm.eg.db"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-chipseeker"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-org.hs.eg.db"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "r-tidyverse"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm9.knowngene"
    },
    {
      "source": "peakAnnot_singleRep",
      "target": "r-spp"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-DESeq2"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "r-base"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "gawk"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg38.knowngene"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg19.knowngene"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm10.knowngene"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "samtools"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-org.mm.eg.db"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-chipseeker"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-org.hs.eg.db"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "r-tidyverse"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm9.knowngene"
    },
    {
      "source": "peakAnnot_singleRep_normPeaks",
      "target": "r-spp"
    },
    {
      "source": "return_genome_path",
      "target": "bioconda::samblaster"
    },
    {
      "source": "return_genome_path",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "return_genome_path",
      "target": "python"
    },
    {
      "source": "return_genome_path",
      "target": "bioconda::samtools"
    },
    {
      "source": "get_reference_genome",
      "target": "deeptoolsintervals"
    },
    {
      "source": "get_reference_genome",
      "target": "epic2"
    },
    {
      "source": "get_reference_genome",
      "target": "pandas"
    },
    {
      "source": "get_reference_genome",
      "target": "macs2"
    },
    {
      "source": "get_reference_genome",
      "target": "cython"
    },
    {
      "source": "get_reference_genome",
      "target": "pysam"
    },
    {
      "source": "get_reference_genome",
      "target": "py2bit"
    },
    {
      "source": "get_reference_genome",
      "target": "fastp"
    },
    {
      "source": "get_reference_genome",
      "target": "numpy"
    },
    {
      "source": "get_reference_genome",
      "target": "pip"
    },
    {
      "source": "create_bowtie_index",
      "target": "bioconda::samblaster"
    },
    {
      "source": "create_bowtie_index",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "create_bowtie_index",
      "target": "python"
    },
    {
      "source": "create_bowtie_index",
      "target": "bioconda::samtools"
    },
    {
      "source": "get_spike_genome",
      "target": "deeptoolsintervals"
    },
    {
      "source": "get_spike_genome",
      "target": "epic2"
    },
    {
      "source": "get_spike_genome",
      "target": "pandas"
    },
    {
      "source": "get_spike_genome",
      "target": "macs2"
    },
    {
      "source": "get_spike_genome",
      "target": "cython"
    },
    {
      "source": "get_spike_genome",
      "target": "pysam"
    },
    {
      "source": "get_spike_genome",
      "target": "py2bit"
    },
    {
      "source": "get_spike_genome",
      "target": "fastp"
    },
    {
      "source": "get_spike_genome",
      "target": "numpy"
    },
    {
      "source": "get_spike_genome",
      "target": "pip"
    },
    {
      "source": "calculate_norm_factors",
      "target": "fastqc"
    },
    {
      "source": "calculate_norm_factors",
      "target": "multiqc"
    },
    {
      "source": "calculate_norm_factors",
      "target": "pandas"
    },
    {
      "source": "calculate_norm_factors",
      "target": "deeptools"
    },
    {
      "source": "calculate_norm_factors",
      "target": "bedtools"
    },
    {
      "source": "calculate_norm_factors",
      "target": "numpy"
    },
    {
      "source": "bam2bigwig_general",
      "target": "fastqc"
    },
    {
      "source": "bam2bigwig_general",
      "target": "multiqc"
    },
    {
      "source": "bam2bigwig_general",
      "target": "pandas"
    },
    {
      "source": "bam2bigwig_general",
      "target": "deeptools"
    },
    {
      "source": "bam2bigwig_general",
      "target": "bedtools"
    },
    {
      "source": "bam2bigwig_general",
      "target": "numpy"
    },
    {
      "source": "plotFingerprint",
      "target": "fastqc"
    },
    {
      "source": "plotFingerprint",
      "target": "multiqc"
    },
    {
      "source": "plotFingerprint",
      "target": "pandas"
    },
    {
      "source": "plotFingerprint",
      "target": "deeptools"
    },
    {
      "source": "plotFingerprint",
      "target": "bedtools"
    },
    {
      "source": "plotFingerprint",
      "target": "numpy"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-DESeq2"
    },
    {
      "source": "phantom_peak_qual",
      "target": "r-base"
    },
    {
      "source": "phantom_peak_qual",
      "target": "gawk"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg38.knowngene"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg19.knowngene"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm10.knowngene"
    },
    {
      "source": "phantom_peak_qual",
      "target": "samtools"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-org.mm.eg.db"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-chipseeker"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-org.hs.eg.db"
    },
    {
      "source": "phantom_peak_qual",
      "target": "r-tidyverse"
    },
    {
      "source": "phantom_peak_qual",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm9.knowngene"
    },
    {
      "source": "phantom_peak_qual",
      "target": "r-spp"
    },
    {
      "source": "create_qc_table_splitBam",
      "target": "fastqc"
    },
    {
      "source": "create_qc_table_splitBam",
      "target": "multiqc"
    },
    {
      "source": "create_qc_table_splitBam",
      "target": "pandas"
    },
    {
      "source": "create_qc_table_splitBam",
      "target": "deeptools"
    },
    {
      "source": "create_qc_table_splitBam",
      "target": "bedtools"
    },
    {
      "source": "create_qc_table_splitBam",
      "target": "numpy"
    },
    {
      "source": "create_qc_table_epic2",
      "target": "fastqc"
    },
    {
      "source": "create_qc_table_epic2",
      "target": "multiqc"
    },
    {
      "source": "create_qc_table_epic2",
      "target": "pandas"
    },
    {
      "source": "create_qc_table_epic2",
      "target": "deeptools"
    },
    {
      "source": "create_qc_table_epic2",
      "target": "bedtools"
    },
    {
      "source": "create_qc_table_epic2",
      "target": "numpy"
    },
    {
      "source": "create_qc_table_edd",
      "target": "fastqc"
    },
    {
      "source": "create_qc_table_edd",
      "target": "multiqc"
    },
    {
      "source": "create_qc_table_edd",
      "target": "pandas"
    },
    {
      "source": "create_qc_table_edd",
      "target": "deeptools"
    },
    {
      "source": "create_qc_table_edd",
      "target": "bedtools"
    },
    {
      "source": "create_qc_table_edd",
      "target": "numpy"
    },
    {
      "source": "create_qc_table_macs2",
      "target": "fastqc"
    },
    {
      "source": "create_qc_table_macs2",
      "target": "multiqc"
    },
    {
      "source": "create_qc_table_macs2",
      "target": "pandas"
    },
    {
      "source": "create_qc_table_macs2",
      "target": "deeptools"
    },
    {
      "source": "create_qc_table_macs2",
      "target": "bedtools"
    },
    {
      "source": "create_qc_table_macs2",
      "target": "numpy"
    },
    {
      "source": "create_qc_table_peakAnnot",
      "target": "fastqc"
    },
    {
      "source": "create_qc_table_peakAnnot",
      "target": "multiqc"
    },
    {
      "source": "create_qc_table_peakAnnot",
      "target": "pandas"
    },
    {
      "source": "create_qc_table_peakAnnot",
      "target": "deeptools"
    },
    {
      "source": "create_qc_table_peakAnnot",
      "target": "bedtools"
    },
    {
      "source": "create_qc_table_peakAnnot",
      "target": "numpy"
    },
    {
      "source": "split_bam",
      "target": "bioconda::samblaster"
    },
    {
      "source": "split_bam",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "split_bam",
      "target": "python"
    },
    {
      "source": "split_bam",
      "target": "bioconda::samtools"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "deeptoolsintervals"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "epic2"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "pandas"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "macs2"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "cython"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "pysam"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "py2bit"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "fastp"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "numpy"
    },
    {
      "source": "macs2_callNarrowPeak",
      "target": "pip"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "deeptoolsintervals"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "epic2"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "pandas"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "macs2"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "cython"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "pysam"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "py2bit"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "fastp"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "numpy"
    },
    {
      "source": "macs2_callNormPeaks_narrow",
      "target": "pip"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "deeptoolsintervals"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "epic2"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "pandas"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "macs2"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "cython"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "pysam"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "py2bit"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "fastp"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "numpy"
    },
    {
      "source": "macs2_callNormPeaks_broad",
      "target": "pip"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "deeptoolsintervals"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "epic2"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "pandas"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "macs2"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "cython"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "pysam"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "py2bit"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "fastp"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "numpy"
    },
    {
      "source": "epic2_callBroadPeaks",
      "target": "pip"
    },
    {
      "source": "edd_callVeryBroadPeaks",
      "target": "python"
    },
    {
      "source": "edd_callVeryBroadPeaks",
      "target": "edd"
    },
    {
      "source": "edd_callVeryBroadPeaks",
      "target": "pip"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-DESeq2"
    },
    {
      "source": "differential_peaks",
      "target": "r-base"
    },
    {
      "source": "differential_peaks",
      "target": "gawk"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg38.knowngene"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-txdb.hsapiens.ucsc.hg19.knowngene"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm10.knowngene"
    },
    {
      "source": "differential_peaks",
      "target": "samtools"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-org.mm.eg.db"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-chipseeker"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-org.hs.eg.db"
    },
    {
      "source": "differential_peaks",
      "target": "r-tidyverse"
    },
    {
      "source": "differential_peaks",
      "target": "bioconductor-txdb.mmusculus.ucsc.mm9.knowngene"
    },
    {
      "source": "differential_peaks",
      "target": "r-spp"
    },
    {
      "source": "install_te_small",
      "target": "pandas"
    },
    {
      "source": "install_te_small",
      "target": "bokeh"
    },
    {
      "source": "install_te_small",
      "target": "scipy"
    },
    {
      "source": "install_te_small",
      "target": "seaborn"
    },
    {
      "source": "install_te_small",
      "target": "matplotlib"
    },
    {
      "source": "install_te_small",
      "target": "pysam"
    },
    {
      "source": "install_te_small",
      "target": "pybedtools"
    },
    {
      "source": "install_te_small",
      "target": "cutadapt"
    },
    {
      "source": "install_te_small",
      "target": "git"
    },
    {
      "source": "install_te_small",
      "target": "bioconda::bowtie"
    },
    {
      "source": "install_te_small",
      "target": "numpy"
    },
    {
      "source": "install_te_small",
      "target": "bioconda::samtools"
    },
    {
      "source": "run_te_small",
      "target": "pandas"
    },
    {
      "source": "run_te_small",
      "target": "bokeh"
    },
    {
      "source": "run_te_small",
      "target": "scipy"
    },
    {
      "source": "run_te_small",
      "target": "seaborn"
    },
    {
      "source": "run_te_small",
      "target": "matplotlib"
    },
    {
      "source": "run_te_small",
      "target": "pysam"
    },
    {
      "source": "run_te_small",
      "target": "pybedtools"
    },
    {
      "source": "run_te_small",
      "target": "cutadapt"
    },
    {
      "source": "run_te_small",
      "target": "git"
    },
    {
      "source": "run_te_small",
      "target": "bioconda::bowtie"
    },
    {
      "source": "run_te_small",
      "target": "numpy"
    },
    {
      "source": "run_te_small",
      "target": "bioconda::samtools"
    },
    {
      "source": "deseq2",
      "target": "r-cowplot"
    },
    {
      "source": "deseq2",
      "target": "r-base"
    },
    {
      "source": "deseq2",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "deseq2",
      "target": "r-ggseqlogo"
    },
    {
      "source": "deseq2",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "deseq2",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "deseq2",
      "target": "r-tidyverse"
    },
    {
      "source": "deseq2",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "plot_pca",
      "target": "r-cowplot"
    },
    {
      "source": "plot_pca",
      "target": "r-base"
    },
    {
      "source": "plot_pca",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "plot_pca",
      "target": "r-ggseqlogo"
    },
    {
      "source": "plot_pca",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "plot_pca",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "plot_pca",
      "target": "r-tidyverse"
    },
    {
      "source": "plot_pca",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "trim_adapters",
      "target": "bioconda::seqkit"
    },
    {
      "source": "trim_adapters",
      "target": "bio/cutadapt/se\""
    },
    {
      "source": "trim_adapters",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "trim_adapters",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "get_sequence",
      "target": "bioconda::seqkit"
    },
    {
      "source": "get_sequence",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "get_sequence",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "count_unique_sequences",
      "target": "bioconda::seqkit"
    },
    {
      "source": "count_unique_sequences",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "count_unique_sequences",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "create_count_fasta",
      "target": "bioconda::seqkit"
    },
    {
      "source": "create_count_fasta",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "create_count_fasta",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "bioconda::seqkit"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "bioconda::seqtk"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "bioconda::pysam"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "conda-forge::wget"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "bioconda::bowtie"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "conda-forge::python"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "download_ncrna_fasta",
      "target": "bioconda::samtools"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "bioconda::seqkit"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "bioconda::seqtk"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "bioconda::pysam"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "conda-forge::wget"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "bioconda::bowtie"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "conda-forge::python"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "filter_ncrna_fasta",
      "target": "bioconda::samtools"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "bioconda::seqkit"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "bioconda::seqtk"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "bioconda::pysam"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "conda-forge::wget"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "bioconda::bowtie"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "conda-forge::python"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "bowtie_index_ncrna",
      "target": "bioconda::samtools"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "bioconda::seqkit"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "bioconda::seqtk"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "bioconda::pysam"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "conda-forge::wget"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "bioconda::bowtie"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "conda-forge::python"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "filter_ncrna_reads",
      "target": "bioconda::samtools"
    },
    {
      "source": "bowtie_index",
      "target": "bioconda::seqkit"
    },
    {
      "source": "bowtie_index",
      "target": "bioconda::seqtk"
    },
    {
      "source": "bowtie_index",
      "target": "bioconda::pysam"
    },
    {
      "source": "bowtie_index",
      "target": "conda-forge::wget"
    },
    {
      "source": "bowtie_index",
      "target": "bioconda::bowtie"
    },
    {
      "source": "bowtie_index",
      "target": "conda-forge::python"
    },
    {
      "source": "bowtie_index",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "bowtie_index",
      "target": "bioconda::samtools"
    },
    {
      "source": "collapse_sequences",
      "target": "bioconda::seqkit"
    },
    {
      "source": "collapse_sequences",
      "target": "bioconda::seqtk"
    },
    {
      "source": "collapse_sequences",
      "target": "bioconda::pysam"
    },
    {
      "source": "collapse_sequences",
      "target": "conda-forge::wget"
    },
    {
      "source": "collapse_sequences",
      "target": "bioconda::bowtie"
    },
    {
      "source": "collapse_sequences",
      "target": "conda-forge::python"
    },
    {
      "source": "collapse_sequences",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "collapse_sequences",
      "target": "bioconda::samtools"
    },
    {
      "source": "align",
      "target": "bioconda::seqkit"
    },
    {
      "source": "align",
      "target": "bioconda::seqtk"
    },
    {
      "source": "align",
      "target": "bioconda::pysam"
    },
    {
      "source": "align",
      "target": "conda-forge::wget"
    },
    {
      "source": "align",
      "target": "bioconda::bowtie"
    },
    {
      "source": "align",
      "target": "conda-forge::python"
    },
    {
      "source": "align",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "align",
      "target": "bioconda::samtools"
    },
    {
      "source": "pingpong_analysis",
      "target": "bioconda::seqkit"
    },
    {
      "source": "pingpong_analysis",
      "target": "bioconda::seqtk"
    },
    {
      "source": "pingpong_analysis",
      "target": "bioconda::pysam"
    },
    {
      "source": "pingpong_analysis",
      "target": "conda-forge::wget"
    },
    {
      "source": "pingpong_analysis",
      "target": "bioconda::bowtie"
    },
    {
      "source": "pingpong_analysis",
      "target": "conda-forge::python"
    },
    {
      "source": "pingpong_analysis",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "pingpong_analysis",
      "target": "bioconda::samtools"
    },
    {
      "source": "plot_pingpong",
      "target": "r-cowplot"
    },
    {
      "source": "plot_pingpong",
      "target": "r-base"
    },
    {
      "source": "plot_pingpong",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "plot_pingpong",
      "target": "r-ggseqlogo"
    },
    {
      "source": "plot_pingpong",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "plot_pingpong",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "plot_pingpong",
      "target": "r-tidyverse"
    },
    {
      "source": "plot_pingpong",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "r-cowplot"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "r-base"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "r-ggseqlogo"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "r-tidyverse"
    },
    {
      "source": "plot_sequence_bias_pirna",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "te_pos_coverage",
      "target": "r-cowplot"
    },
    {
      "source": "te_pos_coverage",
      "target": "r-base"
    },
    {
      "source": "te_pos_coverage",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "te_pos_coverage",
      "target": "r-ggseqlogo"
    },
    {
      "source": "te_pos_coverage",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "te_pos_coverage",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "te_pos_coverage",
      "target": "r-tidyverse"
    },
    {
      "source": "te_pos_coverage",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "r-cowplot"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "r-base"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "r-ggseqlogo"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "r-tidyverse"
    },
    {
      "source": "length_distribution_aligned_to_TE",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "download_mirna_fasta",
      "target": "bioconda::seqkit"
    },
    {
      "source": "download_mirna_fasta",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "download_mirna_fasta",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "subset_mirna_fasta",
      "target": "bioconda::seqkit"
    },
    {
      "source": "subset_mirna_fasta",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "subset_mirna_fasta",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "mirna_index",
      "target": "bioconda::seqkit"
    },
    {
      "source": "mirna_index",
      "target": "bioconda::seqtk"
    },
    {
      "source": "mirna_index",
      "target": "bioconda::pysam"
    },
    {
      "source": "mirna_index",
      "target": "conda-forge::wget"
    },
    {
      "source": "mirna_index",
      "target": "bioconda::bowtie"
    },
    {
      "source": "mirna_index",
      "target": "conda-forge::python"
    },
    {
      "source": "mirna_index",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "mirna_index",
      "target": "bioconda::samtools"
    },
    {
      "source": "align_to_mirna",
      "target": "bioconda::seqkit"
    },
    {
      "source": "align_to_mirna",
      "target": "bioconda::seqtk"
    },
    {
      "source": "align_to_mirna",
      "target": "bioconda::pysam"
    },
    {
      "source": "align_to_mirna",
      "target": "conda-forge::wget"
    },
    {
      "source": "align_to_mirna",
      "target": "bioconda::bowtie"
    },
    {
      "source": "align_to_mirna",
      "target": "conda-forge::python"
    },
    {
      "source": "align_to_mirna",
      "target": "bioconda::fastx_toolkit"
    },
    {
      "source": "align_to_mirna",
      "target": "bioconda::samtools"
    },
    {
      "source": "length_counts",
      "target": "bioconda::seqkit"
    },
    {
      "source": "length_counts",
      "target": "bioconda::cutadapt"
    },
    {
      "source": "length_counts",
      "target": "bioconda::bowtie2"
    },
    {
      "source": "plot_length_distribution",
      "target": "r-cowplot"
    },
    {
      "source": "plot_length_distribution",
      "target": "r-base"
    },
    {
      "source": "plot_length_distribution",
      "target": "bioconda::bioconductor-deseq2"
    },
    {
      "source": "plot_length_distribution",
      "target": "r-ggseqlogo"
    },
    {
      "source": "plot_length_distribution",
      "target": "bioconda::bioconductor-biostrings"
    },
    {
      "source": "plot_length_distribution",
      "target": "bioconda::bioconductor-rsamtools"
    },
    {
      "source": "plot_length_distribution",
      "target": "r-tidyverse"
    },
    {
      "source": "plot_length_distribution",
      "target": "conda-forge::r-gridextra"
    },
    {
      "source": "dedup",
      "target": "bwa"
    },
    {
      "source": "dedup",
      "target": "samtools"
    },
    {
      "source": "dedup",
      "target": "genmap"
    },
    {
      "source": "dedup",
      "target": "fastp"
    },
    {
      "source": "dedup",
      "target": "slamdunk"
    },
    {
      "source": "dedup",
      "target": "sambamba"
    },
    {
      "source": "dedup",
      "target": "mosdepth"
    },
    {
      "source": "filter_bam",
      "target": "bwa"
    },
    {
      "source": "filter_bam",
      "target": "samtools"
    },
    {
      "source": "filter_bam",
      "target": "genmap"
    },
    {
      "source": "filter_bam",
      "target": "fastp"
    },
    {
      "source": "filter_bam",
      "target": "sambamba"
    },
    {
      "source": "filter_bam",
      "target": "mosdepth"
    },
    {
      "source": "pileup",
      "target": "bwa"
    },
    {
      "source": "pileup",
      "target": "samtools"
    },
    {
      "source": "pileup",
      "target": "genmap"
    },
    {
      "source": "pileup",
      "target": "fastp"
    },
    {
      "source": "pileup",
      "target": "sambamba"
    },
    {
      "source": "pileup",
      "target": "mosdepth"
    },
    {
      "source": "mosdepth",
      "target": "bwa"
    },
    {
      "source": "mosdepth",
      "target": "samtools"
    },
    {
      "source": "mosdepth",
      "target": "genmap"
    },
    {
      "source": "mosdepth",
      "target": "fastp"
    },
    {
      "source": "mosdepth",
      "target": "bio/mosdepth\""
    },
    {
      "source": "mosdepth",
      "target": "sambamba"
    },
    {
      "source": "mosdepth",
      "target": "mosdepth"
    },
    {
      "source": "flagstat",
      "target": "bwa"
    },
    {
      "source": "flagstat",
      "target": "samtools"
    },
    {
      "source": "flagstat",
      "target": "genmap"
    },
    {
      "source": "flagstat",
      "target": "fastp"
    },
    {
      "source": "flagstat",
      "target": "sambamba"
    },
    {
      "source": "flagstat",
      "target": "mosdepth"
    },
    {
      "source": "view_mappability",
      "target": "bwa"
    },
    {
      "source": "view_mappability",
      "target": "samtools"
    },
    {
      "source": "view_mappability",
      "target": "genmap"
    },
    {
      "source": "view_mappability",
      "target": "fastp"
    },
    {
      "source": "view_mappability",
      "target": "sambamba"
    },
    {
      "source": "view_mappability",
      "target": "mosdepth"
    },
    {
      "source": "view_mappability2",
      "target": "bwa"
    },
    {
      "source": "view_mappability2",
      "target": "samtools"
    },
    {
      "source": "view_mappability2",
      "target": "genmap"
    },
    {
      "source": "view_mappability2",
      "target": "fastp"
    },
    {
      "source": "view_mappability2",
      "target": "sambamba"
    },
    {
      "source": "view_mappability2",
      "target": "mosdepth"
    },
    {
      "source": "get_rid_of_unpaired",
      "target": "bwa"
    },
    {
      "source": "get_rid_of_unpaired",
      "target": "samtools"
    },
    {
      "source": "get_rid_of_unpaired",
      "target": "genmap"
    },
    {
      "source": "get_rid_of_unpaired",
      "target": "fastp"
    },
    {
      "source": "get_rid_of_unpaired",
      "target": "sambamba"
    },
    {
      "source": "get_rid_of_unpaired",
      "target": "mosdepth"
    },
    {
      "source": "mosdepth_octomom",
      "target": "bwa"
    },
    {
      "source": "mosdepth_octomom",
      "target": "samtools"
    },
    {
      "source": "mosdepth_octomom",
      "target": "genmap"
    },
    {
      "source": "mosdepth_octomom",
      "target": "fastp"
    },
    {
      "source": "mosdepth_octomom",
      "target": "sambamba"
    },
    {
      "source": "mosdepth_octomom",
      "target": "mosdepth"
    },
    {
      "source": "index_reference",
      "target": "bwa"
    },
    {
      "source": "index_reference",
      "target": "samtools"
    },
    {
      "source": "index_reference",
      "target": "genmap"
    },
    {
      "source": "index_reference",
      "target": "fastp"
    },
    {
      "source": "index_reference",
      "target": "sambamba"
    },
    {
      "source": "index_reference",
      "target": "mosdepth"
    },
    {
      "source": "mappability_index",
      "target": "bwa"
    },
    {
      "source": "mappability_index",
      "target": "samtools"
    },
    {
      "source": "mappability_index",
      "target": "genmap"
    },
    {
      "source": "mappability_index",
      "target": "fastp"
    },
    {
      "source": "mappability_index",
      "target": "sambamba"
    },
    {
      "source": "mappability_index",
      "target": "mosdepth"
    },
    {
      "source": "mappability",
      "target": "bwa"
    },
    {
      "source": "mappability",
      "target": "samtools"
    },
    {
      "source": "mappability",
      "target": "genmap"
    },
    {
      "source": "mappability",
      "target": "fastp"
    },
    {
      "source": "mappability",
      "target": "sambamba"
    },
    {
      "source": "mappability",
      "target": "mosdepth"
    },
    {
      "source": "extract_internal_kmers",
      "target": "loguru"
    },
    {
      "source": "extract_internal_kmers",
      "target": "python"
    },
    {
      "source": "extract_internal_kmers",
      "target": "pip"
    },
    {
      "source": "select_buckets",
      "target": "loguru"
    },
    {
      "source": "select_buckets",
      "target": "python"
    },
    {
      "source": "select_buckets",
      "target": "pip"
    },
    {
      "source": "run_bwafastmap",
      "target": "bwa"
    },
    {
      "source": "run_bwafastmap",
      "target": "loguru"
    },
    {
      "source": "run_bwafastmap_isdb",
      "target": "bwa"
    },
    {
      "source": "run_bwafastmap_isdb",
      "target": "loguru"
    },
    {
      "source": "analyze_bwafastmap",
      "target": "loguru"
    },
    {
      "source": "analyze_bwafastmap",
      "target": "python"
    },
    {
      "source": "analyze_bwafastmap",
      "target": "pip"
    },
    {
      "source": "find_percentage_dist",
      "target": "loguru"
    },
    {
      "source": "find_percentage_dist",
      "target": "pandas"
    },
    {
      "source": "find_passinggenes",
      "target": "loguru"
    },
    {
      "source": "find_passinggenes",
      "target": "pandas"
    },
    {
      "source": "find_passinggenes_isdb",
      "target": "loguru"
    },
    {
      "source": "find_passinggenes_isdb",
      "target": "pandas"
    },
    {
      "source": "genome_decompression",
      "target": "loguru"
    },
    {
      "source": "genome_decompression",
      "target": "pandas"
    },
    {
      "source": "tiny_genome_decompression",
      "target": "loguru"
    },
    {
      "source": "tiny_genome_decompression",
      "target": "pandas"
    },
    {
      "source": "tinydownsample_df",
      "target": "loguru"
    },
    {
      "source": "tinydownsample_df",
      "target": "pandas"
    },
    {
      "source": "downsample_df",
      "target": "loguru"
    },
    {
      "source": "downsample_df",
      "target": "pandas"
    },
    {
      "source": "downsample_clusterzerodf",
      "target": "bwa"
    },
    {
      "source": "downsample_clusterzerodf",
      "target": "loguru"
    },
    {
      "source": "make_internal_fasta",
      "target": "loguru"
    },
    {
      "source": "make_internal_fasta",
      "target": "python"
    },
    {
      "source": "make_internal_fasta",
      "target": "pip"
    },
    {
      "source": "filter_passinggenes_mge",
      "target": "loguru"
    },
    {
      "source": "filter_passinggenes_mge",
      "target": "pandas"
    },
    {
      "source": "region_decompression",
      "target": "loguru"
    },
    {
      "source": "region_decompression",
      "target": "python"
    },
    {
      "source": "region_decompression",
      "target": "pip"
    },
    {
      "source": "itol_annottext",
      "target": "loguru"
    },
    {
      "source": "itol_annottext",
      "target": "pandas"
    },
    {
      "source": "make_bwaidx",
      "target": "bwa"
    },
    {
      "source": "make_bwaidx",
      "target": "loguru"
    },
    {
      "source": "fastmap",
      "target": "bwa"
    },
    {
      "source": "fastmap",
      "target": "loguru"
    },
    {
      "source": "prefixsuffix_kmergen",
      "target": "loguru"
    },
    {
      "source": "prefixsuffix_kmergen",
      "target": "python"
    },
    {
      "source": "prefixsuffix_kmergen",
      "target": "pip"
    },
    {
      "source": "fastmap_process",
      "target": "loguru"
    },
    {
      "source": "fastmap_process",
      "target": "python"
    },
    {
      "source": "fastmap_process",
      "target": "pip"
    },
    {
      "source": "fastmap_distances",
      "target": "loguru"
    },
    {
      "source": "fastmap_distances",
      "target": "pandas"
    },
    {
      "source": "parse_distances",
      "target": "loguru"
    },
    {
      "source": "parse_distances",
      "target": "pandas"
    },
    {
      "source": "cluster_dists",
      "target": "psutil"
    },
    {
      "source": "cluster_dists",
      "target": "loguru"
    },
    {
      "source": "cluster_dists",
      "target": "python-duckdb"
    },
    {
      "source": "cluster_dists",
      "target": "pandas"
    },
    {
      "source": "cluster_dists",
      "target": "seaborn"
    },
    {
      "source": "passinggene_cluster_decompression",
      "target": "loguru"
    },
    {
      "source": "passinggene_cluster_decompression",
      "target": "pandas"
    },
    {
      "source": "samtools_flagstat",
      "target": "bio/samtools/flagstat\""
    },
    {
      "source": "samtools_idxstats",
      "target": "bio/samtools/idxstats\""
    },
    {
      "source": "get_annotation",
      "target": "bio/reference/ensembl-annotation\""
    },
    {
      "source": "sra_get_fastq_pe",
      "target": "bio/sra-tools/fasterq-dump\""
    },
    {
      "source": "sra_get_fastq_se",
      "target": "bio/sra-tools/fasterq-dump\""
    },
    {
      "source": "gtf2bed",
      "target": "perl-getopt-long"
    },
    {
      "source": "bedtools_sort_blacklist",
      "target": "bio/bedtools/sort\""
    },
    {
      "source": "bedtools_complement_blacklist",
      "target": "bio/bedtools/complement\""
    },
    {
      "source": "cutadapt_pe",
      "target": "bio/cutadapt/pe\""
    },
    {
      "source": "cutadapt_se",
      "target": "bio/cutadapt/se\""
    },
    {
      "source": "cutadapt_se",
      "target": "xopen"
    },
    {
      "source": "cutadapt_se",
      "target": "cutadapt"
    },
    {
      "source": "merge_bams",
      "target": "bio/picard/mergesamfiles\""
    },
    {
      "source": "mark_merged_duplicates",
      "target": "bio/picard/markduplicates\""
    },
    {
      "source": "plot_fingerprint",
      "target": "bio/deeptools/plotfingerprint\""
    },
    {
      "source": "macs2_callpeak_broad",
      "target": "bio/macs2/callpeak\""
    },
    {
      "source": "macs2_callpeak_narrow",
      "target": "bio/macs2/callpeak\""
    },
    {
      "source": "peaks_count",
      "target": "gawk"
    },
    {
      "source": "sm_report_peaks_count_plot",
      "target": "r-tidyverse"
    },
    {
      "source": "sm_report_peaks_count_plot",
      "target": "r-base"
    },
    {
      "source": "bedtools_intersect",
      "target": "bio/bedtools/intersect\""
    },
    {
      "source": "frip_score",
      "target": "gawk"
    },
    {
      "source": "sm_rep_frip_score",
      "target": "r-tidyverse"
    },
    {
      "source": "sm_rep_frip_score",
      "target": "r-base"
    },
    {
      "source": "homer_annotatepeaks",
      "target": "bio/homer/annotatePeaks\""
    },
    {
      "source": "plot_macs_qc",
      "target": "r-base"
    },
    {
      "source": "plot_macs_qc",
      "target": "r-ggplot2"
    },
    {
      "source": "plot_macs_qc",
      "target": "r-reshape2"
    },
    {
      "source": "plot_macs_qc",
      "target": "r-optparse"
    },
    {
      "source": "plot_homer_annotatepeaks",
      "target": "r-base"
    },
    {
      "source": "plot_homer_annotatepeaks",
      "target": "r-ggplot2"
    },
    {
      "source": "plot_homer_annotatepeaks",
      "target": "r-reshape2"
    },
    {
      "source": "plot_homer_annotatepeaks",
      "target": "r-optparse"
    },
    {
      "source": "plot_sum_annotatepeaks",
      "target": "r-tidyverse"
    },
    {
      "source": "plot_sum_annotatepeaks",
      "target": "r-base"
    },
    {
      "source": "bedtools_merge_broad",
      "target": "bio/bedtools/merge\""
    },
    {
      "source": "bedtools_merge_narrow",
      "target": "bio/bedtools/merge\""
    },
    {
      "source": "create_consensus_bed",
      "target": "gawk"
    },
    {
      "source": "create_consensus_saf",
      "target": "gawk"
    },
    {
      "source": "plot_peak_intersect",
      "target": "r-optparse"
    },
    {
      "source": "plot_peak_intersect",
      "target": "r-base"
    },
    {
      "source": "plot_peak_intersect",
      "target": "r-upsetr"
    },
    {
      "source": "homer_consensus_annotatepeaks",
      "target": "bio/homer/annotatePeaks\""
    },
    {
      "source": "trim_homer_consensus_annotatepeaks",
      "target": "gawk"
    },
    {
      "source": "merge_bool_and_annotatepeaks",
      "target": "gawk"
    },
    {
      "source": "feature_counts",
      "target": "bio/subread/featurecounts\""
    },
    {
      "source": "featurecounts_deseq2",
      "target": "r-base"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "r-ggplot2"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "bioconductor-biocparallel"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "r-pheatmap"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "bioconductor-deseq2"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "r-lattice"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "bioconductor-vsn"
    },
    {
      "source": "featurecounts_deseq2",
      "target": "r-rcolorbrewer"
    },
    {
      "source": "preseq_lc_extrap",
      "target": "bio/preseq/lc_extrap\""
    },
    {
      "source": "collect_multiple_metrics",
      "target": "bio/picard/collectmultiplemetrics\""
    },
    {
      "source": "genomecov",
      "target": "bio/bedtools/genomecov\""
    },
    {
      "source": "bedGraphToBigWig",
      "target": "bio/ucsc/bedGraphToBigWig\""
    },
    {
      "source": "compute_matrix",
      "target": "bio/deeptools/computematrix\""
    },
    {
      "source": "plot_profile",
      "target": "bio/deeptools/plotprofile\""
    },
    {
      "source": "plot_heatmap",
      "target": "bio/deeptools/plotheatmap\""
    },
    {
      "source": "phantompeakqualtools",
      "target": "r-snow"
    },
    {
      "source": "phantompeakqualtools",
      "target": "samtools"
    },
    {
      "source": "phantompeakqualtools",
      "target": "r-catools"
    },
    {
      "source": "phantompeakqualtools",
      "target": "r-bitops"
    },
    {
      "source": "phantompeakqualtools",
      "target": "phantompeakqualtools"
    },
    {
      "source": "phantompeakqualtools",
      "target": "r-snowfall"
    },
    {
      "source": "phantompeakqualtools",
      "target": "bioconductor-rsamtools"
    },
    {
      "source": "phantompeak_correlation",
      "target": "r-base"
    },
    {
      "source": "phantompeak_multiqc",
      "target": "gawk"
    },
    {
      "source": "samtools_view_filter",
      "target": "bio/samtools/view\""
    },
    {
      "source": "bamtools_filter_json",
      "target": "bio/bamtools/filter_json\""
    },
    {
      "source": "orphan_remove",
      "target": "python"
    },
    {
      "source": "orphan_remove",
      "target": "pysam"
    },
    {
      "source": "samtools_sort_pe",
      "target": "bio/samtools/sort\""
    },
    {
      "source": "convert_idat",
      "target": "r-base"
    },
    {
      "source": "convert_idat",
      "target": "pkg-config"
    },
    {
      "source": "convert_idat",
      "target": "r-remotes"
    },
    {
      "source": "convert_idat",
      "target": "make"
    },
    {
      "source": "convert_idat",
      "target": "bioconductor-sesame"
    },
    {
      "source": "convert_idat",
      "target": "compilers"
    },
    {
      "source": "convert_idat",
      "target": "r-biocmanager"
    },
    {
      "source": "convert_idat",
      "target": "bioconductor-sesamedata"
    },
    {
      "source": "generate_tsne",
      "target": "pandas"
    },
    {
      "source": "generate_tsne",
      "target": "scikit-learn"
    },
    {
      "source": "generate_tsne",
      "target": "scipy"
    },
    {
      "source": "generate_tsne",
      "target": "python"
    },
    {
      "source": "generate_tsne",
      "target": "seaborn"
    },
    {
      "source": "generate_tsne",
      "target": "matplotlib"
    },
    {
      "source": "generate_tsne",
      "target": "numpy"
    },
    {
      "source": "generate_tsne",
      "target": "pip"
    },
    {
      "source": "generate_umap",
      "target": "pandas"
    },
    {
      "source": "generate_umap",
      "target": "umap-learn"
    },
    {
      "source": "generate_umap",
      "target": "scikit-learn"
    },
    {
      "source": "generate_umap",
      "target": "scipy"
    },
    {
      "source": "generate_umap",
      "target": "python"
    },
    {
      "source": "generate_umap",
      "target": "seaborn"
    },
    {
      "source": "generate_umap",
      "target": "matplotlib"
    },
    {
      "source": "generate_umap",
      "target": "numpy"
    },
    {
      "source": "generate_umap",
      "target": "pip"
    },
    {
      "source": "rf_phyML",
      "target": "python"
    },
    {
      "source": "qc_windows",
      "target": "python"
    },
    {
      "source": "runRaxML",
      "target": "raxml-ng"
    },
    {
      "source": "runRaxML",
      "target": "python"
    },
    {
      "source": "bootstrapFilter2",
      "target": "python"
    },
    {
      "source": "rf_distance2",
      "target": "python"
    },
    {
      "source": "runFasttree",
      "target": "fasttree"
    },
    {
      "source": "runFasttree",
      "target": "python"
    },
    {
      "source": "bootstrapFilter_fasttree",
      "target": "python"
    },
    {
      "source": "rf_distance_fasttree",
      "target": "python"
    },
    {
      "source": "rf_distance",
      "target": "python"
    },
    {
      "source": "bootstrap_consensus",
      "target": "python"
    },
    {
      "source": "sliding_windows",
      "target": "python"
    },
    {
      "source": "create_Matrix",
      "target": "python"
    },
    {
      "source": "prepare_barcode_reference",
      "target": "python"
    },
    {
      "source": "prepare_barcode_reference",
      "target": "pandas"
    },
    {
      "source": "prepare_barcode_reference",
      "target": "biopython"
    },
    {
      "source": "chunk_pypileup",
      "target": "python"
    },
    {
      "source": "chunk_pypileup",
      "target": "pandas"
    },
    {
      "source": "chunk_pypileup",
      "target": "pysam"
    },
    {
      "source": "chunk_pypileup",
      "target": "biopython"
    },
    {
      "source": "write_ab1",
      "target": "python"
    },
    {
      "source": "write_ab1",
      "target": "pandas"
    },
    {
      "source": "write_ab1",
      "target": "pysam"
    },
    {
      "source": "write_ab1",
      "target": "biopython"
    },
    {
      "source": "ab1_done",
      "target": "python"
    },
    {
      "source": "ab1_done",
      "target": "pandas"
    },
    {
      "source": "ab1_done",
      "target": "pysam"
    },
    {
      "source": "ab1_done",
      "target": "biopython"
    },
    {
      "source": "fastq_to_fastq_subreads",
      "target": "pandas"
    },
    {
      "source": "fastq_to_fastq_subreads",
      "target": "biopython"
    },
    {
      "source": "fastq_to_fastq_subreads",
      "target": "medaka"
    },
    {
      "source": "fastq_to_fastq_subreads",
      "target": "python"
    },
    {
      "source": "fastq_to_fastq_subreads",
      "target": "pysam"
    },
    {
      "source": "medaka_consensus_from_subreads",
      "target": "pandas"
    },
    {
      "source": "medaka_consensus_from_subreads",
      "target": "biopython"
    },
    {
      "source": "medaka_consensus_from_subreads",
      "target": "medaka"
    },
    {
      "source": "medaka_consensus_from_subreads",
      "target": "python"
    },
    {
      "source": "medaka_consensus_from_subreads",
      "target": "pysam"
    },
    {
      "source": "split_fastq",
      "target": "pandas"
    },
    {
      "source": "split_fastq",
      "target": "biopython"
    },
    {
      "source": "split_fastq",
      "target": "medaka"
    },
    {
      "source": "split_fastq",
      "target": "python"
    },
    {
      "source": "split_fastq",
      "target": "pysam"
    },
    {
      "source": "consensus_summary_csv",
      "target": "pandas"
    },
    {
      "source": "consensus_summary_csv",
      "target": "biopython"
    },
    {
      "source": "consensus_summary_csv",
      "target": "medaka"
    },
    {
      "source": "consensus_summary_csv",
      "target": "python"
    },
    {
      "source": "consensus_summary_csv",
      "target": "pysam"
    },
    {
      "source": "aln_to_consensus",
      "target": "samtools"
    },
    {
      "source": "aln_to_consensus",
      "target": "pandas"
    },
    {
      "source": "aln_to_consensus",
      "target": "python"
    },
    {
      "source": "aln_to_consensus",
      "target": "minimap2"
    },
    {
      "source": "aln_to_consensus",
      "target": "matplotlib"
    },
    {
      "source": "parse_mpileup_ref_match",
      "target": "samtools"
    },
    {
      "source": "parse_mpileup_ref_match",
      "target": "pandas"
    },
    {
      "source": "parse_mpileup_ref_match",
      "target": "python"
    },
    {
      "source": "parse_mpileup_ref_match",
      "target": "minimap2"
    },
    {
      "source": "parse_mpileup_ref_match",
      "target": "matplotlib"
    },
    {
      "source": "plot_coverage",
      "target": "samtools"
    },
    {
      "source": "plot_coverage",
      "target": "pandas"
    },
    {
      "source": "plot_coverage",
      "target": "python"
    },
    {
      "source": "plot_coverage",
      "target": "minimap2"
    },
    {
      "source": "plot_coverage",
      "target": "matplotlib"
    },
    {
      "source": "coverage_done",
      "target": "samtools"
    },
    {
      "source": "coverage_done",
      "target": "pandas"
    },
    {
      "source": "coverage_done",
      "target": "python"
    },
    {
      "source": "coverage_done",
      "target": "minimap2"
    },
    {
      "source": "coverage_done",
      "target": "matplotlib"
    },
    {
      "source": "plot_done",
      "target": "samtools"
    },
    {
      "source": "plot_done",
      "target": "pandas"
    },
    {
      "source": "plot_done",
      "target": "python"
    },
    {
      "source": "plot_done",
      "target": "minimap2"
    },
    {
      "source": "plot_done",
      "target": "matplotlib"
    },
    {
      "source": "filter_reads_by_length",
      "target": "seqkit"
    },
    {
      "source": "filter_reads_by_length",
      "target": "python"
    },
    {
      "source": "filter_reads_by_length",
      "target": "cutadapt"
    },
    {
      "source": "filter_reads_by_length",
      "target": "pandas"
    },
    {
      "source": "count_filtered_reads",
      "target": "seqkit"
    },
    {
      "source": "count_filtered_reads",
      "target": "python"
    },
    {
      "source": "count_filtered_reads",
      "target": "cutadapt"
    },
    {
      "source": "count_filtered_reads",
      "target": "pandas"
    },
    {
      "source": "cutadapt_demux_linked",
      "target": "seqkit"
    },
    {
      "source": "cutadapt_demux_linked",
      "target": "python"
    },
    {
      "source": "cutadapt_demux_linked",
      "target": "cutadapt"
    },
    {
      "source": "cutadapt_demux_linked",
      "target": "pandas"
    },
    {
      "source": "demux_stats",
      "target": "seqkit"
    },
    {
      "source": "demux_stats",
      "target": "python"
    },
    {
      "source": "demux_stats",
      "target": "cutadapt"
    },
    {
      "source": "demux_stats",
      "target": "pandas"
    },
    {
      "source": "move_low_depth_subreads",
      "target": "seqkit"
    },
    {
      "source": "move_low_depth_subreads",
      "target": "python"
    },
    {
      "source": "move_low_depth_subreads",
      "target": "cutadapt"
    },
    {
      "source": "move_low_depth_subreads",
      "target": "pandas"
    },
    {
      "source": "move_file",
      "target": "seqkit"
    },
    {
      "source": "move_file",
      "target": "python"
    },
    {
      "source": "move_file",
      "target": "cutadapt"
    },
    {
      "source": "move_file",
      "target": "pandas"
    },
    {
      "source": "finalize_demux",
      "target": "seqkit"
    },
    {
      "source": "finalize_demux",
      "target": "python"
    },
    {
      "source": "finalize_demux",
      "target": "cutadapt"
    },
    {
      "source": "finalize_demux",
      "target": "pandas"
    },
    {
      "source": "make_pppp_output_dir",
      "target": "python"
    },
    {
      "source": "make_pppp_output_dir",
      "target": "pandas"
    },
    {
      "source": "alignment_clean",
      "target": "python"
    },
    {
      "source": "alignment_clean",
      "target": "pandas"
    },
    {
      "source": "demux_clean",
      "target": "python"
    },
    {
      "source": "demux_clean",
      "target": "pandas"
    },
    {
      "source": "consensus_clean",
      "target": "python"
    },
    {
      "source": "consensus_clean",
      "target": "pandas"
    },
    {
      "source": "logs_clean",
      "target": "python"
    },
    {
      "source": "logs_clean",
      "target": "pandas"
    },
    {
      "source": "report_clean",
      "target": "python"
    },
    {
      "source": "report_clean",
      "target": "pandas"
    },
    {
      "source": "ab1_clean",
      "target": "python"
    },
    {
      "source": "ab1_clean",
      "target": "pandas"
    },
    {
      "source": "clean",
      "target": "python"
    },
    {
      "source": "clean",
      "target": "pandas"
    },
    {
      "source": "bwameth_index",
      "target": "bio/bwameth/index\""
    },
    {
      "source": "align_reads_pe",
      "target": "python"
    },
    {
      "source": "align_reads_pe",
      "target": "bwameth"
    },
    {
      "source": "align_reads_pe",
      "target": "ncurses"
    },
    {
      "source": "align_reads_pe",
      "target": "bwa-mem2"
    },
    {
      "source": "align_reads_se",
      "target": "python"
    },
    {
      "source": "align_reads_se",
      "target": "bwameth"
    },
    {
      "source": "align_reads_se",
      "target": "ncurses"
    },
    {
      "source": "align_reads_se",
      "target": "bwa-mem2"
    },
    {
      "source": "aligned_reads_sort",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_sort",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_index",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_index",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_focus_on_chromosome",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_focus_on_chromosome",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_filter_on_mapq",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_filter_on_mapq",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_markduplicates",
      "target": "bio/picard/markduplicates\""
    },
    {
      "source": "aligned_reads_merge_sras",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_merge_sras",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_downsample",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_downsample",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_downsampled_index",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_downsampled_index",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "pytables"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "vl-convert-python"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "pandas"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "scipy"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "matplotlib"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "altair"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "pysam"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "altair_saver"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "vega_datasets"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "cyvcf2"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "vegafusion"
    },
    {
      "source": "aligned_reads_rename_chromosomes",
      "target": "pyarrow"
    },
    {
      "source": "aligned_reads_renamed_index",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_renamed_index",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_candidates_region",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_candidates_region",
      "target": "bcftools"
    },
    {
      "source": "aligned_reads_candidates_region_index",
      "target": "samtools"
    },
    {
      "source": "aligned_reads_candidates_region_index",
      "target": "bcftools"
    },
    {
      "source": "compute_pandas_df",
      "target": "pytables"
    },
    {
      "source": "compute_pandas_df",
      "target": "vl-convert-python"
    },
    {
      "source": "compute_pandas_df",
      "target": "pandas"
    },
    {
      "source": "compute_pandas_df",
      "target": "scipy"
    },
    {
      "source": "compute_pandas_df",
      "target": "matplotlib"
    },
    {
      "source": "compute_pandas_df",
      "target": "altair"
    },
    {
      "source": "compute_pandas_df",
      "target": "pysam"
    },
    {
      "source": "compute_pandas_df",
      "target": "altair_saver"
    },
    {
      "source": "compute_pandas_df",
      "target": "vega_datasets"
    },
    {
      "source": "compute_pandas_df",
      "target": "cyvcf2"
    },
    {
      "source": "compute_pandas_df",
      "target": "vegafusion"
    },
    {
      "source": "compute_pandas_df",
      "target": "pyarrow"
    },
    {
      "source": "compute_varlo_df",
      "target": "pytables"
    },
    {
      "source": "compute_varlo_df",
      "target": "vl-convert-python"
    },
    {
      "source": "compute_varlo_df",
      "target": "pandas"
    },
    {
      "source": "compute_varlo_df",
      "target": "scipy"
    },
    {
      "source": "compute_varlo_df",
      "target": "matplotlib"
    },
    {
      "source": "compute_varlo_df",
      "target": "altair"
    },
    {
      "source": "compute_varlo_df",
      "target": "pysam"
    },
    {
      "source": "compute_varlo_df",
      "target": "altair_saver"
    },
    {
      "source": "compute_varlo_df",
      "target": "vega_datasets"
    },
    {
      "source": "compute_varlo_df",
      "target": "cyvcf2"
    },
    {
      "source": "compute_varlo_df",
      "target": "vegafusion"
    },
    {
      "source": "compute_varlo_df",
      "target": "pyarrow"
    },
    {
      "source": "common_tool_df",
      "target": "pytables"
    },
    {
      "source": "common_tool_df",
      "target": "vl-convert-python"
    },
    {
      "source": "common_tool_df",
      "target": "pandas"
    },
    {
      "source": "common_tool_df",
      "target": "scipy"
    },
    {
      "source": "common_tool_df",
      "target": "matplotlib"
    },
    {
      "source": "common_tool_df",
      "target": "altair"
    },
    {
      "source": "common_tool_df",
      "target": "pysam"
    },
    {
      "source": "common_tool_df",
      "target": "altair_saver"
    },
    {
      "source": "common_tool_df",
      "target": "vega_datasets"
    },
    {
      "source": "common_tool_df",
      "target": "cyvcf2"
    },
    {
      "source": "common_tool_df",
      "target": "vegafusion"
    },
    {
      "source": "common_tool_df",
      "target": "pyarrow"
    },
    {
      "source": "merge_replicates",
      "target": "pytables"
    },
    {
      "source": "merge_replicates",
      "target": "vl-convert-python"
    },
    {
      "source": "merge_replicates",
      "target": "pandas"
    },
    {
      "source": "merge_replicates",
      "target": "scipy"
    },
    {
      "source": "merge_replicates",
      "target": "matplotlib"
    },
    {
      "source": "merge_replicates",
      "target": "altair"
    },
    {
      "source": "merge_replicates",
      "target": "pysam"
    },
    {
      "source": "merge_replicates",
      "target": "altair_saver"
    },
    {
      "source": "merge_replicates",
      "target": "vega_datasets"
    },
    {
      "source": "merge_replicates",
      "target": "cyvcf2"
    },
    {
      "source": "merge_replicates",
      "target": "vegafusion"
    },
    {
      "source": "merge_replicates",
      "target": "pyarrow"
    },
    {
      "source": "prepare_plot_df",
      "target": "pytables"
    },
    {
      "source": "prepare_plot_df",
      "target": "vl-convert-python"
    },
    {
      "source": "prepare_plot_df",
      "target": "pandas"
    },
    {
      "source": "prepare_plot_df",
      "target": "scipy"
    },
    {
      "source": "prepare_plot_df",
      "target": "matplotlib"
    },
    {
      "source": "prepare_plot_df",
      "target": "altair"
    },
    {
      "source": "prepare_plot_df",
      "target": "pysam"
    },
    {
      "source": "prepare_plot_df",
      "target": "altair_saver"
    },
    {
      "source": "prepare_plot_df",
      "target": "vega_datasets"
    },
    {
      "source": "prepare_plot_df",
      "target": "cyvcf2"
    },
    {
      "source": "prepare_plot_df",
      "target": "vegafusion"
    },
    {
      "source": "prepare_plot_df",
      "target": "pyarrow"
    },
    {
      "source": "plot_heatmaps",
      "target": "pytables"
    },
    {
      "source": "plot_heatmaps",
      "target": "vl-convert-python"
    },
    {
      "source": "plot_heatmaps",
      "target": "pandas"
    },
    {
      "source": "plot_heatmaps",
      "target": "scipy"
    },
    {
      "source": "plot_heatmaps",
      "target": "matplotlib"
    },
    {
      "source": "plot_heatmaps",
      "target": "altair"
    },
    {
      "source": "plot_heatmaps",
      "target": "pysam"
    },
    {
      "source": "plot_heatmaps",
      "target": "altair_saver"
    },
    {
      "source": "plot_heatmaps",
      "target": "vega_datasets"
    },
    {
      "source": "plot_heatmaps",
      "target": "cyvcf2"
    },
    {
      "source": "plot_heatmaps",
      "target": "vegafusion"
    },
    {
      "source": "plot_heatmaps",
      "target": "pyarrow"
    },
    {
      "source": "plots_bars_illumina",
      "target": "pytables"
    },
    {
      "source": "plots_bars_illumina",
      "target": "vl-convert-python"
    },
    {
      "source": "plots_bars_illumina",
      "target": "pandas"
    },
    {
      "source": "plots_bars_illumina",
      "target": "scipy"
    },
    {
      "source": "plots_bars_illumina",
      "target": "matplotlib"
    },
    {
      "source": "plots_bars_illumina",
      "target": "altair"
    },
    {
      "source": "plots_bars_illumina",
      "target": "pysam"
    },
    {
      "source": "plots_bars_illumina",
      "target": "altair_saver"
    },
    {
      "source": "plots_bars_illumina",
      "target": "vega_datasets"
    },
    {
      "source": "plots_bars_illumina",
      "target": "cyvcf2"
    },
    {
      "source": "plots_bars_illumina",
      "target": "vegafusion"
    },
    {
      "source": "plots_bars_illumina",
      "target": "pyarrow"
    },
    {
      "source": "plot_bias",
      "target": "pytables"
    },
    {
      "source": "plot_bias",
      "target": "vl-convert-python"
    },
    {
      "source": "plot_bias",
      "target": "pandas"
    },
    {
      "source": "plot_bias",
      "target": "scipy"
    },
    {
      "source": "plot_bias",
      "target": "matplotlib"
    },
    {
      "source": "plot_bias",
      "target": "altair"
    },
    {
      "source": "plot_bias",
      "target": "pysam"
    },
    {
      "source": "plot_bias",
      "target": "altair_saver"
    },
    {
      "source": "plot_bias",
      "target": "vega_datasets"
    },
    {
      "source": "plot_bias",
      "target": "cyvcf2"
    },
    {
      "source": "plot_bias",
      "target": "vegafusion"
    },
    {
      "source": "plot_bias",
      "target": "pyarrow"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "pytables"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "vl-convert-python"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "pandas"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "scipy"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "matplotlib"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "altair"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "pysam"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "altair_saver"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "vega_datasets"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "cyvcf2"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "vegafusion"
    },
    {
      "source": "plot_runtime_comparison",
      "target": "pyarrow"
    },
    {
      "source": "methylDackel_compute_meth",
      "target": "methyldackel"
    },
    {
      "source": "methylDackel_rename_output",
      "target": "python"
    },
    {
      "source": "find_candidates",
      "target": "varlociraptor"
    },
    {
      "source": "split_candidates",
      "target": "rust-bio-tools"
    },
    {
      "source": "index_candidates",
      "target": "samtools"
    },
    {
      "source": "index_candidates",
      "target": "bcftools"
    },
    {
      "source": "mason_download",
      "target": "tar"
    },
    {
      "source": "mason_download",
      "target": "gawk"
    },
    {
      "source": "mason_download",
      "target": "cat"
    },
    {
      "source": "mason_download",
      "target": "gzip"
    },
    {
      "source": "mason_download",
      "target": "wget"
    },
    {
      "source": "mason_fake_methylation",
      "target": "mason"
    },
    {
      "source": "mason_fake_variants",
      "target": "mason"
    },
    {
      "source": "mason_fake_reads",
      "target": "mason"
    },
    {
      "source": "mason_align_reads",
      "target": "python"
    },
    {
      "source": "mason_align_reads",
      "target": "bwameth"
    },
    {
      "source": "mason_align_reads",
      "target": "ncurses"
    },
    {
      "source": "mason_align_reads",
      "target": "bwa-mem2"
    },
    {
      "source": "mason_sam_to_bam",
      "target": "samtools"
    },
    {
      "source": "mason_sam_to_bam",
      "target": "bcftools"
    },
    {
      "source": "mason_sort_reads",
      "target": "samtools"
    },
    {
      "source": "mason_sort_reads",
      "target": "bcftools"
    },
    {
      "source": "mason_alignment_forward",
      "target": "samtools"
    },
    {
      "source": "mason_alignment_forward",
      "target": "bcftools"
    },
    {
      "source": "mason_alignment_reverse",
      "target": "samtools"
    },
    {
      "source": "mason_alignment_reverse",
      "target": "bcftools"
    },
    {
      "source": "mason_sort_oriented_reads",
      "target": "samtools"
    },
    {
      "source": "mason_sort_oriented_reads",
      "target": "bcftools"
    },
    {
      "source": "mason_index_oriented_alignment",
      "target": "samtools"
    },
    {
      "source": "mason_index_oriented_alignment",
      "target": "bcftools"
    },
    {
      "source": "mason_coverage",
      "target": "bio/mosdepth\""
    },
    {
      "source": "mason_unzip_coverage",
      "target": "python"
    },
    {
      "source": "mason_compute_truth",
      "target": "python"
    },
    {
      "source": "mason_compute_truth",
      "target": "numpy"
    },
    {
      "source": "varlociraptor_preprocess",
      "target": "varlociraptor"
    },
    {
      "source": "varlociraptor_call",
      "target": "varlociraptor"
    },
    {
      "source": "calls_to_vcf",
      "target": "samtools"
    },
    {
      "source": "calls_to_vcf",
      "target": "bcftools"
    },
    {
      "source": "gather_calls",
      "target": "python"
    },
    {
      "source": "genome_index",
      "target": "samtools"
    },
    {
      "source": "genome_index",
      "target": "bcftools"
    },
    {
      "source": "focus_genome_on_chromosome",
      "target": "samtools"
    },
    {
      "source": "focus_genome_on_chromosome",
      "target": "bcftools"
    },
    {
      "source": "chromosome_index",
      "target": "samtools"
    },
    {
      "source": "chromosome_index",
      "target": "bcftools"
    },
    {
      "source": "rename_chromosome_in_fasta",
      "target": "python"
    },
    {
      "source": "rename_chromosome_in_fasta",
      "target": "numpy"
    },
    {
      "source": "get_fastq_pe",
      "target": "bio/sra-tools/fasterq-dump\""
    },
    {
      "source": "get_fastq_se",
      "target": "bio/sra-tools/fasterq-dump\""
    },
    {
      "source": "trim_fastq_pe",
      "target": "fastp"
    },
    {
      "source": "trim_fastq_se",
      "target": "fastp"
    },
    {
      "source": "get_pacbio_data",
      "target": "samtools"
    },
    {
      "source": "get_pacbio_data",
      "target": "bcftools"
    },
    {
      "source": "get_nanopore_data",
      "target": "samtools"
    },
    {
      "source": "get_nanopore_data",
      "target": "bcftools"
    },
    {
      "source": "call_methylation_together_np_pb",
      "target": "varlociraptor"
    },
    {
      "source": "call_methylation_together_np_trueOX",
      "target": "varlociraptor"
    },
    {
      "source": "call_methylation_together_pb_trueOX",
      "target": "varlociraptor"
    },
    {
      "source": "bissnp_download",
      "target": "tar"
    },
    {
      "source": "bissnp_download",
      "target": "gawk"
    },
    {
      "source": "bissnp_download",
      "target": "cat"
    },
    {
      "source": "bissnp_download",
      "target": "gzip"
    },
    {
      "source": "bissnp_download",
      "target": "wget"
    },
    {
      "source": "bissnp_prepare",
      "target": "python"
    },
    {
      "source": "bissnp_extract",
      "target": "openjdk"
    },
    {
      "source": "gather_bisSnp",
      "target": "python"
    },
    {
      "source": "bissnp_create_bedgraph",
      "target": "openjdk"
    },
    {
      "source": "bissnp_merge_positions",
      "target": "pandas"
    },
    {
      "source": "bissnp_merge_positions",
      "target": "pysam"
    },
    {
      "source": "bsmapz_clone_and_build",
      "target": "python"
    },
    {
      "source": "bsmapz_compute_meth",
      "target": "python"
    },
    {
      "source": "bsmapz_extract",
      "target": "bsmapz"
    },
    {
      "source": "bsmapz_rename_output",
      "target": "python"
    },
    {
      "source": "modkit_compute_methylation",
      "target": "ont-modkit"
    },
    {
      "source": "pb_CpG_download",
      "target": "tar"
    },
    {
      "source": "pb_CpG_download",
      "target": "gawk"
    },
    {
      "source": "pb_CpG_download",
      "target": "cat"
    },
    {
      "source": "pb_CpG_download",
      "target": "gzip"
    },
    {
      "source": "pb_CpG_download",
      "target": "wget"
    },
    {
      "source": "pb_CpG_compute_methylation",
      "target": "python"
    },
    {
      "source": "pb_CpG_rename_output",
      "target": "python"
    },
    {
      "source": "bismark_copy_genome",
      "target": "python"
    },
    {
      "source": "bismark_copy_chromosome",
      "target": "bowtie2"
    },
    {
      "source": "bismark_copy_chromosome",
      "target": "bismark"
    },
    {
      "source": "bismark_prepare_genome",
      "target": "bowtie2"
    },
    {
      "source": "bismark_prepare_genome",
      "target": "bismark"
    },
    {
      "source": "bismark_align",
      "target": "bio/bismark/bismark\""
    },
    {
      "source": "samtools_merge",
      "target": "bio/samtools/merge\""
    },
    {
      "source": "deduplicate_bismark",
      "target": "bio/bismark/deduplicate_bismark\""
    },
    {
      "source": "bismark_extract",
      "target": "bowtie2"
    },
    {
      "source": "bismark_extract",
      "target": "bismark"
    },
    {
      "source": "bismark_merge_positions",
      "target": "pandas"
    },
    {
      "source": "bismark_merge_positions",
      "target": "pysam"
    },
    {
      "source": "processImageData",
      "target": "seaborn"
    },
    {
      "source": "processImageData",
      "target": "matplotlib"
    },
    {
      "source": "processImageData",
      "target": "meshio"
    },
    {
      "source": "processImageData",
      "target": "pyacvd"
    },
    {
      "source": "processImageData",
      "target": "dask-image"
    },
    {
      "source": "processImageData",
      "target": "pip"
    },
    {
      "source": "processImageData",
      "target": "pyvista"
    },
    {
      "source": "processImageData",
      "target": "scikit-image"
    },
    {
      "source": "trim_reads",
      "target": "cutadapt"
    },
    {
      "source": "parse_demux",
      "target": "pandas"
    },
    {
      "source": "parse_demux",
      "target": "openpyxl"
    },
    {
      "source": "mirtrace",
      "target": "mirtrace"
    },
    {
      "source": "starsolo",
      "target": "humanfriendly"
    },
    {
      "source": "starsolo",
      "target": "star"
    },
    {
      "source": "format_starsolo",
      "target": "pandas"
    },
    {
      "source": "format_starsolo",
      "target": "openpyxl"
    },
    {
      "source": "convert_sheet",
      "target": "pandas"
    },
    {
      "source": "convert_sheet",
      "target": "openpyxl"
    },
    {
      "source": "demux",
      "target": "bcl2fastq"
    },
    {
      "source": "demux",
      "target": "pandas"
    },
    {
      "source": "demux",
      "target": "openpyxl"
    },
    {
      "source": "merge_fastq",
      "target": "pandas"
    },
    {
      "source": "merge_fastq",
      "target": "pysam"
    },
    {
      "source": "collapse_reads",
      "target": "setuptools"
    },
    {
      "source": "collapse_reads",
      "target": "python"
    },
    {
      "source": "collapse_reads",
      "target": "seqcluster"
    },
    {
      "source": "fasta_to_chrom_gtf",
      "target": "pandas"
    },
    {
      "source": "fasta_to_chrom_gtf",
      "target": "openpyxl"
    },
    {
      "source": "star_index_hairpin",
      "target": "humanfriendly"
    },
    {
      "source": "star_index_hairpin",
      "target": "star"
    },
    {
      "source": "star_align_hairpin",
      "target": "humanfriendly"
    },
    {
      "source": "star_align_hairpin",
      "target": "star"
    },
    {
      "source": "mirtop",
      "target": "mirtop"
    },
    {
      "source": "mirtop",
      "target": "python"
    },
    {
      "source": "mirtop",
      "target": "samtools"
    },
    {
      "source": "mirtop",
      "target": "setuptools"
    },
    {
      "source": "starsolo_align_hairpin",
      "target": "humanfriendly"
    },
    {
      "source": "starsolo_align_hairpin",
      "target": "star"
    },
    {
      "source": "deduplicate_reads",
      "target": "pandas"
    },
    {
      "source": "deduplicate_reads",
      "target": "pysam"
    },
    {
      "source": "split_bam_by_barcode",
      "target": "samtools"
    },
    {
      "source": "mirtop_counts_per_barcode",
      "target": "mirtop"
    },
    {
      "source": "mirtop_counts_per_barcode",
      "target": "python"
    },
    {
      "source": "mirtop_counts_per_barcode",
      "target": "samtools"
    },
    {
      "source": "mirtop_counts_per_barcode",
      "target": "setuptools"
    },
    {
      "source": "aggregate_mirtop_counts",
      "target": "scipy"
    },
    {
      "source": "aggregate_mirtop_counts",
      "target": "pandas"
    },
    {
      "source": "aggregate_mirtop_counts",
      "target": "numpy"
    },
    {
      "source": "vcf_to_tsv",
      "target": "rust-bio-tools"
    },
    {
      "source": "vcf_to_tsv",
      "target": "bcftools"
    },
    {
      "source": "plot_stats",
      "target": "pandas"
    },
    {
      "source": "plot_stats",
      "target": "python"
    },
    {
      "source": "plot_stats",
      "target": "seaborn"
    },
    {
      "source": "plot_stats",
      "target": "matplotlib"
    },
    {
      "source": "plot_stats",
      "target": "numpy"
    },
    {
      "source": "genome_dict",
      "target": "samtools"
    },
    {
      "source": "remove_iupac_codes",
      "target": "rust-bio-tools"
    },
    {
      "source": "remove_iupac_codes",
      "target": "bcftools"
    },
    {
      "source": "apply_base_quality_recalibration",
      "target": "bio/gatk/applybqsr\""
    },
    {
      "source": "get_reads",
      "target": "dnaio"
    },
    {
      "source": "get_reads",
      "target": "python"
    },
    {
      "source": "get_reads",
      "target": "pandas"
    },
    {
      "source": "get_reads",
      "target": "pysam"
    },
    {
      "source": "get_archive",
      "target": "samtools"
    },
    {
      "source": "get_archive",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_archive",
      "target": "bedtools"
    },
    {
      "source": "get_archive",
      "target": "bcftools"
    },
    {
      "source": "get_archive",
      "target": "curl"
    },
    {
      "source": "get_truth",
      "target": "samtools"
    },
    {
      "source": "get_truth",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_truth",
      "target": "bedtools"
    },
    {
      "source": "get_truth",
      "target": "bcftools"
    },
    {
      "source": "get_truth",
      "target": "curl"
    },
    {
      "source": "rename_truth_contigs",
      "target": "samtools"
    },
    {
      "source": "rename_truth_contigs",
      "target": "ucsc-liftover"
    },
    {
      "source": "rename_truth_contigs",
      "target": "bedtools"
    },
    {
      "source": "rename_truth_contigs",
      "target": "bcftools"
    },
    {
      "source": "rename_truth_contigs",
      "target": "curl"
    },
    {
      "source": "merge_truthsets",
      "target": "samtools"
    },
    {
      "source": "merge_truthsets",
      "target": "ucsc-liftover"
    },
    {
      "source": "merge_truthsets",
      "target": "bedtools"
    },
    {
      "source": "merge_truthsets",
      "target": "bcftools"
    },
    {
      "source": "merge_truthsets",
      "target": "curl"
    },
    {
      "source": "normalize_truth",
      "target": "bio/bcftools/norm\""
    },
    {
      "source": "get_confidence_bed",
      "target": "samtools"
    },
    {
      "source": "get_confidence_bed",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_confidence_bed",
      "target": "bedtools"
    },
    {
      "source": "get_confidence_bed",
      "target": "bcftools"
    },
    {
      "source": "get_confidence_bed",
      "target": "curl"
    },
    {
      "source": "get_liftover_track",
      "target": "samtools"
    },
    {
      "source": "get_liftover_track",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_liftover_track",
      "target": "bedtools"
    },
    {
      "source": "get_liftover_track",
      "target": "bcftools"
    },
    {
      "source": "get_liftover_track",
      "target": "curl"
    },
    {
      "source": "get_target_bed",
      "target": "samtools"
    },
    {
      "source": "get_target_bed",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_target_bed",
      "target": "bedtools"
    },
    {
      "source": "get_target_bed",
      "target": "bcftools"
    },
    {
      "source": "get_target_bed",
      "target": "curl"
    },
    {
      "source": "postprocess_target_bed",
      "target": "samtools"
    },
    {
      "source": "postprocess_target_bed",
      "target": "ucsc-liftover"
    },
    {
      "source": "postprocess_target_bed",
      "target": "bedtools"
    },
    {
      "source": "postprocess_target_bed",
      "target": "bcftools"
    },
    {
      "source": "postprocess_target_bed",
      "target": "curl"
    },
    {
      "source": "get_reference",
      "target": "bio/reference/ensembl-sequence\""
    },
    {
      "source": "get_liftover_chain",
      "target": "samtools"
    },
    {
      "source": "get_liftover_chain",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_liftover_chain",
      "target": "bedtools"
    },
    {
      "source": "get_liftover_chain",
      "target": "bcftools"
    },
    {
      "source": "get_liftover_chain",
      "target": "curl"
    },
    {
      "source": "samtools_faidx",
      "target": "bio/samtools/faidx\""
    },
    {
      "source": "stratify_regions",
      "target": "samtools"
    },
    {
      "source": "stratify_regions",
      "target": "ucsc-liftover"
    },
    {
      "source": "stratify_regions",
      "target": "bedtools"
    },
    {
      "source": "stratify_regions",
      "target": "bcftools"
    },
    {
      "source": "stratify_regions",
      "target": "curl"
    },
    {
      "source": "extract_fp_fn",
      "target": "vembrane"
    },
    {
      "source": "extract_fp_fn",
      "target": "bcftools"
    },
    {
      "source": "extract_fp_fn_tp",
      "target": "bio/vembrane/table\""
    },
    {
      "source": "reformat_fp_fn_tp_tables",
      "target": "statsmodels"
    },
    {
      "source": "reformat_fp_fn_tp_tables",
      "target": "pandas"
    },
    {
      "source": "reformat_fp_fn_tp_tables",
      "target": "scikit-learn"
    },
    {
      "source": "reformat_fp_fn_tp_tables",
      "target": "scipy"
    },
    {
      "source": "reformat_fp_fn_tp_tables",
      "target": "python"
    },
    {
      "source": "calc_precision_recall",
      "target": "dnaio"
    },
    {
      "source": "calc_precision_recall",
      "target": "python"
    },
    {
      "source": "calc_precision_recall",
      "target": "pandas"
    },
    {
      "source": "calc_precision_recall",
      "target": "pysam"
    },
    {
      "source": "collect_precision_recall",
      "target": "statsmodels"
    },
    {
      "source": "collect_precision_recall",
      "target": "pandas"
    },
    {
      "source": "collect_precision_recall",
      "target": "scikit-learn"
    },
    {
      "source": "collect_precision_recall",
      "target": "scipy"
    },
    {
      "source": "collect_precision_recall",
      "target": "python"
    },
    {
      "source": "report_precision_recall",
      "target": "utils/datavzrd\""
    },
    {
      "source": "collect_fp_fn_benchmark",
      "target": "statsmodels"
    },
    {
      "source": "collect_fp_fn_benchmark",
      "target": "pandas"
    },
    {
      "source": "collect_fp_fn_benchmark",
      "target": "scikit-learn"
    },
    {
      "source": "collect_fp_fn_benchmark",
      "target": "scipy"
    },
    {
      "source": "collect_fp_fn_benchmark",
      "target": "python"
    },
    {
      "source": "filter_shared_fn",
      "target": "dnaio"
    },
    {
      "source": "filter_shared_fn",
      "target": "python"
    },
    {
      "source": "filter_shared_fn",
      "target": "pandas"
    },
    {
      "source": "filter_shared_fn",
      "target": "pysam"
    },
    {
      "source": "filter_unique",
      "target": "dnaio"
    },
    {
      "source": "filter_unique",
      "target": "python"
    },
    {
      "source": "filter_unique",
      "target": "pandas"
    },
    {
      "source": "filter_unique",
      "target": "pysam"
    },
    {
      "source": "write_shared_fn_vcf",
      "target": "dnaio"
    },
    {
      "source": "write_shared_fn_vcf",
      "target": "python"
    },
    {
      "source": "write_shared_fn_vcf",
      "target": "pandas"
    },
    {
      "source": "write_shared_fn_vcf",
      "target": "pysam"
    },
    {
      "source": "write_unique_fn_vcf",
      "target": "dnaio"
    },
    {
      "source": "write_unique_fn_vcf",
      "target": "python"
    },
    {
      "source": "write_unique_fn_vcf",
      "target": "pandas"
    },
    {
      "source": "write_unique_fn_vcf",
      "target": "pysam"
    },
    {
      "source": "write_unique_fp_vcf",
      "target": "dnaio"
    },
    {
      "source": "write_unique_fp_vcf",
      "target": "python"
    },
    {
      "source": "write_unique_fp_vcf",
      "target": "pandas"
    },
    {
      "source": "write_unique_fp_vcf",
      "target": "pysam"
    },
    {
      "source": "report_fp_fn",
      "target": "utils/datavzrd\""
    },
    {
      "source": "report_fp_fn_callset",
      "target": "utils/datavzrd\""
    },
    {
      "source": "get_downsampled_vep_cache",
      "target": "samtools"
    },
    {
      "source": "get_downsampled_vep_cache",
      "target": "ucsc-liftover"
    },
    {
      "source": "get_downsampled_vep_cache",
      "target": "bedtools"
    },
    {
      "source": "get_downsampled_vep_cache",
      "target": "bcftools"
    },
    {
      "source": "get_downsampled_vep_cache",
      "target": "curl"
    },
    {
      "source": "download_revel",
      "target": "samtools"
    },
    {
      "source": "download_revel",
      "target": "ucsc-liftover"
    },
    {
      "source": "download_revel",
      "target": "bedtools"
    },
    {
      "source": "download_revel",
      "target": "bcftools"
    },
    {
      "source": "download_revel",
      "target": "curl"
    },
    {
      "source": "process_revel_scores",
      "target": "samtools"
    },
    {
      "source": "process_revel_scores",
      "target": "ucsc-liftover"
    },
    {
      "source": "process_revel_scores",
      "target": "bedtools"
    },
    {
      "source": "process_revel_scores",
      "target": "bcftools"
    },
    {
      "source": "process_revel_scores",
      "target": "curl"
    },
    {
      "source": "tabix_revel_scores",
      "target": "bio/tabix/index\""
    },
    {
      "source": "annotate_shared_fn",
      "target": "bio/vep/annotate\""
    },
    {
      "source": "annotate_unique_fp_fn",
      "target": "bio/vep/annotate\""
    },
    {
      "source": "vembrane_table_shared_fn",
      "target": "bio/vembrane/table\""
    },
    {
      "source": "vembrane_table_unique_fp_fn",
      "target": "bio/vembrane/table\""
    },
    {
      "source": "norm_vcf",
      "target": "bio/bcftools/norm\""
    },
    {
      "source": "index_vcf",
      "target": "bio/bcftools/index\""
    },
    {
      "source": "index_bcf",
      "target": "bio/bcftools/index\""
    },
    {
      "source": "sort_vcf",
      "target": "bio/bcftools/sort\""
    },
    {
      "source": "get_reference_dict",
      "target": "picard"
    },
    {
      "source": "merge_callsets",
      "target": "samtools"
    },
    {
      "source": "merge_callsets",
      "target": "ucsc-liftover"
    },
    {
      "source": "merge_callsets",
      "target": "bedtools"
    },
    {
      "source": "merge_callsets",
      "target": "bcftools"
    },
    {
      "source": "merge_callsets",
      "target": "curl"
    },
    {
      "source": "liftover_callset",
      "target": "picard"
    },
    {
      "source": "add_format_field",
      "target": "bcftools"
    },
    {
      "source": "add_format_field",
      "target": "python"
    },
    {
      "source": "add_format_field",
      "target": "pip"
    },
    {
      "source": "remove_non_pass",
      "target": "bio/bcftools/view\""
    },
    {
      "source": "intersect_calls_with_target_regions",
      "target": "samtools"
    },
    {
      "source": "intersect_calls_with_target_regions",
      "target": "ucsc-liftover"
    },
    {
      "source": "intersect_calls_with_target_regions",
      "target": "bedtools"
    },
    {
      "source": "intersect_calls_with_target_regions",
      "target": "bcftools"
    },
    {
      "source": "intersect_calls_with_target_regions",
      "target": "curl"
    },
    {
      "source": "restrict_to_reference_contigs",
      "target": "samtools"
    },
    {
      "source": "restrict_to_reference_contigs",
      "target": "ucsc-liftover"
    },
    {
      "source": "restrict_to_reference_contigs",
      "target": "bedtools"
    },
    {
      "source": "restrict_to_reference_contigs",
      "target": "bcftools"
    },
    {
      "source": "restrict_to_reference_contigs",
      "target": "curl"
    },
    {
      "source": "normalize_calls",
      "target": "samtools"
    },
    {
      "source": "normalize_calls",
      "target": "ucsc-liftover"
    },
    {
      "source": "normalize_calls",
      "target": "bedtools"
    },
    {
      "source": "normalize_calls",
      "target": "bcftools"
    },
    {
      "source": "normalize_calls",
      "target": "curl"
    },
    {
      "source": "stratify_truth",
      "target": "samtools"
    },
    {
      "source": "stratify_truth",
      "target": "ucsc-liftover"
    },
    {
      "source": "stratify_truth",
      "target": "bedtools"
    },
    {
      "source": "stratify_truth",
      "target": "bcftools"
    },
    {
      "source": "stratify_truth",
      "target": "curl"
    },
    {
      "source": "stratify_results",
      "target": "samtools"
    },
    {
      "source": "stratify_results",
      "target": "ucsc-liftover"
    },
    {
      "source": "stratify_results",
      "target": "bedtools"
    },
    {
      "source": "stratify_results",
      "target": "bcftools"
    },
    {
      "source": "stratify_results",
      "target": "curl"
    },
    {
      "source": "index_stratified_truth",
      "target": "bio/bcftools/index\""
    },
    {
      "source": "stat_truth",
      "target": "dnaio"
    },
    {
      "source": "stat_truth",
      "target": "python"
    },
    {
      "source": "stat_truth",
      "target": "pandas"
    },
    {
      "source": "stat_truth",
      "target": "pysam"
    },
    {
      "source": "generate_sdf",
      "target": "rtg-tools"
    },
    {
      "source": "benchmark_variants_germline",
      "target": "rtg-tools"
    },
    {
      "source": "benchmark_variants_somatic",
      "target": "rtg-tools"
    },
    {
      "source": "blast2threshold_table",
      "target": "numba"
    },
    {
      "source": "blast2threshold_table",
      "target": "numpy"
    },
    {
      "source": "blast2threshold_table",
      "target": "pandas"
    },
    {
      "source": "blast2threshold_table",
      "target": "matplotlib"
    },
    {
      "source": "report_threshold",
      "target": "plotly"
    },
    {
      "source": "report_threshold",
      "target": "pandas"
    },
    {
      "source": "fetch_proteins_database",
      "target": "ncbi-genome-download"
    },
    {
      "source": "fetch_proteins_database",
      "target": "pandas"
    },
    {
      "source": "fetch_proteins_database",
      "target": "numpy"
    },
    {
      "source": "fetch_proteins_database",
      "target": "ete3"
    },
    {
      "source": "fetch_proteins_database",
      "target": "biopython"
    },
    {
      "source": "fetch_fasta_from_seed",
      "target": "ncbi-genome-download"
    },
    {
      "source": "fetch_fasta_from_seed",
      "target": "pandas"
    },
    {
      "source": "fetch_fasta_from_seed",
      "target": "numpy"
    },
    {
      "source": "fetch_fasta_from_seed",
      "target": "ete3"
    },
    {
      "source": "fetch_fasta_from_seed",
      "target": "biopython"
    },
    {
      "source": "make_fasta",
      "target": "ncbi-genome-download"
    },
    {
      "source": "make_fasta",
      "target": "pandas"
    },
    {
      "source": "make_fasta",
      "target": "numpy"
    },
    {
      "source": "make_fasta",
      "target": "ete3"
    },
    {
      "source": "make_fasta",
      "target": "biopython"
    },
    {
      "source": "make_seed_psiblast",
      "target": "ncbi-genome-download"
    },
    {
      "source": "make_seed_psiblast",
      "target": "pandas"
    },
    {
      "source": "make_seed_psiblast",
      "target": "numpy"
    },
    {
      "source": "make_seed_psiblast",
      "target": "ete3"
    },
    {
      "source": "make_seed_psiblast",
      "target": "biopython"
    },
    {
      "source": "extract_protein",
      "target": "ncbi-genome-download"
    },
    {
      "source": "extract_protein",
      "target": "pandas"
    },
    {
      "source": "extract_protein",
      "target": "numpy"
    },
    {
      "source": "extract_protein",
      "target": "ete3"
    },
    {
      "source": "extract_protein",
      "target": "biopython"
    },
    {
      "source": "merge_databases",
      "target": "ncbi-genome-download"
    },
    {
      "source": "merge_databases",
      "target": "pandas"
    },
    {
      "source": "merge_databases",
      "target": "numpy"
    },
    {
      "source": "merge_databases",
      "target": "ete3"
    },
    {
      "source": "merge_databases",
      "target": "biopython"
    },
    {
      "source": "psiblast",
      "target": "blast"
    },
    {
      "source": "psiblast",
      "target": "pandas"
    },
    {
      "source": "psiblast",
      "target": "biopython"
    },
    {
      "source": "blast",
      "target": "blast"
    },
    {
      "source": "blast",
      "target": "pandas"
    },
    {
      "source": "blast",
      "target": "biopython"
    },
    {
      "source": "blast",
      "target": "openssl"
    },
    {
      "source": "blast",
      "target": "curl"
    },
    {
      "source": "read_psiblast",
      "target": "numba"
    },
    {
      "source": "read_psiblast",
      "target": "numpy"
    },
    {
      "source": "read_psiblast",
      "target": "pandas"
    },
    {
      "source": "read_psiblast",
      "target": "matplotlib"
    },
    {
      "source": "read_hmmsearch",
      "target": "numba"
    },
    {
      "source": "read_hmmsearch",
      "target": "numpy"
    },
    {
      "source": "read_hmmsearch",
      "target": "pandas"
    },
    {
      "source": "read_hmmsearch",
      "target": "matplotlib"
    },
    {
      "source": "prepare_for_silix",
      "target": "numba"
    },
    {
      "source": "prepare_for_silix",
      "target": "numpy"
    },
    {
      "source": "prepare_for_silix",
      "target": "pandas"
    },
    {
      "source": "prepare_for_silix",
      "target": "matplotlib"
    },
    {
      "source": "find_family",
      "target": "numba"
    },
    {
      "source": "find_family",
      "target": "numpy"
    },
    {
      "source": "find_family",
      "target": "pandas"
    },
    {
      "source": "find_family",
      "target": "matplotlib"
    },
    {
      "source": "make_PA_table",
      "target": "numba"
    },
    {
      "source": "make_PA_table",
      "target": "numpy"
    },
    {
      "source": "make_PA_table",
      "target": "pandas"
    },
    {
      "source": "make_PA_table",
      "target": "matplotlib"
    },
    {
      "source": "silix",
      "target": "silix"
    },
    {
      "source": "plots",
      "target": "numba"
    },
    {
      "source": "plots",
      "target": "numpy"
    },
    {
      "source": "plots",
      "target": "pandas"
    },
    {
      "source": "plots",
      "target": "matplotlib"
    },
    {
      "source": "user_plots",
      "target": "numba"
    },
    {
      "source": "user_plots",
      "target": "numpy"
    },
    {
      "source": "user_plots",
      "target": "pandas"
    },
    {
      "source": "user_plots",
      "target": "matplotlib"
    },
    {
      "source": "hmmsearch",
      "target": "hmmer"
    },
    {
      "source": "sample_prep",
      "target": "usearch"
    },
    {
      "source": "sample_prep",
      "target": "gzip"
    },
    {
      "source": "sample_prep",
      "target": "cutadapt"
    },
    {
      "source": "sample_prep",
      "target": "savont"
    },
    {
      "source": "sample_prep",
      "target": "filtlong"
    },
    {
      "source": "concatenate_total_reads_files",
      "target": "usearch"
    },
    {
      "source": "concatenate_total_reads_files",
      "target": "gzip"
    },
    {
      "source": "concatenate_total_reads_files",
      "target": "cutadapt"
    },
    {
      "source": "concatenate_total_reads_files",
      "target": "savont"
    },
    {
      "source": "concatenate_total_reads_files",
      "target": "filtlong"
    },
    {
      "source": "merge_abund_tables",
      "target": "usearch"
    },
    {
      "source": "merge_abund_tables",
      "target": "gzip"
    },
    {
      "source": "merge_abund_tables",
      "target": "cutadapt"
    },
    {
      "source": "merge_abund_tables",
      "target": "savont"
    },
    {
      "source": "merge_abund_tables",
      "target": "filtlong"
    },
    {
      "source": "rarefy_abund_table",
      "target": "usearch"
    },
    {
      "source": "rarefy_abund_table",
      "target": "gzip"
    },
    {
      "source": "rarefy_abund_table",
      "target": "cutadapt"
    },
    {
      "source": "rarefy_abund_table",
      "target": "savont"
    },
    {
      "source": "rarefy_abund_table",
      "target": "filtlong"
    },
    {
      "source": "sintax",
      "target": "usearch"
    },
    {
      "source": "sintax",
      "target": "gzip"
    },
    {
      "source": "sintax",
      "target": "cutadapt"
    },
    {
      "source": "sintax",
      "target": "filtlong"
    },
    {
      "source": "concat_all",
      "target": "usearch"
    },
    {
      "source": "concat_all",
      "target": "gzip"
    },
    {
      "source": "concat_all",
      "target": "cutadapt"
    },
    {
      "source": "concat_all",
      "target": "savont"
    },
    {
      "source": "concat_all",
      "target": "filtlong"
    },
    {
      "source": "cutadapt",
      "target": "usearch"
    },
    {
      "source": "cutadapt",
      "target": "gzip"
    },
    {
      "source": "cutadapt",
      "target": "cutadapt"
    },
    {
      "source": "cutadapt",
      "target": "savont"
    },
    {
      "source": "cutadapt",
      "target": "filtlong"
    },
    {
      "source": "derep",
      "target": "usearch"
    },
    {
      "source": "derep",
      "target": "gzip"
    },
    {
      "source": "derep",
      "target": "cutadapt"
    },
    {
      "source": "derep",
      "target": "filtlong"
    },
    {
      "source": "unoise",
      "target": "usearch"
    },
    {
      "source": "unoise",
      "target": "gzip"
    },
    {
      "source": "unoise",
      "target": "cutadapt"
    },
    {
      "source": "unoise",
      "target": "filtlong"
    },
    {
      "source": "sintax_classify",
      "target": "savont"
    },
    {
      "source": "sintax_classify",
      "target": "gzip"
    },
    {
      "source": "sintax_classify",
      "target": "cutadapt"
    },
    {
      "source": "sintax_classify",
      "target": "usearch"
    },
    {
      "source": "savont_classify",
      "target": "savont"
    },
    {
      "source": "savont_classify",
      "target": "gzip"
    },
    {
      "source": "savont_classify",
      "target": "cutadapt"
    },
    {
      "source": "savont_classify",
      "target": "usearch"
    },
    {
      "source": "savont_asv",
      "target": "savont"
    },
    {
      "source": "savont_asv",
      "target": "gzip"
    },
    {
      "source": "savont_asv",
      "target": "cutadapt"
    },
    {
      "source": "savont_asv",
      "target": "usearch"
    },
    {
      "source": "minimap2",
      "target": "bio/minimap2/aligner\""
    },
    {
      "source": "samtools_view",
      "target": "bio/samtools/view\""
    },
    {
      "source": "noderad",
      "target": "xorg-libxcomposite"
    },
    {
      "source": "noderad",
      "target": "xorg-libxau"
    },
    {
      "source": "noderad",
      "target": "xorg-libxinerama"
    },
    {
      "source": "noderad",
      "target": "xorg-libxcursor"
    },
    {
      "source": "noderad",
      "target": "pysam"
    },
    {
      "source": "noderad",
      "target": "xorg-libxi"
    },
    {
      "source": "noderad",
      "target": "xorg-libxrandr"
    },
    {
      "source": "noderad",
      "target": "graph-tool"
    },
    {
      "source": "noderad",
      "target": "biopython"
    },
    {
      "source": "noderad",
      "target": "xorg-libxdamage"
    },
    {
      "source": "simulated_data_to_fasta",
      "target": "pyyaml"
    },
    {
      "source": "blast_database",
      "target": "blast"
    },
    {
      "source": "blast_database",
      "target": "openssl"
    },
    {
      "source": "blast_database",
      "target": "curl"
    },
    {
      "source": "plots_blast",
      "target": "r-tidyverse"
    },
    {
      "source": "plots_blast",
      "target": "r-stringr"
    },
    {
      "source": "rseqc_make_bed",
      "target": "gffutils"
    },
    {
      "source": "rseqc_junction_annotation",
      "target": "rseqc"
    },
    {
      "source": "rseqc_junction_saturation",
      "target": "rseqc"
    },
    {
      "source": "rseqc_inner_distance",
      "target": "rseqc"
    },
    {
      "source": "rseqc_read_distribution",
      "target": "rseqc"
    },
    {
      "source": "rseqc_read_duplication",
      "target": "rseqc"
    },
    {
      "source": "rseqc_readgc",
      "target": "rseqc"
    },
    {
      "source": "rseqc_gene_body_coverage",
      "target": "rseqc"
    },
    {
      "source": "deseq",
      "target": "r-ggplot2"
    },
    {
      "source": "deseq",
      "target": "bioconductor-fgsea"
    },
    {
      "source": "deseq",
      "target": "r-pheatmap"
    },
    {
      "source": "deseq",
      "target": "r-ggrepel"
    },
    {
      "source": "deseq",
      "target": "r-writexls"
    },
    {
      "source": "deseq",
      "target": "r-ashr"
    },
    {
      "source": "deseq",
      "target": "r-yaml"
    },
    {
      "source": "deseq",
      "target": "bioconductor-deseq2"
    },
    {
      "source": "deseq",
      "target": "perl"
    },
    {
      "source": "deseq",
      "target": "r-data.table"
    },
    {
      "source": "deseq",
      "target": "radian"
    },
    {
      "source": "star",
      "target": "samtools"
    },
    {
      "source": "star",
      "target": "star"
    },
    {
      "source": "star_index_bam",
      "target": "samtools"
    },
    {
      "source": "star_index_bam",
      "target": "star"
    },
    {
      "source": "count_matrix",
      "target": "pandas"
    },
    {
      "source": "star_index_genome",
      "target": "samtools"
    },
    {
      "source": "star_index_genome",
      "target": "star"
    },
    {
      "source": "nanoplot_rawfastq",
      "target": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/nanoplot\""
    },
    {
      "source": "nanoplot_filteredfastq",
      "target": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/nanoplot\""
    },
    {
      "source": "nanoplot_aligned",
      "target": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/nanoplot\""
    },
    {
      "source": "filtlong",
      "target": "filtlong"
    },
    {
      "source": "mapping",
      "target": "samtools"
    },
    {
      "source": "mapping",
      "target": "bedtools"
    },
    {
      "source": "mapping",
      "target": "minimap2"
    },
    {
      "source": "mapping",
      "target": "ngmlr"
    },
    {
      "source": "genomecoverage",
      "target": "samtools"
    },
    {
      "source": "genomecoverage",
      "target": "bedtools"
    },
    {
      "source": "genomecoverage",
      "target": "ngmlr"
    },
    {
      "source": "alignmentends",
      "target": "samtools"
    },
    {
      "source": "alignmentends",
      "target": "bedtools"
    },
    {
      "source": "alignmentends",
      "target": "ngmlr"
    },
    {
      "source": "snv_medaka",
      "target": "medaka"
    },
    {
      "source": "models_clair3",
      "target": "python"
    },
    {
      "source": "models_clair3",
      "target": "pandas"
    },
    {
      "source": "snv_clair3",
      "target": "clair3"
    },
    {
      "source": "sniffles2",
      "target": "sniffles"
    },
    {
      "source": "cutesv",
      "target": "cutesv"
    },
    {
      "source": "collect_vcfs",
      "target": "python"
    },
    {
      "source": "collect_vcfs",
      "target": "pandas"
    },
    {
      "source": "prepare_vcfs",
      "target": "python"
    },
    {
      "source": "prepare_vcfs",
      "target": "pandas"
    },
    {
      "source": "igv_reports",
      "target": "igv-reports"
    },
    {
      "source": "report",
      "target": "r-dt"
    },
    {
      "source": "report",
      "target": "r-tidyverse"
    },
    {
      "source": "report",
      "target": "r-rmarkdown"
    },
    {
      "source": "bcftools_pileup",
      "target": "bio/bcftools/mpileup\""
    },
    {
      "source": "bcftools_view",
      "target": "bio/bcftools/view\""
    },
    {
      "source": "bcftools_filter",
      "target": "bio/bcftools/filter\""
    },
    {
      "source": "bcftools_stats",
      "target": "bio/bcftools/stats\""
    },
    {
      "source": "freebayes",
      "target": "bio/freebayes\""
    },
    {
      "source": "vep_prepare",
      "target": "htslib"
    },
    {
      "source": "vep_plugins",
      "target": "bio/vep/plugins\""
    },
    {
      "source": "vep_annotate_variants",
      "target": "bio/vep/annotate\""
    },
    {
      "source": "snpeff_prepare",
      "target": "snakemake-wrapper-utils"
    },
    {
      "source": "snpeff_prepare",
      "target": "snpeff"
    },
    {
      "source": "snpeff",
      "target": "bio/snpeff/annotate\""
    },
    {
      "source": "bcftools_bcf_and_index",
      "target": "bio/bcftools/view\""
    },
    {
      "source": "bcftools_intersection",
      "target": "bcftools"
    },
    {
      "source": "report_html",
      "target": "r-base"
    },
    {
      "source": "report_html",
      "target": "bioconductor-genomicranges"
    },
    {
      "source": "report_html",
      "target": "r-ggpubr"
    },
    {
      "source": "report_html",
      "target": "r-dendextend"
    },
    {
      "source": "report_html",
      "target": "bioconductor-biostrings"
    },
    {
      "source": "report_html",
      "target": "r-ggrepel"
    },
    {
      "source": "report_html",
      "target": "r-essentials"
    },
    {
      "source": "report_html",
      "target": "bioconductor-genomicfeatures"
    },
    {
      "source": "report_html",
      "target": "r-ggupset"
    },
    {
      "source": "report_html",
      "target": "r-scales"
    },
    {
      "source": "report_html",
      "target": "r-tidyverse"
    },
    {
      "source": "report_html",
      "target": "r-rstatix"
    },
    {
      "source": "report_pdf",
      "target": "python"
    },
    {
      "source": "report_pdf",
      "target": "weasyprint"
    },
    {
      "source": "report_pdf",
      "target": "pydyf"
    },
    {
      "source": "database",
      "target": "python"
    },
    {
      "source": "database",
      "target": "ncbi-datasets-cli"
    },
    {
      "source": "decoypyrat",
      "target": "python"
    },
    {
      "source": "decoypyrat",
      "target": "decoypyrat"
    },
    {
      "source": "samplesheet",
      "target": "python"
    },
    {
      "source": "samplesheet",
      "target": "pandas"
    },
    {
      "source": "workflow",
      "target": "python"
    },
    {
      "source": "fragpipe",
      "target": "pandas"
    },
    {
      "source": "fragpipe",
      "target": "numpy"
    },
    {
      "source": "fragpipe",
      "target": "mono"
    },
    {
      "source": "fragpipe",
      "target": "python"
    },
    {
      "source": "fragpipe",
      "target": "cython"
    },
    {
      "source": "msstats",
      "target": "r-essentials"
    },
    {
      "source": "msstats",
      "target": "bioconductor-msstats"
    },
    {
      "source": "msstats",
      "target": "r-tidyverse"
    },
    {
      "source": "clean_up",
      "target": "python"
    },
    {
      "source": "clean_up",
      "target": "pandas"
    },
    {
      "source": "versions",
      "target": "python"
    },
    {
      "source": "versions",
      "target": "pandas"
    },
    {
      "source": "module_logs",
      "target": "python"
    },
    {
      "source": "module_logs",
      "target": "pandas"
    },
    {
      "source": "email",
      "target": "python"
    },
    {
      "source": "email",
      "target": "pandas"
    },
    {
      "source": "prepare_summary",
      "target": "python"
    },
    {
      "source": "pycoQC_report",
      "target": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/pycoqc\""
    },
    {
      "source": "nanoplot_report",
      "target": "\"https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/nanoplot\""
    },
    {
      "source": "download_model",
      "target": "python"
    },
    {
      "source": "dorado_simplex",
      "target": "python"
    },
    {
      "source": "samtools_bamtofq",
      "target": "samtools"
    },
    {
      "source": "dorado_summary",
      "target": "python"
    },
    {
      "source": "gzip",
      "target": "htslib"
    },
    {
      "source": "dorado_demux",
      "target": "python"
    },
    {
      "source": "collect_demuxed_fastq",
      "target": "python"
    },
    {
      "source": "aggregrate_file",
      "target": "htslib"
    },
    {
      "source": "aggregrate_barcode",
      "target": "htslib"
    },
    {
      "source": "breakup_shape",
      "target": "glom"
    },
    {
      "source": "breakup_shape",
      "target": "pyproj"
    },
    {
      "source": "breakup_shape",
      "target": "utm"
    },
    {
      "source": "breakup_shape",
      "target": "dask"
    },
    {
      "source": "breakup_shape",
      "target": "python"
    },
    {
      "source": "breakup_shape",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "breakup_shape",
      "target": "pyarrow"
    },
    {
      "source": "breakup_shape",
      "target": "gdal"
    },
    {
      "source": "breakup_shape",
      "target": "rasterio"
    },
    {
      "source": "breakup_shape",
      "target": "pandera-geopandas"
    },
    {
      "source": "breakup_shape",
      "target": "netcdf4"
    },
    {
      "source": "breakup_shape",
      "target": "pandas"
    },
    {
      "source": "breakup_shape",
      "target": "xarray"
    },
    {
      "source": "breakup_shape",
      "target": "libgdal-hdf5"
    },
    {
      "source": "breakup_shape",
      "target": "matplotlib"
    },
    {
      "source": "breakup_shape",
      "target": "fiona"
    },
    {
      "source": "breakup_shape",
      "target": "geopandas"
    },
    {
      "source": "breakup_shape",
      "target": "pyyaml"
    },
    {
      "source": "breakup_shape",
      "target": "click"
    },
    {
      "source": "breakup_shape",
      "target": "rioxarray"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "glom"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "pyproj"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "utm"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "dask"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "python"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "pyarrow"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "gdal"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "rasterio"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "pandera-geopandas"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "netcdf4"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "pandas"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "xarray"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "libgdal-hdf5"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "matplotlib"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "fiona"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "geopandas"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "pyyaml"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "click"
    },
    {
      "source": "prepare_resampled_inputs",
      "target": "rioxarray"
    },
    {
      "source": "aggregate_area_potential",
      "target": "glom"
    },
    {
      "source": "aggregate_area_potential",
      "target": "pyproj"
    },
    {
      "source": "aggregate_area_potential",
      "target": "utm"
    },
    {
      "source": "aggregate_area_potential",
      "target": "dask"
    },
    {
      "source": "aggregate_area_potential",
      "target": "python"
    },
    {
      "source": "aggregate_area_potential",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "aggregate_area_potential",
      "target": "pyarrow"
    },
    {
      "source": "aggregate_area_potential",
      "target": "gdal"
    },
    {
      "source": "aggregate_area_potential",
      "target": "rasterio"
    },
    {
      "source": "aggregate_area_potential",
      "target": "pandera-geopandas"
    },
    {
      "source": "aggregate_area_potential",
      "target": "netcdf4"
    },
    {
      "source": "aggregate_area_potential",
      "target": "pandas"
    },
    {
      "source": "aggregate_area_potential",
      "target": "xarray"
    },
    {
      "source": "aggregate_area_potential",
      "target": "libgdal-hdf5"
    },
    {
      "source": "aggregate_area_potential",
      "target": "matplotlib"
    },
    {
      "source": "aggregate_area_potential",
      "target": "fiona"
    },
    {
      "source": "aggregate_area_potential",
      "target": "geopandas"
    },
    {
      "source": "aggregate_area_potential",
      "target": "pyyaml"
    },
    {
      "source": "aggregate_area_potential",
      "target": "click"
    },
    {
      "source": "aggregate_area_potential",
      "target": "rioxarray"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "glom"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "pyproj"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "utm"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "dask"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "python"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "pyarrow"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "gdal"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "rasterio"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "pandera-geopandas"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "netcdf4"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "pandas"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "xarray"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "libgdal-hdf5"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "matplotlib"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "fiona"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "geopandas"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "pyyaml"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "click"
    },
    {
      "source": "plot_aggregated_area_potential",
      "target": "rioxarray"
    },
    {
      "source": "area_potential_report",
      "target": "glom"
    },
    {
      "source": "area_potential_report",
      "target": "pyproj"
    },
    {
      "source": "area_potential_report",
      "target": "utm"
    },
    {
      "source": "area_potential_report",
      "target": "dask"
    },
    {
      "source": "area_potential_report",
      "target": "python"
    },
    {
      "source": "area_potential_report",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "area_potential_report",
      "target": "pyarrow"
    },
    {
      "source": "area_potential_report",
      "target": "gdal"
    },
    {
      "source": "area_potential_report",
      "target": "rasterio"
    },
    {
      "source": "area_potential_report",
      "target": "pandera-geopandas"
    },
    {
      "source": "area_potential_report",
      "target": "netcdf4"
    },
    {
      "source": "area_potential_report",
      "target": "pandas"
    },
    {
      "source": "area_potential_report",
      "target": "xarray"
    },
    {
      "source": "area_potential_report",
      "target": "libgdal-hdf5"
    },
    {
      "source": "area_potential_report",
      "target": "matplotlib"
    },
    {
      "source": "area_potential_report",
      "target": "fiona"
    },
    {
      "source": "area_potential_report",
      "target": "geopandas"
    },
    {
      "source": "area_potential_report",
      "target": "pyyaml"
    },
    {
      "source": "area_potential_report",
      "target": "click"
    },
    {
      "source": "area_potential_report",
      "target": "rioxarray"
    },
    {
      "source": "clip_landcover",
      "target": "glom"
    },
    {
      "source": "clip_landcover",
      "target": "pyproj"
    },
    {
      "source": "clip_landcover",
      "target": "utm"
    },
    {
      "source": "clip_landcover",
      "target": "dask"
    },
    {
      "source": "clip_landcover",
      "target": "python"
    },
    {
      "source": "clip_landcover",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "clip_landcover",
      "target": "pyarrow"
    },
    {
      "source": "clip_landcover",
      "target": "gdal"
    },
    {
      "source": "clip_landcover",
      "target": "rasterio"
    },
    {
      "source": "clip_landcover",
      "target": "pandera-geopandas"
    },
    {
      "source": "clip_landcover",
      "target": "netcdf4"
    },
    {
      "source": "clip_landcover",
      "target": "pandas"
    },
    {
      "source": "clip_landcover",
      "target": "xarray"
    },
    {
      "source": "clip_landcover",
      "target": "libgdal-hdf5"
    },
    {
      "source": "clip_landcover",
      "target": "matplotlib"
    },
    {
      "source": "clip_landcover",
      "target": "fiona"
    },
    {
      "source": "clip_landcover",
      "target": "geopandas"
    },
    {
      "source": "clip_landcover",
      "target": "pyyaml"
    },
    {
      "source": "clip_landcover",
      "target": "click"
    },
    {
      "source": "clip_landcover",
      "target": "rioxarray"
    },
    {
      "source": "clip_settlement",
      "target": "glom"
    },
    {
      "source": "clip_settlement",
      "target": "pyproj"
    },
    {
      "source": "clip_settlement",
      "target": "utm"
    },
    {
      "source": "clip_settlement",
      "target": "dask"
    },
    {
      "source": "clip_settlement",
      "target": "python"
    },
    {
      "source": "clip_settlement",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "clip_settlement",
      "target": "pyarrow"
    },
    {
      "source": "clip_settlement",
      "target": "gdal"
    },
    {
      "source": "clip_settlement",
      "target": "rasterio"
    },
    {
      "source": "clip_settlement",
      "target": "pandera-geopandas"
    },
    {
      "source": "clip_settlement",
      "target": "netcdf4"
    },
    {
      "source": "clip_settlement",
      "target": "pandas"
    },
    {
      "source": "clip_settlement",
      "target": "xarray"
    },
    {
      "source": "clip_settlement",
      "target": "libgdal-hdf5"
    },
    {
      "source": "clip_settlement",
      "target": "matplotlib"
    },
    {
      "source": "clip_settlement",
      "target": "fiona"
    },
    {
      "source": "clip_settlement",
      "target": "geopandas"
    },
    {
      "source": "clip_settlement",
      "target": "pyyaml"
    },
    {
      "source": "clip_settlement",
      "target": "click"
    },
    {
      "source": "clip_settlement",
      "target": "rioxarray"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "glom"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "pyproj"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "utm"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "dask"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "python"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "libgdal-arrow-parquet"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "pyarrow"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "gdal"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "rasterio"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "pandera-geopandas"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "netcdf4"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "pandas"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "xarray"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "libgdal-hdf5"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "matplotlib"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "fiona"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "geopandas"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "pyyaml"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "click"
    },
    {
      "source": "rasterise_clip_wdpa",
      "target": "rioxarray"
    },
    {
      "source": "download_netherlands_shapes",
      "target": "click"
    },
    {
      "source": "download_netherlands_shapes",
      "target": "python"
    },
    {
      "source": "download_netherlands_shapes",
      "target": "curl"
    },
    {
      "source": "download_netherlands_protected_areas",
      "target": "click"
    },
    {
      "source": "download_netherlands_protected_areas",
      "target": "python"
    },
    {
      "source": "download_netherlands_protected_areas",
      "target": "curl"
    },
    {
      "source": "unzip_netherlands_protected_areas",
      "target": "click"
    },
    {
      "source": "unzip_netherlands_protected_areas",
      "target": "python"
    },
    {
      "source": "unzip_netherlands_protected_areas",
      "target": "curl"
    },
    {
      "source": "sintax_subset",
      "target": "usearch"
    },
    {
      "source": "sintax_subset",
      "target": "gzip"
    },
    {
      "source": "sintax_subset",
      "target": "cutadapt"
    },
    {
      "source": "sintax_subset",
      "target": "filtlong"
    },
    {
      "source": "append_asv_counts",
      "target": "usearch"
    },
    {
      "source": "append_asv_counts",
      "target": "gzip"
    },
    {
      "source": "append_asv_counts",
      "target": "cutadapt"
    },
    {
      "source": "append_asv_counts",
      "target": "filtlong"
    },
    {
      "source": "derep_subset",
      "target": "usearch"
    },
    {
      "source": "derep_subset",
      "target": "gzip"
    },
    {
      "source": "derep_subset",
      "target": "cutadapt"
    },
    {
      "source": "derep_subset",
      "target": "filtlong"
    },
    {
      "source": "unoise_subset",
      "target": "usearch"
    },
    {
      "source": "unoise_subset",
      "target": "gzip"
    },
    {
      "source": "unoise_subset",
      "target": "cutadapt"
    },
    {
      "source": "unoise_subset",
      "target": "filtlong"
    },
    {
      "source": "trim_primers",
      "target": "usearch"
    },
    {
      "source": "trim_primers",
      "target": "gzip"
    },
    {
      "source": "trim_primers",
      "target": "cutadapt"
    },
    {
      "source": "trim_primers",
      "target": "filtlong"
    },
    {
      "source": "concat_all_trimmed",
      "target": "usearch"
    },
    {
      "source": "concat_all_trimmed",
      "target": "gzip"
    },
    {
      "source": "concat_all_trimmed",
      "target": "cutadapt"
    },
    {
      "source": "concat_all_trimmed",
      "target": "filtlong"
    },
    {
      "source": "subsample_reads",
      "target": "usearch"
    },
    {
      "source": "subsample_reads",
      "target": "gzip"
    },
    {
      "source": "subsample_reads",
      "target": "cutadapt"
    },
    {
      "source": "subsample_reads",
      "target": "filtlong"
    },
    {
      "source": "quilt_prepare_regular",
      "target": "r"
    },
    {
      "source": "quilt_prepare_regular",
      "target": "r-quilt"
    },
    {
      "source": "quilt_prepare_regular",
      "target": "r-mspbwt"
    },
    {
      "source": "quilt_prepare_regular",
      "target": "r-stitch"
    },
    {
      "source": "quilt_run_regular",
      "target": "r"
    },
    {
      "source": "quilt_run_regular",
      "target": "r-quilt"
    },
    {
      "source": "quilt_run_regular",
      "target": "r-mspbwt"
    },
    {
      "source": "quilt_run_regular",
      "target": "r-stitch"
    },
    {
      "source": "quilt_ligate_regular",
      "target": "r"
    },
    {
      "source": "quilt_ligate_regular",
      "target": "r-quilt"
    },
    {
      "source": "quilt_ligate_regular",
      "target": "r-mspbwt"
    },
    {
      "source": "quilt_ligate_regular",
      "target": "r-stitch"
    },
    {
      "source": "quilt_prepare_mspbwt",
      "target": "r"
    },
    {
      "source": "quilt_prepare_mspbwt",
      "target": "r-quilt"
    },
    {
      "source": "quilt_prepare_mspbwt",
      "target": "r-mspbwt"
    },
    {
      "source": "quilt_prepare_mspbwt",
      "target": "r-stitch"
    },
    {
      "source": "quilt_run_mspbwt",
      "target": "r"
    },
    {
      "source": "quilt_run_mspbwt",
      "target": "r-quilt"
    },
    {
      "source": "quilt_run_mspbwt",
      "target": "r-mspbwt"
    },
    {
      "source": "quilt_run_mspbwt",
      "target": "r-stitch"
    },
    {
      "source": "quilt_ligate_mspbwt",
      "target": "r"
    },
    {
      "source": "quilt_ligate_mspbwt",
      "target": "r-quilt"
    },
    {
      "source": "quilt_ligate_mspbwt",
      "target": "r-mspbwt"
    },
    {
      "source": "quilt_ligate_mspbwt",
      "target": "r-stitch"
    },
    {
      "source": "subset_sample_list",
      "target": "r"
    },
    {
      "source": "subset_sample_list",
      "target": "r-quilt"
    },
    {
      "source": "subset_sample_list",
      "target": "r-mspbwt"
    },
    {
      "source": "subset_sample_list",
      "target": "r-stitch"
    },
    {
      "source": "subset_refpanel_by_chrom",
      "target": "pandas"
    },
    {
      "source": "subset_refpanel_by_chunkid",
      "target": "pandas"
    },
    {
      "source": "concat_refpanel_sites_by_chunks",
      "target": "pandas"
    },
    {
      "source": "collect_truth_gts",
      "target": "r"
    },
    {
      "source": "collect_truth_gts",
      "target": "r-quilt"
    },
    {
      "source": "collect_truth_gts",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_truth_gts",
      "target": "r-stitch"
    },
    {
      "source": "collect_quilt_regular_imputed_gts",
      "target": "r"
    },
    {
      "source": "collect_quilt_regular_imputed_gts",
      "target": "r-quilt"
    },
    {
      "source": "collect_quilt_regular_imputed_gts",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_quilt_regular_imputed_gts",
      "target": "r-stitch"
    },
    {
      "source": "collect_quilt_mspbwt_imputed_gts",
      "target": "r"
    },
    {
      "source": "collect_quilt_mspbwt_imputed_gts",
      "target": "r-quilt"
    },
    {
      "source": "collect_quilt_mspbwt_imputed_gts",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_quilt_mspbwt_imputed_gts",
      "target": "r-stitch"
    },
    {
      "source": "plot_quilt_regular",
      "target": "r"
    },
    {
      "source": "plot_quilt_regular",
      "target": "r-quilt"
    },
    {
      "source": "plot_quilt_regular",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_quilt_regular",
      "target": "r-stitch"
    },
    {
      "source": "plot_quilt_mspbwt",
      "target": "r"
    },
    {
      "source": "plot_quilt_mspbwt",
      "target": "r-quilt"
    },
    {
      "source": "plot_quilt_mspbwt",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_quilt_mspbwt",
      "target": "r-stitch"
    },
    {
      "source": "plot_quilt_accuracy",
      "target": "r"
    },
    {
      "source": "plot_quilt_accuracy",
      "target": "r-quilt"
    },
    {
      "source": "plot_quilt_accuracy",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_quilt_accuracy",
      "target": "r-stitch"
    },
    {
      "source": "collect_glimpse_imputed_gts",
      "target": "r"
    },
    {
      "source": "collect_glimpse_imputed_gts",
      "target": "r-quilt"
    },
    {
      "source": "collect_glimpse_imputed_gts",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_glimpse_imputed_gts",
      "target": "r-stitch"
    },
    {
      "source": "collect_glimpse2_imputed_gts",
      "target": "r"
    },
    {
      "source": "collect_glimpse2_imputed_gts",
      "target": "r-quilt"
    },
    {
      "source": "collect_glimpse2_imputed_gts",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_glimpse2_imputed_gts",
      "target": "r-stitch"
    },
    {
      "source": "plot_glimpse2_accuracy",
      "target": "r"
    },
    {
      "source": "plot_glimpse2_accuracy",
      "target": "r-quilt"
    },
    {
      "source": "plot_glimpse2_accuracy",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_glimpse2_accuracy",
      "target": "r-stitch"
    },
    {
      "source": "plot_glimpse_accuracy",
      "target": "r"
    },
    {
      "source": "plot_glimpse_accuracy",
      "target": "r-quilt"
    },
    {
      "source": "plot_glimpse_accuracy",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_glimpse_accuracy",
      "target": "r-stitch"
    },
    {
      "source": "plot_accuracy_panelsize",
      "target": "r"
    },
    {
      "source": "plot_accuracy_panelsize",
      "target": "r-quilt"
    },
    {
      "source": "plot_accuracy_panelsize",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_accuracy_panelsize",
      "target": "r-stitch"
    },
    {
      "source": "plot_accuracy_depth",
      "target": "r"
    },
    {
      "source": "plot_accuracy_depth",
      "target": "r-quilt"
    },
    {
      "source": "plot_accuracy_depth",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_accuracy_depth",
      "target": "r-stitch"
    },
    {
      "source": "plot_accuracy_v2",
      "target": "r"
    },
    {
      "source": "plot_accuracy_v2",
      "target": "r-quilt"
    },
    {
      "source": "plot_accuracy_v2",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_accuracy_v2",
      "target": "r-stitch"
    },
    {
      "source": "plot_accuracy_f1",
      "target": "r"
    },
    {
      "source": "plot_accuracy_f1",
      "target": "r-quilt"
    },
    {
      "source": "plot_accuracy_f1",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_accuracy_f1",
      "target": "r-stitch"
    },
    {
      "source": "downsample_bam",
      "target": "pandas"
    },
    {
      "source": "bamlist",
      "target": "pandas"
    },
    {
      "source": "glimpse2_prepare_panel",
      "target": "pandas"
    },
    {
      "source": "glimpse2_phase",
      "target": "pandas"
    },
    {
      "source": "glimpse2_ligate",
      "target": "pandas"
    },
    {
      "source": "glimpse_prepare_glvcf",
      "target": "pandas"
    },
    {
      "source": "glimpse_phase",
      "target": "pandas"
    },
    {
      "source": "glimpse_ligate",
      "target": "pandas"
    },
    {
      "source": "collect_quilt_regular_speed_log",
      "target": "r"
    },
    {
      "source": "collect_quilt_regular_speed_log",
      "target": "r-quilt"
    },
    {
      "source": "collect_quilt_regular_speed_log",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_quilt_regular_speed_log",
      "target": "r-stitch"
    },
    {
      "source": "collect_quilt_mspbwt_speed_log",
      "target": "r"
    },
    {
      "source": "collect_quilt_mspbwt_speed_log",
      "target": "r-quilt"
    },
    {
      "source": "collect_quilt_mspbwt_speed_log",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_quilt_mspbwt_speed_log",
      "target": "r-stitch"
    },
    {
      "source": "collect_glimpse2_speed_log",
      "target": "r"
    },
    {
      "source": "collect_glimpse2_speed_log",
      "target": "r-quilt"
    },
    {
      "source": "collect_glimpse2_speed_log",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_glimpse2_speed_log",
      "target": "r-stitch"
    },
    {
      "source": "collect_glimpse_speed_log",
      "target": "r"
    },
    {
      "source": "collect_glimpse_speed_log",
      "target": "r-quilt"
    },
    {
      "source": "collect_glimpse_speed_log",
      "target": "r-mspbwt"
    },
    {
      "source": "collect_glimpse_speed_log",
      "target": "r-stitch"
    },
    {
      "source": "plot_speed_quilt_regular",
      "target": "r"
    },
    {
      "source": "plot_speed_quilt_regular",
      "target": "r-quilt"
    },
    {
      "source": "plot_speed_quilt_regular",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_speed_quilt_regular",
      "target": "r-stitch"
    },
    {
      "source": "plot_speed_quilt_mspbwt",
      "target": "r"
    },
    {
      "source": "plot_speed_quilt_mspbwt",
      "target": "r-quilt"
    },
    {
      "source": "plot_speed_quilt_mspbwt",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_speed_quilt_mspbwt",
      "target": "r-stitch"
    },
    {
      "source": "plot_speed_glimpse2",
      "target": "r"
    },
    {
      "source": "plot_speed_glimpse2",
      "target": "r-quilt"
    },
    {
      "source": "plot_speed_glimpse2",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_speed_glimpse2",
      "target": "r-stitch"
    },
    {
      "source": "plot_speed_glimpse",
      "target": "r"
    },
    {
      "source": "plot_speed_glimpse",
      "target": "r-quilt"
    },
    {
      "source": "plot_speed_glimpse",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_speed_glimpse",
      "target": "r-stitch"
    },
    {
      "source": "plot_speed_by_panelsize",
      "target": "r"
    },
    {
      "source": "plot_speed_by_panelsize",
      "target": "r-quilt"
    },
    {
      "source": "plot_speed_by_panelsize",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_speed_by_panelsize",
      "target": "r-stitch"
    },
    {
      "source": "plot_speed_by_depth",
      "target": "r"
    },
    {
      "source": "plot_speed_by_depth",
      "target": "r-quilt"
    },
    {
      "source": "plot_speed_by_depth",
      "target": "r-mspbwt"
    },
    {
      "source": "plot_speed_by_depth",
      "target": "r-stitch"
    },
    {
      "source": "download_fastq",
      "target": "sra-tools"
    },
    {
      "source": "prokka_annotation",
      "target": "prokka"
    },
    {
      "source": "flye_assembly",
      "target": "flye"
    },
    {
      "source": "gffread",
      "target": "gffread"
    },
    {
      "source": "extract_sp",
      "target": "samtools"
    },
    {
      "source": "extract_sp",
      "target": "hisat2"
    },
    {
      "source": "extract_ex",
      "target": "samtools"
    },
    {
      "source": "extract_ex",
      "target": "hisat2"
    },
    {
      "source": "index",
      "target": "samtools"
    },
    {
      "source": "index",
      "target": "hisat2"
    },
    {
      "source": "trimm",
      "target": "trimmomatic"
    },
    {
      "source": "map",
      "target": "samtools"
    },
    {
      "source": "map",
      "target": "hisat2"
    },
    {
      "source": "sort",
      "target": "picard"
    },
    {
      "source": "addReadGroups",
      "target": "picard"
    },
    {
      "source": "deduplicate",
      "target": "picard"
    },
    {
      "source": "count",
      "target": "htseq"
    },
    {
      "source": "multiqc_dir",
      "target": "multiqc"
    },
    {
      "source": "taxonomy_sintax",
      "target": "vsearch"
    },
    {
      "source": "taxonomy_blast",
      "target": "blast"
    },
    {
      "source": "without_taxonomy",
      "target": "vsearch"
    },
    {
      "source": "convert_to_fasta",
      "target": "vsearch"
    },
    {
      "source": "vsearch_cluster",
      "target": "vsearch"
    },
    {
      "source": "concatenate_otus",
      "target": "samtools"
    },
    {
      "source": "concatenate_otus",
      "target": "minimap2"
    },
    {
      "source": "individual_outputs_blast",
      "target": "python"
    },
    {
      "source": "individual_outputs_blast",
      "target": "gzip"
    },
    {
      "source": "fix_tax_blast",
      "target": "python"
    },
    {
      "source": "fix_tax_blast",
      "target": "gzip"
    },
    {
      "source": "cluster_ID",
      "target": "vsearch"
    },
    {
      "source": "ampvis2_std_plots_sintax",
      "target": "r-base"
    },
    {
      "source": "ampvis2_std_plots_sintax",
      "target": "r-ampvis2"
    },
    {
      "source": "ampvis2_std_plots_blast",
      "target": "r-base"
    },
    {
      "source": "ampvis2_std_plots_blast",
      "target": "r-ampvis2"
    },
    {
      "source": "polish_racon",
      "target": "racon"
    },
    {
      "source": "prep_for_ampvis2_sintax",
      "target": "python"
    },
    {
      "source": "prep_for_ampvis2_sintax",
      "target": "gzip"
    },
    {
      "source": "ampvis2_modifications_sintax",
      "target": "python"
    },
    {
      "source": "ampvis2_modifications_sintax",
      "target": "gzip"
    },
    {
      "source": "phyloseq_abund_sintax",
      "target": "python"
    },
    {
      "source": "phyloseq_abund_sintax",
      "target": "gzip"
    },
    {
      "source": "phyloseq_sintax",
      "target": "python"
    },
    {
      "source": "phyloseq_sintax",
      "target": "gzip"
    },
    {
      "source": "fix_otu_table_sintax",
      "target": "python"
    },
    {
      "source": "fix_otu_table_sintax",
      "target": "gzip"
    },
    {
      "source": "prep_input_blast",
      "target": "python"
    },
    {
      "source": "prep_input_blast",
      "target": "gzip"
    },
    {
      "source": "relabel",
      "target": "vsearch"
    },
    {
      "source": "relabel_merge",
      "target": "vsearch"
    },
    {
      "source": "filter_fastq",
      "target": "chopper"
    },
    {
      "source": "merge_read_count",
      "target": "chopper"
    },
    {
      "source": "sambamba",
      "target": "bio/sambamba/sort\""
    },
    {
      "source": "gtf_to_bed",
      "target": "bedops"
    },
    {
      "source": "slamdunk_map",
      "target": "slamdunk"
    },
    {
      "source": "slamdunk_filter",
      "target": "slamdunk"
    },
    {
      "source": "slamdunk_snp",
      "target": "slamdunk"
    },
    {
      "source": "slamdunk_count",
      "target": "slamdunk"
    },
    {
      "source": "collapse",
      "target": "slamdunk"
    },
    {
      "source": "rates",
      "target": "slamdunk"
    },
    {
      "source": "tccontext",
      "target": "slamdunk"
    },
    {
      "source": "utrrates",
      "target": "slamdunk"
    },
    {
      "source": "snpeval",
      "target": "slamdunk"
    },
    {
      "source": "summary",
      "target": "slamdunk"
    },
    {
      "source": "tcperreadpos",
      "target": "slamdunk"
    },
    {
      "source": "tcperutrpos",
      "target": "slamdunk"
    },
    {
      "source": "dump",
      "target": "slamdunk"
    },
    {
      "source": "index_ref",
      "target": "bio/samtools/faidx\""
    },
    {
      "source": "compress_vcf",
      "target": "bio/bcftools/sort\""
    },
    {
      "source": "tabix",
      "target": "bio/bcftools/index\""
    },
    {
      "source": "sort_bed",
      "target": "bio/bedtools/sort\""
    },
    {
      "source": "index_dip_bam",
      "target": "bio/samtools/index\""
    },
    {
      "source": "sort_exclusion_beds",
      "target": "bio/bedtools/sort\""
    },
    {
      "source": "run_assembly_stats",
      "target": "bio/assembly-stats\""
    },
    {
      "source": "ncbi_download",
      "target": "bio/sra-tools/fasterq-dump\""
    },
    {
      "source": "fastp_mergedout",
      "target": "bio/fastp\""
    },
    {
      "source": "fastp_pairedout",
      "target": "bio/fastp\""
    },
    {
      "source": "mapDamage2_rescaling",
      "target": "bio/mapdamage2\""
    },
    {
      "source": "bwa_aln_merged",
      "target": "bio/bwa/aln\""
    },
    {
      "source": "bwa_samse_merged",
      "target": "bio/bwa/samse\""
    },
    {
      "source": "bwa_mem_paired",
      "target": "bio/bwa/mem\""
    },
    {
      "source": "bwa_mem_merged",
      "target": "bio/bwa/mem\""
    },
    {
      "source": "samtools_merge_collapsed_libs",
      "target": "bio/samtools/merge\""
    },
    {
      "source": "samtools_merge_paired_units",
      "target": "bio/samtools/merge\""
    },
    {
      "source": "dedup_merged",
      "target": "dedup"
    },
    {
      "source": "dedup_merged",
      "target": "samtools"
    },
    {
      "source": "samtools_merge_dedup",
      "target": "bio/samtools/merge\""
    },
    {
      "source": "realignertargetcreator",
      "target": "bio/gatk3/realignertargetcreator\""
    },
    {
      "source": "indelrealigner",
      "target": "bio/gatk3/indelrealigner\""
    },
    {
      "source": "picard_dict",
      "target": "bio/picard/createsequencedictionary\""
    },
    {
      "source": "gmap_build",
      "target": "gmap"
    },
    {
      "source": "gmap_build",
      "target": "bio/gmap/build\""
    },
    {
      "source": "gmap_map",
      "target": "bio/gmap/map\""
    },
    {
      "source": "gmap_map",
      "target": "gmap"
    }
  ]
};