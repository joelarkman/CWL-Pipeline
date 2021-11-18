#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [java, -Xmx4G, -XX:ParallelGCThreads=1, -jar, /opt/programs/abra-2.23/abra2-2.23.jar] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.sorted_bam)
     - $(inputs.indexed_bam)
     - $(inputs.illumina_bed_file)
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

  sorted_bam:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--in'
      position: 1
      
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '--ref'
      position: 3
      
  illumina_bed_file:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '--targets'
      position: 4
      
  mad:
    type: string
    default: '10000'
    inputBinding:
      prefix: '--mad'
      position: 5
      
  threads:
    type: string
    default: '2'
    inputBinding:
      prefix: '--threads'
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
  
  #  BAI file
  indexed_bam:
    type: File
                
arguments:
  - valueFrom: $(inputs.sorted_bam.nameroot + '.realn.bam')
    prefix: '--out'
    position: 2

outputs:
  realn_bam:
    type: File
    outputBinding:
      glob: $(inputs.sorted_bam.nameroot + '.realn.bam')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: abra2_stdout.txt
stderr: abra2_stderr.txt