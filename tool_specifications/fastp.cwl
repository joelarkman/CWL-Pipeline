#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/fastp/fastp] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.fastq_forward)
     - $(inputs.fastq_reverse)
     - $(inputs.adapter_fasta)
  InlineJavascriptRequirement: {}
  
inputs:
  fastq_forward:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--in1'
      position: 1
  fastq_reverse:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--in2'
      position: 2
  max_len:
    type: string
    default: '150'
    inputBinding:
      prefix: '--max_len1'
      position: 7
  min_len:
    type: string
    default: '50'
    inputBinding:
      prefix: '--length_required'
      position: 8
  sliding_window:
    type: boolean
    default: true
    inputBinding:
      prefix: '--cut_right'
      position: 9
  dedup:
    type: boolean
    default: true
    inputBinding:
      prefix: '--dedup'
      position: 10
  adapter_fasta:
    type: File?
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--adapter_fasta'
      position: 11
      
arguments:
  - valueFrom: $(inputs.fastq_forward.nameroot.split('.fastq')[0]+'.fastp_filtered.fastq.gz')
    prefix: '--out1'
    position: 3
  - valueFrom: $(inputs.fastq_forward.nameroot.split('.fastq')[0]+'.unpaired.fastq.gz')
    prefix: '--unpaired1'
    position: 4
  - valueFrom: $(inputs.fastq_reverse.nameroot.split('.fastq')[0]+'.fastp_filtered.fastq.gz')
    prefix: '--out2'
    position: 5
  - valueFrom: $(inputs.fastq_reverse.nameroot.split('.fastq')[0]+'.unpaired.fastq.gz')
    prefix: '--unpaired2'
    position: 6
  - valueFrom: 'fastp.html'
    prefix: '--html'
    position: 12
      
outputs:
  forward_unpaired_fastq: 
    type: File
    outputBinding: 
      glob: $(inputs.fastq_forward.nameroot.split('.fastq')[0] + '.unpaired.fastq.gz')
  forward_filtered_fastq:
    type: File
    outputBinding: 
      glob: $(inputs.fastq_forward.nameroot.split('.fastq')[0] + '.fastp_filtered.fastq.gz')
  reverse_unpaired_fastq: 
    type: File
    outputBinding:
      glob: $(inputs.fastq_reverse.nameroot.split('.fastq')[0] + '.unpaired.fastq.gz')
  reverse_filtered_fastq:
    type: File
    outputBinding: 
      glob: $(inputs.fastq_reverse.nameroot.split('.fastq')[0] + '.fastp_filtered.fastq.gz')
  fastp_html_report:
    type: File
    outputBinding: 
      glob: 'fastp.html'
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr
    
stdout: fastp_stdout.txt
stderr: fastp_stderr.txts