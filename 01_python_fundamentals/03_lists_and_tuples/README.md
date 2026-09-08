# 3. Lists and Tuples

Lists and tuples are ordered collections used to store multiple items in a single variable. In bioinformatics, you use lists when data needs to be modified, filtered, or appended (e.g., parsing sequencing reads or storing gene expression values). You use tuples for immutable data that should not change during execution (e.g., genomic coordinates, chromosome positions, or database records).

## Learning Objectives

- Create and index lists and tuples.
- Add, remove, and sort list elements.
- Loop through collections.
- Understand mutability.
- Decide when a tuple is preferable to a list.

## Lists vs Tuples
|   Feature   |                    List                    |                   Tuple                   |
| :---------: | :----------------------------------------: | :---------------------------------------: |
|   Syntax    |         Square Brackets [1, 2, 3]          |           Parentheses (1, 2, 3)           |
| Mutability  | Mutable (can add, remove, or change items) |  Immutable (can't change after creation)  |
| Performance |      Slightly higher memory footprint      |     Memory efficient & faster access      |
|  Use case   | Dynamic Sequence collections, sample lists | Fixed coordinate pairs (char, start, end) |

## 1. Lists (Methods and Operations)

```python
# List of gene symbols
genes = ["TP53", "BRCA1", "EGFR"]

# Appending a new gene
genes.append("MYC")
print(genes)   # ['TP53', 'BRCA1', 'EGFR', 'MYC']

# Removing a gene 
genes.remove("MYC")
print(genes)    # ['TP53', 'BRCA1', 'EGFR']

# Sort alphabetically
genes.sort()
print(genes)    # ['BRCA1', 'EGFR', 'TP53']

# Modifying an element
genes[2] = "TP53_mutant"
print(genes)    # ['BRCA1', 'EGFR', 'TP53_mutant']

# Finding List length
print("Gene count:", len(genes))   # Gene count: 3

# Indexing
print("First gene:", genes[0])    # First gene: BRCA1
print("Last gene:", genes[-1])   # Last gene: TP53_mutant

# Slicing
print("2nd and 3rd gene:", genes[1:3])  # 2nd and 3rd gene: ['EGFR', 'TP53_mutant']

# Sorting expression levels (numeric list)
expression_levels = [12.4, 3.1, 45.8, 0.2, 18.9]
expression_levels.sort(reverse=True)  # Sorts in-place (descending)

print("Top expression levels:", expression_levels)  # Top expression levels: [45.8, 18.9, 12.4, 3.1, 0.2]
```

## 2. List Comprehensions for Sequence Processing
List comprehensions provide a concise way to transform or filter biological sequence lists.

```python
dna_reads = ["ATGCGATC", "CGAT", "ATGCGGCTAGC", "TCA", "GATCGATCGATC"]

# Calculate lengths of all sequences
read_lengths = [len(seq) for seq in dna_reads]
print("Read lengths:", read_lengths)   # Read lengths: [8, 4, 11, 3, 12]

# Filter sequences longer than 5 base pairs
long_reads = [seq for seq in dna_reads if len(seq) > 5]
print("Long reads (>5bp):", long_reads)  # Long reads (>5bp): ['ATGCGATC', 'ATGCGGCTAGC', 'GATCGATCGATC']

# Convert all reads to RNA (replace T with U)
rna_reads = [seq.replace("T", "U") for seq in dna_reads]
print("RNA reads:", rna_reads)   # RNA reads: ['AUGCGAUC', 'CGAU', 'AUGCGGCUAGC', 'UCA', 'GAUCGAUCGAUC']
```

## 3. Tuples (Genomic Coordinates & Unpacking) 

```python
# Genomic BED record: (chromosome, start, end, gene_name, strand)
feature_location = ("chr17", 7571720, 7590868, "TP53", "-")

# Tuple Unpacking
chrom, start, end, gene, strand = feature_location

# Calculating genomic length safely
feature_length = end - start
print(f"Feature '{gene}' on {chrom} ({strand}) spans {feature_length} bp.")   # Feature 'TP53' on chr17 (-) spans 19148 bp.

# Attempting to modify a tuple raises a TypeError
feature_location[1] = 7571721  # TypeError: 'tuple' object does not support item assignment
```

## Practice Exercises
1. Given a list of sequence quality scores `scores = [38, 40, 12, 28, 35, 9, 40]`, use a list comprehension to filter out low-quality scores (keep only scores >= 30).
2. Create a list of tuples representing genomic regions: `[("chr1", 100, 200), ("chr1", 150, 300), ("chr2", 500, 600)]`. Write a loop to extract and print only the regions located on `chr1`.


