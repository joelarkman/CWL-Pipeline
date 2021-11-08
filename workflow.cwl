#! /usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs:
  fastq_forward: File
  fastq_reverse: File
  
outputs:

# FASTQC
  fastqc_forward_html_report:
    type: File
    outputSource: fastqc_report/forward_html_file
  fastqc_reverse_html_report:
    type: File
    outputSource: fastqc_report/reverse_html_file
  fastqc_forward_zip_file:
    type: File
    outputSource: fastqc_report/forward_zip_file
  fastqc_reverse_zip_file:
    type: File
    outputSource: fastqc_report/reverse_zip_file
  fastqc_std_out:
    type: File
    outputSource: fastqc_report/log_file_stdout
  fastqc_std_err:
    type: File
    outputSource: fastqc_report/log_file_stderr
    
# FastP
  fastp_forward_unpaired_fastq:
    type: File
    outputSource: fastp/forward_unpaired_fastq
  fastp_forward_filtered_fastq:
    type: File
    outputSource: fastp/forward_filtered_fastq
  fastp_reverse_unpaired_fastq:
    type: File
    outputSource: fastp/reverse_unpaired_fastq
  fastp_reverse_filtered_fastq:
    type: File
    outputSource: fastp/reverse_filtered_fastq
  fastp_std_out:
    type: File
    outputSource: fastp/log_file_stdout
  fastp_std_err:
    type: File
    outputSource: fastp/log_file_stderr
    
# Second fastqc pass
  fastqc_forward_html_report2:
    type: File
    outputSource: fastqc_report2/forward_html_file
  fastqc_reverse_html_report2:
    type: File
    outputSource: fastqc_report2/reverse_html_file
  fastqc_forward_zip_file2:
    type: File
    outputSource: fastqc_report2/forward_zip_file
  fastqc_reverse_zip_file2:
    type: File
    outputSource: fastqc_report2/reverse_zip_file
  fastqc_std_out2:
    type: File
    outputSource: fastqc_report2/log_file_stdout
  fastqc_std_err2:
    type: File
    outputSource: fastqc_report2/log_file_stderr
    
steps:
  fastqc_report:
    run: fastqc.cwl
    in:
      fastq_forward:
        source: fastq_forward
      fastq_reverse:
        source: fastq_reverse
    out: [forward_html_file, forward_zip_file, reverse_html_file, reverse_zip_file, log_file_stdout, log_file_stderr]
    
  fastp:
    run: fastp.cwl
    in:
      fastq_forward:
        source: fastq_forward
      fastq_reverse:
        source: fastq_reverse
    out: [forward_unpaired_fastq, forward_filtered_fastq, reverse_unpaired_fastq, reverse_filtered_fastq, fastp_html_report, log_file_stdout, log_file_stderr]
    
  fastqc_report2:
    run: fastqc.cwl
    in:
      fastq_forward:
        source: fastp/forward_filtered_fastq
      fastq_reverse:
        source: fastp/reverse_filtered_fastq
    out: [forward_html_file, forward_zip_file, reverse_html_file, reverse_zip_file, log_file_stdout, log_file_stderr]
  