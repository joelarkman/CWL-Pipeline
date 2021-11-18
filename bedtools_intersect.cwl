#! usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/bedtools2/bin/bedtools, intersect, -header]
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.vcf)
     - $(inputs.bed_file)
  InlineJavascriptRequirement: {}
  ShellCommandRequirement: {}

inputs:
  vcf:
    type: File
    inputBinding:
      prefix: '-a'
      position: 1
      
  bed_file:
    type: File
    inputBinding:
      prefix: '-b'
      position: 2
      
  not_in_bed_regions:
    type: boolean
    default: false
    inputBinding:
      prefix: '-v'
      position: 3

  step_name:
    type: string
    default: 'intersected'

arguments:
  - valueFrom: '>'
    shellQuote: false
    position: 4
  - valueFrom: $(inputs.vcf.basename.split(".vcf")[0] + '.' + inputs.step_name + '.vcf.gz') 
    position: 5

outputs:
  filtered_vcf:
    type: File
    outputBinding: 
      glob: $(inputs.vcf.basename.split(".vcf")[0] + '.' + inputs.step_name + '.vcf.gz') 
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: bedtools_intersect_stdout.txt
stderr: bedtools_intersect_stderr.txt