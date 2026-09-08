# 2. Strings

Strings are the main starting point for sequence analysis in Python. DNA, RNA, protein sequences, gene names, sample IDs, and chromosome names can all be represented as strings. Mastering string manipulation is essential for sequence cleaning, motif searching, quality checking, and formatting.

## Learning Objectives

You will learn to:

- Create and inspect strings.
- Index and slice sequences.
- Change case and clean sequence text.
- Search for motifs.
- Count bases or amino acids.
- Combine and split strings.

# Essential String Operations

## 1. Indexing & Slicing
Python uses 0-based indexing. Slicing follows the syntax `string[start:stop:step]`.

```python
dna = "ATGCGATCGATCG"

# Indexing
first_base = dna[0]      # 'A'
last_base = dna[-1]      # 'G'

# Slicing
start_codon = dna[0:3]   # 'ATG' (indices 0, 1, 2)
first_ten = dna[:10]     # 'ATGCGATCGA'
reverse_dna = dna[::-1]  # 'GCTAGCTAGCGTA'
```

## 2. Sequence Case Normalization & Replacement

```python
raw_seq = "atgcGATCcgN"

# Convert to uppercase
clean_seq = raw_seq.upper()   # "ATGCGATCCGN"

# Replace ambiguous base 'N' with 'A'
fixed_seq = clean_seq.replace("N", "")

# Transcription (DNA -> RNA)
rna_seq = fixed_seq.replace("T", "U")

print("RNA Sequence:", rna_seq)  # "AUGCGAUCCG"
```

## 3. Motif Searching & Counting

Python uses zero-based indexing.

```python
sequence = "ATGCGATCGATCGATCG"

# Counting nucleotides and motifs
g_count = sequence.count("G")
c_count = sequence.count("C")
restriction_site_count = sequence.count("GATC")

# Finding position of Start Codon
start_pos = sequence.find("ATG")  # Returns index 0 (-1 if not found)

print(f"G: {g_count}, C: {c_count}")  # G: 5, C: 4
print(f"GATC sites found: {restriction_site_count}")   # GATC sites found: 3
print(f"Start codon index: {start_pos}")   # Start codon index: 0
```

## 4. FASTA Header Formatting with f-strings

```python
gene_id = "HUMAN_BRCA1"
length = 5589
gc_content = 42.3381

# Formatted string output
fasta_header = f">{gene_id} | Length={length}bp | GC={gc_content:.2f}%"
print(fasta_header)
# Output: >HUMAN_BRCA1 | Length=5589bp | GC=42.34%
```

## Common Mistakes

Remember that strings are immutable. Methods such as `.upper()` return a new string rather than changing the original in place.

## Practice Exercises
1. Given the DNA sequence "`CCGATGCGATCGATCGTAATAG`", slice and print the region starting from the first "`ATG`" up to the index of "`TAA`".

2. Write a script that takes a FASTA header line like "`>sp|P04637|P53_HUMAN Cellular tumor antigen p53`" and extracts just the accession number (P04637).


