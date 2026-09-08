# 6. Loops

Loops allow you to iterate over collections (sequences, lists, dictionaries) or execute code repeatedly until a condition is satisfied. Bioinformatics relies heavily on loops for parsing large FASTA/FASTQ datasets, running sliding-window algorithms, iterating over genomic ranges, and calculating moving metrics across chromosomes.

## Types of loops and helpers

|    Construct     |                    Description                    |                    Bioinformatics Example                     |
| :--------------: | :-----------------------------------------------: | :-----------------------------------------------------------: |
|       for        |  Iterate over a sequence or iterable collection   |   Iterating over sequence bases, lists of files, or records   |
|      while       | Executes as long as a condition evaluates to True |  Parsing stream buffer or search windows until a stop codon   |
|   enumerate()    |     provides both loop index counter and item     | tracking base positions coordinates during sequence traversal |
|      zip()       |  iterates over two or more lists simultaneously   | pairing forward and reverse reads or sequence IDs with scores |
| break / continue |  exits loop early / skips to the next iteration   |   stopping at the first stop codon / skipping header lines    |

## 1. Sliding Window Algorithm (`k-mer` Extraction)
A fundamental algorithm in bioinformatics used to generate overlapping substrings of length `k` across a chromosome or gene sequence.

```python
sequence = "ATGCGATCG"
k = 3

print(f"Extracting {k}-mers from sequence of length {len(sequence)}:")

for i in range(len(sequence) - k + 1):
    kmer = sequence[i:i+k]
    print(f"Position {i}-{i+k}: {kmer}")
```

## 2. Processing Paired-End Reads using zip() and enumerate()
Combining matching forward and reverse FASTQ read identifiers to check orientation.

```python
reference = "ATGCGTACGT"
mutated   = "ATGCGTTCGT"  # Mutation at index 6 (A -> T)

# Find point mutations and their exact genomic positions
for position, (ref_base, mut_base) in enumerate(zip(reference, mutated), start=1):
    if ref_base != mut_base:
        print(f"Mutation found at position {position}: {ref_base} -> {mut_base}")

```

## 3. Reading Codons until a Stop Codon using a while Loop
Iterating through a coding sequence in steps of 3 nucleotides (codons) and terminating translation upon hitting a stop codon.

```python
dna_sequence = "ATGGCATTCGATTGATAACTGA"
stop_codons = {"TAA", "TAG", "TGA"}

position = 0
translated_codons = []

while position < len(dna_sequence) - 2:
    codon = dna_sequence[position:position + 3]

    if codon in stop_codons:
        print(f"Stop codon '{codon}' encountered at index {position}. Terminating translation.")
        break

    translated_codons.append(codon)
    position += 3   # move to the next codon frame

print("Coding codons before stop: ", translated_codons)
```

## 4. Filtering FASTA Lines with continue
Skipping header comment lines (`>`) when parsing raw FASTA data.

```python
fasta_lines = [
    ">sp|P04637|P53_HUMAN Cellular tumor antigen p53",
    "MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGP",
    ">sp|P01116|RASS_HUMAN Ras-related protein",
    "MTEYKLVVVGAGGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETCLLDILDTAG"
]

sequence_data = []

for line in fasta_lines:
    # Skip FASTA header lines
    if line.startswith(">"):
        continue
    sequence_data.append(line)

print("Extracted Protein Sequence Lines:", sequence_data)
```

## Exercises

1. Write a `for` loop using `enumerate()` that scans the sequence "`ATGCGCATCGATCG`" and prints the index position every time the dinucleotide "`CG`" (a CpG site) occurs.

2. Given a genome sequence "`ATGCGATCGATCGATCGATCGAT`", write a sliding window loop (window size = 10, step size = 2) that calculates and prints the GC percentage for each overlapping window.
