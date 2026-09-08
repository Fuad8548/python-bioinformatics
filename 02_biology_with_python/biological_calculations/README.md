# Biological Calculations with Python

Quantitative analysis of sequence statistics provides insights into genomic replication dynamics, evolutionary conservation, and codon preferences.

## Learning Objectives

You should be able to:

- turn biological formulas into functions;
- distinguish counts, fractions, and percentages;
- validate data before calculation;
- handle empty or invalid input;
- document units and assumptions.

## Metric Definitions
  1. **GC Skew**: Measure of Guanine-Cytosine asymmetry across a sliding window, commonly used to pinpoint replication origins ($oriC$) in bacterial genomes:
        $$\text{GC Skew} = \frac{G - C}{G + C}$$

  2. **Hamming Distance**: Counts the number of point substitutions between two aligned sequences of equal length:
        $$D_H(s_1, s_2) = \sum_{i=1}^{L} [s_1[i] \neq s_2[i]]$$

```python
def sequence_length(sequence):
    return len(sequence)
```

## Python Metrics Engine

```python
def calculate_gc_skew(sequence: str) -> float:
    """ Calculate GC skew ratio (-1.0 to +1.0) """
    seq = sequence.upper()
    g = seq.count("G")
    c = seq.count("C")
    if g + c == 0:
        return 0.0
    return round((g - c) / (g + c), 4)

def hamming_distance(seq1: str, seq2: str) -> int:
    """ Calculates point mutation count between two equal-length sequences. """
    if len(seq1) != len(seq2):
        raise ValueError("Sequences must be of equal length to calculate Hamming distance.")
    return sum(1 for a, b in zip(seq1.upper(), seq2.upper()) if a != b)

def calculate_sequence_identity(seq1: str, seq2: str) -> float:
    """ Calculates percentage identity between two aligned sequences. """
    dist = hamming_distance(seq1, seq2)
    return round(((len(seq1) - dist) / len(seq1)) * 100, 2)

# Test calculations
s1 = "ATGCGATCGATCG"
s2 = "ATGCGATCCATCG"  # 1 mutation at index 8

print("GC Skew:", calculate_gc_skew(s1))
print("Hamming Distance:", hamming_distance(s1, s2))
print("Sequence Identity:", calculate_sequence_identity(s1, s2), "%")
```

