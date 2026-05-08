/*
 * Defining InSilicoSeq process to generate mock microbial samples
 */

 process insilico_defined_microbiome {

    container 'community.wave.seqera.io/library/pip_insilicoseq:34fc9878efbe6a9b'

    input:
    path input_genomes
    
    output:
    path "output_*.fastq.gz", emit: metagenome
    path "*.txt", emit: abundance

    script:
    """
    for i in {1..5}
    do
    iss generate --genomes ${input_genomes} \
                 --model hiseq \
                 --abundance lognormal \
                 --n_reads 0.25M \
                 --output output_\$i \
                 --cpus 6 \
                 --sequence_type metagenomics \
                 --compress
   done
    """
 }