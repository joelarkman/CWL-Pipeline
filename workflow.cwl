#! /usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}
  StepInputExpressionRequirement: {}

# Run using --relax-path-checks flag

##########################
##########INPUTS##########
##########################

inputs:
  fastq_forward: File
  fastq_reverse: File
  adapter_fasta: File?
  
# Genome reference
  reference_genome_fasta: File
  reference_genome_dict: File
  reference_genome_fai: File 
  reference_genome_amb: File 
  reference_genome_ann: File 
  reference_genome_bwt: File 
  reference_genome_pac: File 
  reference_genome_sa: File
  
  blacklisted_regions: File
  
# Panel BED targets
  target_regions: File
  illumina_bed_file: File
  
# BaseRecalibrator known-sites
  known_sites_dbsnp: File
  known_sites_dbsnp_index: File
  known_sites_indels: File
  known_sites_indels_index: File
  known_sites_mills_1000G_indels: File
  known_sites_mills_1000G_indels_index: File
  
# VEP
  vep_version: int
  vep_dir: Directory
  vep_dir_cache: Directory
  vep_dir_plugins: Directory
  LoFtool_scores: File
  MaxEntScan_fordownload: Directory
  dbNSFP_file: File
  dbNSFP_file_index: File
  dbNSFP_keys: File

#########################
##########STEPS##########
#########################

steps:

# Pipeline
  fastqc_report:
    run: tool_specifications/fastqc.cwl
    in:
      fastq_forward:
        source: fastq_forward
      fastq_reverse:
        source: fastq_reverse
    out: [forward_html_file, forward_zip_file, reverse_html_file, reverse_zip_file, log_file_stdout, log_file_stderr]
    
  fastp:
    run: tool_specifications/fastp.cwl
    in:
      fastq_forward:
        source: fastq_forward
      fastq_reverse:
        source: fastq_reverse
      adapter_fasta:
        source: adapter_fasta
    out: [forward_unpaired_fastq, forward_filtered_fastq, reverse_unpaired_fastq, reverse_filtered_fastq, fastp_html_report, log_file_stdout, log_file_stderr]
    
  fastqc_report2:
    run: tool_specifications/fastqc.cwl
    in:
      fastq_forward:
        source: fastp/forward_filtered_fastq
      fastq_reverse:
        source: fastp/reverse_filtered_fastq
    out: [forward_html_file, forward_zip_file, reverse_html_file, reverse_zip_file, log_file_stdout, log_file_stderr]
    
  align:
    run: tool_specifications/bwa.cwl
    in:
      forward_filtered_fastq:
        source: fastp/forward_filtered_fastq
      reverse_filtered_fastq:
        source: fastp/reverse_filtered_fastq
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
    out: [sorted_bam, log_file_stdout, log_file_stderr]
    
  index:
    run: tool_specifications/samtools_index.cwl
    in:
      sorted_bam:
        source: align/sorted_bam
    out: [indexed_bam, log_file_stdout, log_file_stderr]
    
  realn:
    run: tool_specifications/abra2.cwl
    in:
      sorted_bam:
        source: align/sorted_bam
      indexed_bam:
        source: index/indexed_bam
      illumina_bed_file:
        source: illumina_bed_file
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
    out: [realn_bam, log_file_stdout, log_file_stderr]
    
  realn_index:
    run: tool_specifications/samtools_index.cwl
    in:
      sorted_bam:
        source: realn/realn_bam
    out: [indexed_bam, log_file_stdout, log_file_stderr]
    
  base_recalibrator:
    run: tool_specifications/BaseRecalibrator.cwl
    in:
      realn_bam:
        source: realn/realn_bam
      index_realn_bam:
        source: realn_index/indexed_bam
      known_sites_dbsnp:
        source: known_sites_dbsnp
      known_sites_dbsnp_index:
        source: known_sites_dbsnp_index
      known_sites_indels:
        source: known_sites_indels
      known_sites_indels_index:
        source: known_sites_indels_index
      known_sites_mills_1000G_indels:
        source: known_sites_mills_1000G_indels
      known_sites_mills_1000G_indels_index:
        source: known_sites_mills_1000G_indels_index
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
    out: [recal_table, log_file_stdout, log_file_stderr]
    
  apply_bqsr:
    run: tool_specifications/ApplyBQSR.cwl
    in:
      realn_bam:
        source: realn/realn_bam
      index_realn_bam:
        source: realn_index/indexed_bam
      recal_table:
        source: base_recalibrator/recal_table
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
    out: [recal_bam, log_file_stdout, log_file_stderr]
     
  recal_index:
    run: tool_specifications/samtools_index.cwl
    in:
      sorted_bam:
        source: apply_bqsr/recal_bam
    out: [indexed_bam, log_file_stdout, log_file_stderr]
    
  haplotype_caller:
    run: tool_specifications/HaplotypeCaller.cwl
    in:
      recal_bam:
        source: apply_bqsr/recal_bam
      index_recal_bam:
        source: recal_index/indexed_bam
      target_regions:
        source: target_regions
      known_sites_dbsnp:
        source: known_sites_dbsnp
      known_sites_dbsnp_index:
        source: known_sites_dbsnp_index
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
    out: [vcf, log_file_stdout, log_file_stderr]
  
  bcft_sort:
    run: tool_specifications/bcft_sort.cwl
    in:
      vcf:
        source: haplotype_caller/vcf
    out: [sorted_vcf, log_file_stdout, log_file_stderr]
  
 # cnnscore, filtervarianttranches

  filter_roi:
    run: tool_specifications/bedtools_intersect.cwl
    in:
      vcf:
        source: bcft_sort/sorted_vcf
      bed_file:
        source: target_regions
      step_name:
        valueFrom: 'filter_roi'
    out: [filtered_vcf, log_file_stdout, log_file_stderr]
    
  filter_blacklist:
    run: tool_specifications/bedtools_intersect.cwl
    in:
      vcf:
        source: filter_roi/filtered_vcf
      bed_file:
        source: blacklisted_regions
      not_in_bed_regions:
        default: true
      step_name:
        valueFrom: 'blacklist_removed'
    out: [filtered_vcf, log_file_stdout, log_file_stderr]

  vt:
    run: tool_specifications/vt.cwl
    in:
      vcf:
        source: filter_blacklist/filtered_vcf
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa
    out: [normalised_vcf, log_file_stdout, log_file_stderr]
 
  vep:
    run: tool_specifications/vep.cwl
    in:
      vcf:
        source: vt/normalised_vcf   
      reference_genome_fasta:
        source: reference_genome_fasta
      reference_genome_dict:
        source: reference_genome_dict
      reference_genome_fai:
        source: reference_genome_fai
      reference_genome_amb:
        source: reference_genome_amb
      reference_genome_ann:
        source: reference_genome_ann
      reference_genome_bwt:
        source: reference_genome_bwt
      reference_genome_pac:
        source: reference_genome_pac
      reference_genome_sa:
        source: reference_genome_sa    
      vep_version:
        source: vep_version
      vep_dir:
        source: vep_dir
      vep_dir_cache: 
        source: vep_dir_cache
      vep_dir_plugins:
        source: vep_dir_plugins
      LoFtool_scores:
        source: LoFtool_scores
      MaxEntScan_fordownload:
        source: MaxEntScan_fordownload
      dbNSFP_file:
        source: dbNSFP_file
      dbNSFP_file_index:
        source: dbNSFP_file_index
      dbNSFP_keys:
        source: dbNSFP_keys
    out: [annotated_vcf, log_file_stdout, log_file_stderr]
    
