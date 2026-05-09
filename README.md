# InSilicoSeq - Nextflow Implementation

## Configuration
This pipeline is configured via `nextflow.config`. You can adjust resource allocation (CPU, RAM) and container settings in the `profiles` block:

*   `-profile docker`: Uses Docker containers.
*   `-profile singularity`: Uses Singularity/Apptainer images (ideal for HPC).
*   `-profile local`: Runs processes on the local machine.

---

## Citations
If you use this pipeline, please cite:
1.  **Nextflow:** Di Tommaso, P., et al. (2017). Nextflow enables reproducible computational workflows. *Nature Biotechnology*.
2.  **InSilicoSeq:** Gourlé, H., et al. (2019). Simulating Illumina metagenomic data with InSilicoSeq. *Bioinformatics*.

---

## License
This project is licensedA high-quality README is the face of your bioinformatics project. Since Nextflow pipelines often involve complex dependencies and parameters, clarity is key.

Below is a professional, well-documented template tailored for a pipeline using **InSilicoSeq (ISS)**.

---

# [Pipeline Name]

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A522.10.1-23aa62.svg)](https://www.nextflow.io/)
[![Singularity](https://img.shields.io/badge/singularity-white.svg?logo=singularity)](https://sylabs.io/guides/3.0/user-guide/)
[![Docker](https://img.shields.io/badge/docker-blue.svg?logo=docker)](https://www.docker.com/)

## Description
**[Project Name]** is a Nextflow-based pipeline designed to generate synthetic (mock) metagenomic datasets using **InSilicoSeq (ISS)**. It automates the distribution of genomes, abundance profiling, and read simulation across a distributed computing environment.

The pipeline utilizes Nextflow's DSL2 syntax to provide a scalable, reproducible, and containerized workflow for bioinformaticians needing high-quality ground-truth datasets for tool benchmarking.

---

## Workflow Overview
1.  **Input Validation:** Checks genome files and abundance parameters.
2.  **Genome Selection:** Subsets or prepares reference sequences.
3.  **Abundance Modeling:** Generates abundance profiles (e.g., log-normal, linear).
4.  **Simulation (ISS):** Executes `iss generate` to produce paired-end FASTQ files.
5.  **Quality Control:** Basic summary of the generated reads.

---

## Prerequisites
*   **Nextflow** (`>=22.10.1`)
*   **Java 11** or later
*   **Container Engine:** Docker, Singularity, or Conda.

---

## Quick Start

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/](https://github.com/)[username]/[repo-name].git
    cd [repo-name]
    ```

2.  **Run with test data:**
    ```bash
    nextflow run main.nf -profile test,docker
    ```

3.  **Run with your own data:**
    ```bash
    nextflow run main.nf \
      --genomes 'path/to/genomes/*.fasta' \
      --model 'hisec' \
      --n_reads 1000000 \
      -profile singularity
    ```

---

## Parameters

### Input/Output
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `--genomes` | Path to reference FASTA files. | `null` |
| `--outdir` | Directory to save the simulated reads. | `./results` |

### ISS Specifics
| Parameter | Description | Default |
| :--- | :--- | :--- |
| `--model` | ISS sequencing model (e.g., `hisec`, `miseq`, `novaseq`). | `hisec` |
| `--n_reads` | Number of reads to simulate. | `1M` |
| `--abundance` | Abundance distribution (e.g., `lognormal`, `uniform`). | `lognormal` |

---

## Pipeline Components

### `InSilicoSeq` Process
The core simulation is handled by the `ISS_GENERATE` process. It uses Nextflow’s container directives to ensure the environment is consistent.
```nextflow
process ISS_GENERATE {
    tag "$meta.id"
    label 'process_high'
    container 'biocontainers/insilicoseq:1.6.0--py310h7cba7d3_0'

    input:
    tuple val(meta), path(genomes)

    output:
    tuple val(meta), path("*.fastq.gz"), emit: reads

    script:
    """
    iss generate --genomes $genomes --model $params.model --output ${meta.id} --cpus $task.cpus --n_reads $params.n_reads
    gzip *.fastq
    """
}

## Citations
If you use this pipeline, please cite:

Nextflow: Di Tommaso, P., et al. (2017). Nextflow enables reproducible computational workflows. Nature Biotechnology.

InSilicoSeq: Gourlé, H., et al. (2019). Simulating Illumina metagenomic data with InSilicoSeq. Bioinformatics.

## Pipeline Components
This project is licensed under the MIT License.

