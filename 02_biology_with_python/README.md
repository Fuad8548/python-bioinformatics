# Chapter 2: Biology with Python

This chapter bridges computer science and molecular biology, translating core concepts of the **Central Dogma of Molecular Biology** (DNA => RNA => Protein) and quantitative biological calculations into clean Python algorithms.

## Chapter Directory Structure

```text
02_biology_with_python/
│
├── README.md                   
├── dna_basics/
│   ├── README.md                       
│   └── dna_tools.py
├── rna_basics/
│   ├── README.md                  
│   └── transcription.py
├── protein_basics/
│   ├── README.md                  
│   └── translation.py
└── biological_calculations/
    ├── README.md            
    └── bio_metrics.py
```

## Chapter Roadmap

1. `dna_basics/` — DNA structure, melting temp, MW, restriction sites
2. `rna_basics/` — Transcription, ORFs, codon tables
3. `protein_basics/` — Translation, amino acid properties, pI, GRAVY
4. `biological_calculations/` — GC Skew, RSCU, Hamming distance, sequence identity

## Learning Objectives

By the end of this chapter, you should be able to:

- represent DNA, RNA, and protein sequences in Python;
- validate biological sequences;
- perform transcription, complement, and reverse-complement operations;
- split RNA into codons and reason about reading frames;
- translate coding RNA into amino-acid sequences;
- calculate GC content, nucleotide composition, and basic sequence statistics;
- write reusable functions for biological calculations;
- recognize the difference between program correctness and biological correctness.

## Suggested Mini-Projects

- DNA sequence validator
- GC-content calculator
- DNA → RNA transcription tool
- reverse-complement tool
- codon translator
- sequence statistics report
