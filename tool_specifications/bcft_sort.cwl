#! usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/bcftools-1.14/bcftools, sort]
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.vcf)
  InlineJavascriptRequirement: {}

inputs:
  vcf:
    type: File
    inputBinding:
      position: 1

arguments:
  - valueFrom: $(inputs.vcf.basename.split(".vcf")[0] + '.sorted.vcf.gz') 
    prefix: '-o'
    position: 2

outputs:
  sorted_vcf:
    type: File
    outputBinding: 
      glob: $(inputs.vcf.basename.split(".vcf")[0] + '.sorted.vcf.gz') 
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: bcft_sort_stdout.txt
stderr: bcft_sort_stderr.txt