#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/vt/vt, decompose] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.vcf)
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

  vcf:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '-s'
      position: 1
      
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '-r'
      position: 5
      
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
  - valueFrom: '|'
    shellQuote: false
    position: 2
  - valueFrom: '/opt/programs/vt/vt'
    position: 3
  - valueFrom: 'normalize'
    position: 4
  - valueFrom: '-'
    position: 6
  - valueFrom: $(inputs.vcf.nameroot.split(".vcf")[0] + '.vt.vcf.gz')
    prefix: '-o'
    position: 7

outputs:
  normalised_vcf:
    type: File
    outputBinding:
      glob: $(inputs.vcf.nameroot.split(".vcf")[0] + '.vt.vcf.gz')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: vt_stdout.txt
stderr: vt_stderr.txt