#!/usr/bin/ nextflow

/*
 * Container inclusion statements
 */
include { insilico_defined_microbiome } from './modules/insilicoseq_module.nf'

 /*
  * Parameters definition section
  */
params {
    input_genomes: Path
}

/*
 * Workflow section
 */
workflow {

    main:
    // Importing input genomes from csv file and joining them into a single array channel 
    genomes_ch = channel.fromPath(params.input_genomes)
                        .view { item -> "Before splitCsv: $item" }
                        .splitCsv(header:true)
                        .map { row -> file(row.file_path)}
                        .view { item -> "After splitCsv: $item" }
                        .collect()
                        .view { item -> "After collect: $item"}

    // Runninng InSilicoSeq
    insilico_defined_microbiome(genomes_ch)

    publish:
    output_defined_microbiome = insilico_defined_microbiome.out.metagenome
    output_defined_abundance = insilico_defined_microbiome.out.abundance
}

 /*
  * Output definition block
  */
output {
    output_defined_microbiome {
        path "${ insilico_defined_microbiome.name }"
    }
    output_defined_abundance{
        path "${ insilico_defined_microbiome.name }"
        mode 'copy'
    }
}