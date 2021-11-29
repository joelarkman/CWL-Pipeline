#! usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/samtools-1.14/samtools, index]
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.sorted_bam)
  InlineJavascriptRequirement: {}

inputs:
  sorted_bam:
    type: File
    inputBinding:
      position: 1

outputs:
  indexed_bam:
    type: File
    outputBinding: 
      glob: $(inputs.sorted_bam.basename + '.bai') 
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: sam_index_stdout.txt
stderr: sam_index_stderr.txt