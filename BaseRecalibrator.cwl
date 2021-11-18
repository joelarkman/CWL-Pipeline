#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/gatk-4.2.3.0/gatk,--java-options, -Xmx4G -XX:ParallelGCThreads=1, BaseRecalibrator] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.realn_bam)
     - $(inputs.index_realn_bam)
     - $(inputs.known_sites_dbsnp)
     - $(inputs.known_sites_dbsnp_index)
     - $(inputs.known_sites_indels)
     - $(inputs.known_sites_indels_index)
     - $(inputs.known_sites_mills_1000G_indels)
     - $(inputs.known_sites_mills_1000G_indels_index)
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
      
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '-R'
      position: 3
      
  known_sites_dbsnp:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '--known-sites'
      position: 4
      
  known_sites_indels:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '--known-sites'
      position: 5
      
  known_sites_mills_1000G_indels:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '--known-sites'
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
  index_realn_bam:
    type: File
    
  #  known-sites indexes
  known_sites_dbsnp_index:
    type: File
  known_sites_indels_index: 
    type: File
  known_sites_mills_1000G_indels_index:
    type: File
                
arguments:
  - valueFrom: $(inputs.realn_bam.nameroot + '.recal_data.table')
    prefix: '-O'
    position: 2

outputs:
  recal_table:
    type: File
    outputBinding:
      glob: $(inputs.realn_bam.nameroot + '.recal_data.table')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: BaseRecalibrator_stdout.txt
stderr: BaseRecalibrator_stderr.txt