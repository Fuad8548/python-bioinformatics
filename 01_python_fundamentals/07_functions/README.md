# 7. Functions

Functions are reusable blocks of code designed to perform a specific task. In bioinformatics workflows, writing modular functions prevents code duplication and makes your scripts testable, maintainable, and easy to share. Functions allow you to abstract complex sequence transformations—such as calculating GC content, translating codons, or computing alignment metrics—into clean, reusable components.

## Key Function Concepts

|        Concept         |                Syntax                |                  Bioinformatics Example                   |
| :--------------------: | :----------------------------------: | :-------------------------------------------------------: |
|          def           |         def function_name()          |                 Defining custom algorithm                 |
| parameters & arguments | def reverse_comp(seq, is_rna=False): |    Accepting input sequence and configuration options     |
|    Return statement    |          return gc_percent           |       passing calculated metrics back to the caller       |
|       type hints       |          seq: str -> float           | indicating expected input/ outputs for cleaner API design |
|       Docstrings       |        """Calculates GC%."""         |       Documenting logic, and biological assumptions       |


## 1. Function Definition with Type Hints and Docstrings
Using type annotations (seq: str -> float) and structured docstrings ensures your bioinformatics tools are self-documenting.

```python
def calculate_gc_content(sequence: str) -> float:
    """
    Calculates the GC percentage of a given DNA/RNA sequence.

    Parameters:
        sequence (str): A biological sequence (case-insensitive).

    Returns:
        float: GC content percentage (0.0 to 100.0).
    """
    seq_upper = sequence.upper()
    g_count = seq_upper.count("G")
    c_count = seq_upper.count("C")
    
    if len(seq_upper) == 0:
        return 0.0

    gc_fraction = (g_count + c_count) / len(seq_upper)
    return round(gc_fraction * 100, 2)


# Function invocation
sample_seq = "ATGCGATCGATCG"
result = calculate_gc_content(sample_seq)
print(f"Sequence: {sample_seq} | GC Content: {result}%")
```

## 2. Default Arguments & Multi-value Returns (Reverse Complement)
A comprehensive function that computes the reverse complement of a sequence, supporting both DNA and RNA modes.

```python
def get_reverse_complement(sequence: str, is_rna: bool = False) -> tuple[str, int]:
    """
    Generates the reverse complement of a DNA or RNA sequence.
    
    Returns:
        tuple[str, int]: (reverse_complement_sequence, sequence_length)
    """
    seq_upper = sequence.upper()
    
    if is_rna:
        complement_map = str.maketrans("AUGC", "UACG")
    else:
        complement_map = str.maketrans("ATGC", "TACG")
        
    complement = seq_upper.translate(complement_map)
    reverse_complement = complement[::-1]
    
    return reverse_complement, len(sequence)


# Call with default (DNA)
rev_comp, seq_len = get_reverse_complement("ATGCGATC")
print(f"DNA Reverse Complement: {rev_comp} (Length: {seq_len})")    # DNA Reverse Complement: GATCGCAT (Length: 8)

# Call with optional flag (RNA)
rna_rev_comp, _ = get_reverse_complement("AUGCGAUC", is_rna=True)
print(f"RNA Reverse Complement: {rna_rev_comp}")   # RNA Reverse Complement: GAUCGCAU
```

## 3. Lambda Functions for Fast Sequence Filtering
Lambda functions provide lightweight inline logic, useful for sorting or filtering list items based on biological criteria.

```python
sequences = ["ATGC", "CGATCGATCGATC", "GATC", "ATGCGATC"]

# Filter sequences longer than 5 base pairs using filter() and lambda
long_seqs = list(filter(lambda s: len(s) > 5, sequences))
print("Sequences > 5bp", long_seqs)

# Sort sequences by GC content percentage using sorted() and key
gc_sorted = sorted(sequences, key = lambda s: (s.count("G") + s.count("C"))/ len(s))
print("Sequences sorted by GC content:", gc_sorted)
```

## Exercises

1. Write a function `transcribe_and_translate(dna_seq: str) -> str` that accepts a DNA sequence, transcribes it to RNA, and translates the first three codons into single-letter amino acids using a built-in dictionary.

2. Create a function `find_kmers(sequence: str, k: int = 3, min_count: int = 1) -> dict` that returns a dictionary of all k-mers occurring at least `min_count` times in the sequence.
