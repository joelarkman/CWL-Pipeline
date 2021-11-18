#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/gatk-4.2.3.0/gatk,--java-options, -Xmx4G -XX:ParallelGCThreads=1, HaplotypeCaller] 
requirements:
  InitialWorkDirRequirement:
    listing:
     - $(inputs.recal_bam)
     - $(inputs.index_recal_bam)
     - $(inputs.target_regions)
     - $(inputs.known_sites_dbsnp)
     - $(inputs.known_sites_dbsnp_index)
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

  recal_bam:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '-I'
      position: 1
      
  target_regions:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--intervals'
      position: 2
      
  known_sites_dbsnp:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--dbsnp'
      position: 3
      
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '-R'
      position: 4
      
  base-quality-score-threshold:
    type: string
    default: '15'
    inputBinding: 
      prefix: '--base-quality-score-threshold'
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
  
  #  BAI file
  index_recal_bam:
    type: File
    
  #  known-sites index
  known_sites_dbsnp_index:
    type: File
                    
arguments:
  - valueFrom: $(inputs.recal_bam.nameroot + '.gatk-hc.vcf.gz')
    prefix: '-O'
    position: 6

outputs:
  vcf:
    type: File
    outputBinding:
      glob: $(inputs.recal_bam.nameroot + '.gatk-hc.vcf.gz')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: HaplotypeCaller_stdout.txt
stderr: HaplotypeCaller_stderr.txt