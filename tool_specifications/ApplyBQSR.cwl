#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/gatk-4.2.3.0/gatk,--java-options, -Xmx4G -XX:ParallelGCThreads=1, ApplyBQSR] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.realn_bam)
     - $(inputs.index_realn_bam)
     - $(inputs.recal_table)
     - $(inputs.reference_genome_fasta)
     - $(inputs.reference_genome_dict)
     - $(inputs.reference_genome_fai)
     - $(inputs.reference_genome_amb)
     - $(inputs.reference_genome_ann)
     - $(inputs.reference_genome_bwt)
     - $(inputs.reference_genome_pac)
     - $(inputs.reference_genome_sa)          
     
  InlineJavascriptRequirement: {}
 
inputs:

  realn_bam:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '-I'
      position: 1
      
  recal_table:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--bqsr-recal-file'
      position: 2
      
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '-R'
      position: 3
      
    
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
  
  #  BAI file
  index_realn_bam:
    type: File
                    
arguments:
  - valueFrom: $(inputs.realn_bam.nameroot + '.recal.bam')
    prefix: '-O'
    position: 4

outputs:
  recal_bam:
    type: File
    outputBinding:
      glob: $(inputs.realn_bam.nameroot + '.recal.bam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: ApplyBQSR_stdout.txt
stderr: ApplyBQSR_stderr.txt