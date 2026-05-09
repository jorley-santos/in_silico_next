/*
 * Defining InSilicoSeq process to generate mock microbial samples
 */

 process insilico_defined_microbiome {

    container 'community.wave.seqera.io/library/pip_insilicoseq:34fc9878efbe6a9b'

    input:
    path input_genomes
    val input_number_of_samples
    val input_sequencer_model 
    val input_number_of_reads
    val input_numbers_of_cpu


    output:
    path "output_*.fastq.gz", emit: metagenome
    path "*.txt", emit: abundance

    script:
    loop_range = "${input_number_of_samples}"           // Determining the number of files created
                                                        // by controlling the range of the for loop running InSilicoSeq
    """
    for i in {1..$loop_range}  
    do
      iss generate --genomes ${input_genomes} \
                   --model '${input_sequencer_model}' \
                   --abundance lognormal \
                   --n_reads '${input_number_of_reads}'M \
                   --output output_\$i \
                   --cpus '${input_numbers_of_cpu}' \
                   --sequence_type metagenomics \
                   --compress
    done
    """
 }