#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
baseCommand: [/opt/programs/ensembl-vep/vep]
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
     - $(inputs.LoFtool_scores)
     - $(inputs.MaxEntScan_fordownload)
     - $(inputs.dbNSFP_file)
     - $(inputs.dbNSFP_file_index)
     - $(inputs.dbNSFP_keys)
     
  InlineJavascriptRequirement: {}
  
inputs:

  vcf:
    type: File
    inputBinding:
      valueFrom: $(self.basename)
      prefix: '--input_file'
      position: 25
      
  vep_dir:
    type: Directory
    inputBinding: 
      # valueFrom: $(self.basename)
      prefix: '--dir'
      position: 7
      
  vep_dir_cache:
    type: Directory
    inputBinding: 
      prefix: '--dir_cache'
      position: 8
      
  vep_dir_plugins:
    type: Directory
    inputBinding: 
      prefix: '--dir_plugins'
      position: 18
  
  vep_version:
    type: int
    inputBinding: 
      prefix: '--db_version'
      position: 5
  
  reference_genome_fasta:
    type: File
    inputBinding: 
      valueFrom: $(self.basename)
      prefix: '--fasta'
      position: 4      
            
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
    
# LoFtool scores
  LoFtool_scores:
    type: File
    
# MaxEntScan
  MaxEntScan_fordownload:
    type: Directory
    inputBinding: 
      valueFrom: $(self.basename)
    
# dbNSFP
  dbNSFP_file:
    type: File
  dbNSFP_file_index:
    type: File
  dbNSFP_keys:
    type: File
    inputBinding:
      loadContents: true
                    
arguments:
  - valueFrom: '4'
    prefix: '--fork'
    position: 1
  - valueFrom: '--offline'
    position: 2
  - valueFrom: 'GRCh38'
    prefix: '--assembly'
    position: 3
  - valueFrom: $(inputs.vep_version)
    prefix: '--cache_version'
    position: 6
    
  - valueFrom: '--refseq'
    position: 9
  - valueFrom: '--everything'
    position: 10
  - valueFrom: '--dont_skip'
    position: 11
  - valueFrom: '--total_length'
    position: 12
  - valueFrom: '--flag_pick'
    position: 13
  - valueFrom: '--no_escape'
    position: 14
  - valueFrom: '--exclude_predicted'
    position: 15
  - valueFrom: '--vcf'
    position: 16
  - valueFrom: 'vcf'
    prefix: '--format'
    position: 17
    
  - valueFrom: 'SingleLetterAA'
    prefix: '--plugin'
    position: 19
  - valueFrom: 'Blosum62'
    prefix: '--plugin'
    position: 20
  - valueFrom: $('LoFtool,' + inputs.LoFtool_scores.basename)
    prefix: '--plugin'
    position: 21
  - valueFrom: 'SpliceRegion'
    prefix: '--plugin'
    position: 22
  - valueFrom: $('MaxEntScan,' + inputs.MaxEntScan_fordownload.basename)
    prefix: '--plugin'
    position: 23
  - valueFrom: $('dbNSFP,' + inputs.dbNSFP_file.basename + ',' + inputs.dbNSFP_keys.contents)
    prefix: '--plugin'
    position: 24

    
  - valueFrom: $(inputs.vcf.nameroot.split(".vcf")[0] + '.vep.vcf')
    prefix: '--output_file'
    position: 26

outputs:
  annotated_vcf:
    type: File
    outputBinding:
      glob: $(inputs.vcf.nameroot.split(".vcf")[0] + '.vep.vcf')
  log_file_stdout:
    type: stdout
  log_file_stderr:
    type: stderr

stdout: vep_stdout.txt
stderr: vep_stderr.txt