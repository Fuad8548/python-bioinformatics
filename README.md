import os

# 1. Create root README.md
readme_content = """# Python for Bioinformatics: A Hands-On Guide

[![Python 3.10+](https://img.shields.io/badge/python-3.10%2B-blue.svg)](https://www.python.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Biopython](https://img.shields.io/badge/dependency-Biopython-green.svg)](https://biopython.org/)
[![RDKit](https://img.shields.io/badge/dependency-RDKit-orange.svg)](https://www.rdkit.org/)

A comprehensive, structured repository for learning Python programming tailored specifically for bioinformatics, computational biology, genomics, and drug discovery. From core syntax to advanced machine learning and cheminformatics.

---

## 📚 Repository Structure & Curriculum

```text
python-bioinformatics/
│
├── README.md                           # Top-level course repository index
├── requirements.txt                    # Python dependencies
├── environment.yml                     # Conda environment definition
│
├── 01_python_fundamentals/             # Chapter 1: Core Python for Biology
│   ├── README.md
│   ├── 01_variables_and_data_types/
│   ├── 02_strings/
│   ├── 03_lists_and_tuples/
│   ├── 04_dictionaries_and_sets/
│   ├── 05_conditionals/
│   ├── 06_loops/
│   ├── 07_functions/
│   ├── 08_file_handling/
│   ├── 09_exceptions/
│   └── 10_oop_basics/
│
├── 02_biology_with_python/              # Chapter 2: Central Dogma & Bio Calculations
│   ├── README.md
│   ├── dna_basics/
│   ├── rna_basics/
│   ├── protein_basics/
│   └── biological_calculations/
│
├── 03_working_with_files/               # Chapter 3: File Formats (FASTA, FASTQ, SAM/BAM, BED, GFF)
│   ├── README.md
│   ├── txt_files/
│   ├── csv_files/
│   ├── fasta_files/
│   └── sequence_data/
│
├── 04_numpy/                            # Chapter 4: Numerical Computing in Genomics
│   ├── README.md
│   ├── arrays/
│   ├── indexing_and_slicing/
│   ├── vectorization/
│   └── biological_applications/
│
├── 05_pandas/                           # Chapter 5: DataFrames for Omics Data
│   ├── README.md
│   ├── series_and_dataframes/
│   ├── data_cleaning/
│   ├── filtering_and_grouping/
│   └── biological_datasets/
│
├── 06_data_visualization/               # Chapter 6: Biological Plots (Volcano, Heatmaps, PCA)
│   ├── README.md
│   ├── matplotlib/
│   ├── seaborn/
│   └── biological_visualization/
│
├── 07_statistics/                       # Chapter 7: Biostatistics & Hypothesis Testing
│   ├── README.md
│   ├── descriptive_statistics/
│   ├── probability/
│   ├── hypothesis_testing/
│   └── biological_statistics/
│
├── 08_biopython/                        # Chapter 8: Biopython Toolkit & Entrez Web APIs
│   ├── README.md
│   ├── sequences/
│   ├── fasta/
│   ├── genbank/
│   ├── sequence_analysis/
│   └── databases/
│
├── 09_machine_learning/                 # Chapter 9: ML in Genomics & Biomarker Discovery
│   ├── README.md
│   ├── preprocessing/
│   ├── regression/
│   ├── classification/
│   ├── clustering/
│   └── bioinformatics_projects/
│
├── 10_cheminformatics_rdkit/            # Chapter 10: Molecular Docking & Drug Discovery with RDKit
│   ├── README.md
│   ├── molecules/
│   ├── descriptors/
│   ├── fingerprints/
│   ├── visualization/
│   └── drug_discovery/
│
└── projects/                           # Capstone Applied Projects
    ├── 01_sequence_analysis/
    ├── 02_gene_expression/
    ├── 03_protein_analysis/
    ├── 04_phylogenetics/
    └── 05_drug_discovery/
```

## Installation & Quickstart
**Option 1**: Using Conda (Recommended)

```bash
# Clone the repository
git clone [https://github.com/Fuad8548/python-bioinformatics.git](https://github.com/Fuad8548/python-bioinformatics.git)
cd python-bioinformatics

# Create conda environment from file
conda env create -f environment.yml
conda activate bio-python
```

**Option 2**: Using standard `pip`

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\\Scripts\\activate

# Install required packages
pip install -r requirements.txt
```

## Required Libraries
- Core Math & Data: `numpy`, `pandas`, `scipy`, `statsmodels`
- Bioinformatics: `biopython`, `pysam`, `pybedtools`
- Cheminformatics: `rdkit`
- Machine Learning: `scikit-learn`, `xgboost`
- Visualization: `matplotlib`, `seaborn`, `plotly`

