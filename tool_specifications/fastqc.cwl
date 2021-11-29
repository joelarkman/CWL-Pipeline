#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/FastQC/fastqc] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.fastq_forward)
     - $(inputs.fastq_reverse)
  InlineJavascriptRequirement: {}
  
inputs:
  fastq_forward:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 1
  fastq_reverse:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      position: 2
      
outputs:
  forward_html_file:
    type: File
    outputBinding:
      glob: $(inputs.fastq_forward.nameroot.split(".fastq")[0] + '_fastqc' + '.html')
  forward_zip_file:
    type: File
    outputBinding:
      glob: $(inputs.fastq_forward.nameroot.split(".fastq")[0] + '_fastqc' + '.zip')
  reverse_html_file:
    type: File
    outputBinding:
      glob: $(inputs.fastq_reverse.nameroot.split(".fastq")[0] + '_fastqc' + '.html')
  reverse_zip_file:
    type: File
    outputBinding:
      glob: $(inputs.fastq_reverse.nameroot.split(".fastq")[0] + '_fastqc' + '.zip')
      
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr
    
stdout: fastqc_stdout.txt
stderr: fastqc_stderr.txts