#!/usr/bin/ nextflow

/*
 * InSilicoSeq container inclusion statement
 */

include { insilico_defined_microbiome } from './modules/insilicoseq_module.nf'

 /*
  * Parameters definition section
  */
params {
    input_genomes: Path
    number_of_samples:String
    millions_of_reads: String
    cpus: String
    sequencer_model: String
    batch: String
}

/*
 * Workflow section
 */
workflow {
    main:
    // Importing input genomes from csv file and joining them into a single array channel 
    genomes_ch = channel.fromPath(params.input_genomes)                 //Importing file path from a csv samplesheet
                        .view { item -> "Before splitCsv: $item" }      
                        .splitCsv(header:true)                          //Importing individual files from csv samplesheet
                        .map { row -> file(row.file_path)}              //Selecting files from the seconde column
                        .view { item -> "After splitCsv: $item" }
                        .collect()                                      //Collcecting all the files into a single iterable element
                        .view { item -> "After collect: $item"}
    // Runninng InSilicoSeq
    insilico_defined_microbiome(genomes_ch,
                                params.number_of_samples,
                                params.sequencer_model,
                                params.millions_of_reads,
                                params.cpus)
    publish:
    output_defined_microbiome = insilico_defined_microbiome.out.metagenome
    output_defined_abundance = insilico_defined_microbiome.out.abundance
}

 /*
  * Output definition block
  */
output {
    output_defined_microbiome {
        path "${ insilico_defined_microbiome.name }/${ params.batch }/fastq_samples"
        mode 'copy'
    }
    output_defined_abundance{
        path "${ insilico_defined_microbiome.name }/${ params.batch }/abundance_files"
        mode 'copy'
    }
}