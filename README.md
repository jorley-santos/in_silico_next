# InSilicoNext

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![Singularity](https://img.shields.io/badge/singularity-white.svg?logo=singularity)](https://sylabs.io/guides/3.0/user-guide/)
[![Docker](https://img.shields.io/badge/docker-blue.svg?logo=docker)](https://www.docker.com/)

## Description
InSilicoNext is a Nextflow-based pipeline designed to generate synthetic (mock) metagenomic datasets using **InSilicoSeq (ISS)**. It automates the distribution of genomes, abundance profiling, and read simulation across a distributed computing environment.

The pipeline utilizes Nextflow's DSL2 syntax to provide a scalable, reproducible, and containerized workflow for bioinformaticians needing high-quality ground-truth datasets for tool benchmarking.

---

## Prerequisites
*   **Nextflow** (`>=26.04.0`)
*   **Java 11** or later
*   **Container Engine:** Docker, Singularity, or Conda.

---

## Samplesheet Input File
InSilicoNext takes as input a .csv samplesheet file. It must contain the IDs and the absolute paths of the genomes you previously downloaded to use as a reference for the creation of the simulated microbiome samples. See a template file in the data/ folder in this repo. 

### samplesheet.csv
| ID | Absolute Path |
| :--- | :--- | :--- |
| `GCF_016724805_1_genomic.fna` | /home/user/data/genomes/GCF_016724805_1_genomic.fna |
| `GCF_009731575_1_genomic.fna` | /home/user/data/genomes/GCF_009731575_1_genomic.fna |
| `GCF_055385135_1_genomic.fna` | /home/userdata/genomes/GCF_055385135_1_genomic.fna  |
---
## Quick Start

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/](https://github.com/)[username]/[repo-name].git
    cd [repo-name]
    ```

2.  **Run with test data:**
    ```bash
    nextflow run main.nf -profile test
    ```

3.  **Run with your own data:**
    ```bash
    nextflow run main.nf \\
      --input_genomes samplesheet.csv \\
      --sequencer_model hiseq \\
      --number_of_samples 15 \\
      --number_of_reads 1 \\
      --cpus 4
      -profile singularity
    ```

---

## Parameters

### Input
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `--input_genomes` | Path to reference .csv samplesheet file (e.x data/samplesheet.csv). | `null` |

### ISS Specifics
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `--sequencer_model` | ISS sequencing model (e.g., `hiseq`, `miseq`, `novaseq`). | `hiseq` |
| `--number_of_reads` | How many millions of reads to simulate. | `1M` |
| `--cpus` | Number of cpus to allocate to the pipeline. | `Default: 2` |

---

## Pipeline Components

### `InSilicoSeq` Process
The core simulation is handled by the `ISS_GENERATE` process. It uses Nextflow’s container directives to ensure the environment is consistent.
```nextflow
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
```
---
## Citations
If you use this pipeline, please cite:

Nextflow: Di Tommaso, P., et al. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology.

InSilicoSeq: Gourlé, H., et al. (2019). Simulating Illumina metagenomic data with InSilicoSeq. Bioinformatics.

## Pipeline Components
This project is licensed under the MIT License.

