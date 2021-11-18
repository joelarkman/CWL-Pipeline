#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/bwa/bwa, mem] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.forward_filtered_fastq)
     - $(inputs.reverse_filtered_fastq)
     - $(inputs.reference_genome_fasta)
     - $(inputs.reference_genome_dict)
     - $(inputs.reference_genome_fai)
     - $(inputs.reference_genome_amb)
     - $(inputs.reference_genome_ann)
     - $(inputs.reference_genome_bwt)
     - $(inputs.reference_genome_pac)
     - $(inputs.reference_genome_sa)          
     
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}
 
inputs:
  bwa_threads:
    type: string
    default: '2'
    inputBinding:
      prefix: '-t'
      position: 1
      
  bwa_min_seed_length:
    type: string
    default: '18'
    inputBinding:
      prefix: '-k'
      position: 2

  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      position: 4
      
  forward_filtered_fastq:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      position: 5
  reverse_filtered_fastq:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      position: 6
      
  # Reference genome index files - not included in call to tool
  reference_genome_dict:
    type: File
  reference_genome_fai:
    type: File
  reference_genome_amb:
    type: File
  reference_genome_ann:
    type: File
  reference_genome_bwt:
    type: File
  reference_genome_pac: 
    type: File
  reference_genome_sa:
    type: File
    
arguments:
  - valueFrom: $('@RG\\tID:' + inputs.forward_filtered_fastq.basename.split("-")[0] + '\\tCN:WMRGL\\tPL:ILLUMINA\\tLB:' + inputs.forward_filtered_fastq.basename.split("-")[0] + '\\tSM:' + inputs.forward_filtered_fastq.basename.split("_L001_")[0])
    prefix: '-R'
    position: 3
  - valueFrom: '|'
    shellQuote: false
    position: 7
  - valueFrom: /opt/programs/samtools-1.14/samtools
    position: 8
  - valueFrom: sort
    position: 9
  - valueFrom: '2'
    prefix: '-@'
    position: 10
  - valueFrom: $(inputs.forward_filtered_fastq.nameroot.split(".fastq")[0] + '.bam')
    prefix: '-o'
    position: 11
  - valueFrom: '-'
    shellQuote: false
    position: 12
  
outputs:
  sorted_bam:
    type: File
    outputBinding:
      glob: $(inputs.forward_filtered_fastq.nameroot.split(".fastq")[0] + '.bam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: bwa_stdout.txt
stderr: bwa_stderr.txt