# Clean_up  
  clean_up_qc_reports:
    run: tool_specifications/clean_up.cwl
    in:
      newname:
        valueFrom: 'qc_reports'
      file_array:
        source:
          - fastqc_report/forward_html_file
          - fastqc_report/forward_zip_file
          - fastqc_report/reverse_html_file
          - fastqc_report/reverse_zip_file
          - fastp/fastp_html_report
          - fastqc_report2/forward_html_file
          - fastqc_report2/forward_zip_file
          - fastqc_report2/reverse_html_file
          - fastqc_report2/reverse_zip_file
    out: [pool_directory] 
    
  clean_up_intermediate_files:
    run: tool_specifications/clean_up.cwl
    in:
      newname:
        valueFrom: 'intermediate_files'
      file_array:
        source:
#         FastP
          - fastp/forward_unpaired_fastq
          - fastp/forward_filtered_fastq
          - fastp/reverse_unpaired_fastq
          - fastp/reverse_filtered_fastq
#           BWA
          - align/sorted_bam
#           Index
          - index/indexed_bam
#           Abra2 (realignment)
          - realn/realn_bam
#           Realn Index
          - realn_index/indexed_bam
#           BaseRecalibrator
          - base_recalibrator/recal_table
#           HaplotypeCaller
          - haplotype_caller/vcf
#           BCFT Sort
          - bcft_sort/sorted_vcf
#           Filter roi - Bedtools intersect
          - filter_roi/filtered_vcf
#           Filter blacklist - Bedtools intersect
          - filter_blacklist/filtered_vcf
#           VT Normalisation
          - vt/normalised_vcf
    out: [pool_directory]   
    
  clean_up_logs:
    run: tool_specifications/clean_up.cwl
    in:
      newname:
        valueFrom: 'logs'
      file_array:
        source:
          - fastqc_report/log_file_stdout
          - fastqc_report/log_file_stderr
          - fastp/log_file_stdout
          - fastp/log_file_stderr
          - fastqc_report2/log_file_stdout
          - fastqc_report2/log_file_stderr
          - align/log_file_stdout
          - align/log_file_stderr
          - index/log_file_stdout
          - index/log_file_stderr
          - realn/log_file_stdout
          - realn/log_file_stderr
          - realn_index/log_file_stdout
          - realn_index/log_file_stderr
          - base_recalibrator/log_file_stdout
          - base_recalibrator/log_file_stderr
          - apply_bqsr/log_file_stdout
          - apply_bqsr/log_file_stderr
          - recal_index/log_file_stdout
          - recal_index/log_file_stderr
          - haplotype_caller/log_file_stdout
          - haplotype_caller/log_file_stderr
          - bcft_sort/log_file_stdout
          - bcft_sort/log_file_stderr
          - filter_roi/log_file_stdout
          - filter_roi/log_file_stderr
          - filter_blacklist/log_file_stdout
          - filter_blacklist/log_file_stderr
          - vt/log_file_stdout
          - vt/log_file_stderr
          - vep/log_file_stdout
          - vep/log_file_stderr 
    out: [pool_directory] 
  

###########################
##########OUTPUTS##########
###########################

outputs:

# FASTQC
  qc_reports:
    type: Directory
    outputSource: clean_up_qc_reports/pool_directory
    
# LOGS
  logs:
    type: Directory
    outputSource: clean_up_logs/pool_directory
    
# Intermediate files
  intermediate_files:
    type: Directory
    outputSource: clean_up_intermediate_files/pool_directory
    
# Realigned and BQSR BAM
  GATK_recal_bam:
    type: File
    outputSource: apply_bqsr/recal_bam
    
# Samtools - Index of recal bam
  samtools_index_recal_bam:
    type: File
    outputSource: recal_index/indexed_bam
    
# VCF
  vep_annotated_vcf:
    type: File
    outputSource: vep/annotated_vcf