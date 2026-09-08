# 4. Dictionaries and Sets

Dictionaries (`dict`) and Sets (`set`) are un-ordered, highly optimized collections based on hash tables. Dictionaries store key-value pairs, making them ideal for gene lookups, codon tables, and k-mer counting. Sets store unique elements, making them essential for finding overlaps, set differences, and deduplicating sequence data.

## Learning Objectives

- Store key-value relationships with dictionaries.
- Access, add, update, and remove dictionary values.
- Iterate through dictionary keys and values.
- Use sets to identify unique elements.

## Key Characteristics
- **Dictionary** (`dict`): Map unique keys to arbitrary values (e.g., `{"ATG": "Methionine"}`). Fast `O(1)` average time complexity for lookups.
- **Set** (`set`): Stores unique, unordered elements (e.g., `{"BRCA1", "TP53"}`). Essential for mathematical set operations (intersections, unions, differences).

## 1. Dictionaries for Codon Translation and Metadata

```python
# Genetic Code Mapping (Codon -> Amino Acid)
codon_table = {
    "ATG": "M",  # Methionine (Start)
    "TTT": "F",  # Phenylalanine
    "TTC": "F",
    "TAA": "*",  # Stop
    "TAG": "*",  # Stop
    "TGA": "*"   # Stop
}

# Safe lookup using .get() to prevent KeyError
codon = "ATG"
amino_acid = codon_table.get(codon, "Unknown")
print(f"Codon {codon} translates to: {amino_acid}")

# Adding new entries
codon_table["TGG"] = "W"  # Tryptophan

# Iterating over key-value pairs
for cod, aa in codon_table.items():
    if aa == "*":
        print(f"Stop codon found: {cod}")
```

## 2. Counting K-mers using Dictionaries
Counting short DNA substrings (k-mers) is a core step in genome assembly and sequence alignment.

```python
sequence = "ATGCGATCGATCGATCG"
k = 3   #  sets the window size to 3 letters
kmer_counts = {}   # This creates an empty dictionary to store the results (e.g., {'ATG': 1}).

# Slide a window of size k across the sequence
for i in range(len(sequence) - k + 1):   # this loop moves a window one letter at a time and stops at index 14 so the 3 letter window doesn't overshoot at the end.
    kmer = sequence[i:i+k]    # cuts out 3-letter snippet at the current position [0:3], [1:4],.....
    kmer_counts[kmer] = kmer_counts.get(kmer, 0) + 1  # if k-mer doesn't exist yet, start at 0; then add 1 to it.

# Print k-mer frequencies
for kmer, count in kmer_counts.items():
    print(f"{kmer}: {count}")
```

Output:
```bash
ATG: 1
TGC: 1
GCG: 1
CGA: 3
GAT: 3
ATC: 3
TCG: 3
```

## 3. Sets for Comparative Genomics & Differential Expression
Sets make comparing gene lists across treatment groups extremely fast and simple.

```python
# Differentially Expressed Genes (DEGs) in two conditions
control_degs = {"TP53", "BRCA1", "EGFR", "MYC", "AKT1"}
treatment_degs = {"EGFR", "MYC", "KRAS", "ALK", "BRAF"}

# 1. Intersection: Genes active in BOTH conditions
shared_genes = control_degs & treatment_degs
print("Shared DEGs:", shared_genes)  # Shared DEGs: {'EGFR', 'MYC'}

# 2. Difference: Genes UNIQUE to control condition
control_only = control_degs - treatment_degs
print("Control-only DEGs:", control_only)   # Control-only DEGs: {'TP53', 'AKT1', 'BRCA1'}

# 3. Union: ALL unique genes across both conditions
all_unique_genes = control_degs | treatment_degs
print("Total unique DEGs:", len(all_unique_genes))  # Total unique DEGs: 8
```

## 4. Sequence uniquification with Sets

```python
raw_reads = ["ATGC", "GATC", "ATGC", "CGTA", "GATC", "AAAA"]

# Remove duplicate sequencing reads instantly
unique_reads = list(set(raw_reads))
print("Unique reads:", unique_reads)
```

## Exercises

1. Given a DNA sequence "`ATGCGATACGAATC`", write a script using a dictionary to count the frequency of each base (`A, T, G, C`).

2. You have three gene sets representing targets from three different drug screens:

   - Screen A: {"BRCA1", "TP53", "ATM"}

   - Screen B: {"TP53", "EGFR", "ATM"}

   - Screen C: {"ATM", "CHEK2", "BRCA1"}

Find the single gene that is present in all three screens using set operations.
