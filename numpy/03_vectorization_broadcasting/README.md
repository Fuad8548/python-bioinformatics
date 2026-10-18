# Vectorization and Broadcasting (`vectorization/`)
Vectorization replaces explicit Python `for` loops with pre-compiled C-level operations over arrays, accelerating genomic matrix operations.


## Vectorized Distance Operations: Hamming Distance
The Hamming distance $D_H$ between two equal-length sequences $S_1$ and $S_2$ measures the number of mismatching positions:
    $$D_H(S_1, S_2) = \sum_{i=1}^{N} \mathbb{I}(S_1[i] \neq S_2[i])$$

```python
import numpy as np

def vectorized_hamming_distance(seq1: str, seq2: str) -> int:
    """
    Computes Hamming distance between two sequences using vectorized comparison.
    """
    arr1 = np.frombuffer(seq1.encode('ascii'), dtype=np.uint8)
    arr2 = np.frombuffer(seq2.encode('ascii'), dtype=np.uint8)
    
    # Vectorized element-wise inequality check
    mismatches = np.sum(arr1 != arr2)
    return int(mismatches)

s1 = "GATTACA"
s2 = "GACTATA"
print("Hamming Distance:", vectorized_hamming_distance(s1, s2))
```

**Explanation:**
**Vectorization** calculates the **Hamming Distance** (the number of single-character differences between two DNA sequences of equal length) without using a single Python loop.
Here is an accessible breakdown of how the code achieves this at the hardware level.

1. Converting Text to Memory (`np.frombuffer`)
```python
arr1 = np.frombuffer(seq1.encode('ascii'), dtype=np.uint8)
```
- **What it does**: Python strings are high-level objects that carry a lot of computational overhead. The code converts the DNA strings ("`GATTACA`") into standard ASCII numbers stored as unsigned 8-bit integers (`np.uint8`).
- **The result**: The sequences are transformed into simple numeric arrays in memory:
  - "`GATTACA`" becomes `[71, 65, 84, 84, 65, 67, 65]`
  - "`GACTATA`" becomes `[71, 65, 67, 84, 65, 84, 65]`

2. The Vectorized Comparison (`arr1 != arr2`)
Instead of iterating through the sequences character-by-character using a slow Python `for` loop, NumPy hands this operation off to pre-compiled C-code.
It performs an **element-wise vector comparison** simultaneously across the entire array.

```text
arr1:  [ 71,  65,  84,  84,  65,  67,  65 ]  (G A T T A C A)
         !=   !=   !=   !=   !=   !=   !=
arr2:  [ 71,  65,  67,  84,  65,  84,  65 ]  (G A C T A T A)
-------------------------------------------
Result:[False,False,True,False,False,True,False]
```
The resulting boolean array acts exactly like the indicator function $\(\mathbb{I}(S_1[i] \neq S_2[i])\)$ from our mathematical equation. It marks mismatches as True and matches as False. 

3. The Vectorized Reduction (`np.sum`)

```python
mismatches = np.sum(arr1 != arr2)
```
In computer logic, `True` is treated as `1` and `False` is treated as `0`.When `np.sum()` adds up the boolean array, it is literally adding `0 + 0 + 1 + 0 + 0 + 1 + 0 = 2`.
This directly maps to the summation $\[\sum _{i=1}^{N}\]$ in our formula, giving the final **Hamming Distance of 2**. 

**Why is this crucial for Bioinformatics?**
When comparing a patient's DNA sample against a reference genome, scientists must calculate mismatches across billions of base pairs.
- A standard Python loop (`for i in range(len(s1))`) has massive overhead because Python must check the data type, look up methods, and manage memory for every single character.
- Vectorization bypasses Python entirely during the loop. It instructs the computer's CPU to load the arrays directly into its vector registers (using SIMD - Single Instruction, Multiple Data). The hardware evaluates multiple positions at the exact same clock cycle, running 100x to 1000x faster than native Python.

## Pairwise Distance Matrix via Broadcasting
Broadcasting allows arrays with different shapes to participate in arithmetic operations without copying memory.

```python
import numpy as np

def pairwise_hamming_matrix(sequences: list[str]) -> np.ndarray:
    """
    Computes a pairwise Hamming distance matrix across a list of aligned sequences.
    """
    # Convert list of strings to 2D uint8 matrix (num_seqs, seq_len)
    char_matrix = np.array([list(s) for s in sequences], dtype='U1')
    ascii_matrix = char_matrix.view(np.int32)
    
    # Expand dimensions for broadcasting: (N, 1, L) != (1, N, L) -> (N, N, L)
    diff_tensor = ascii_matrix[:, np.newaxis, :] != ascii_matrix[np.newaxis, :, :]
    
    # Sum mismatches along length axis (axis 2)
    dist_matrix = np.sum(diff_tensor, axis=2)
    return dist_matrix

seq_list = ["ATGC", "ATGA", "ACGC", "TTGC"]
dist_mat = pairwise_hamming_matrix(seq_list)
print("Pairwise Distance Matrix:\n", dist_mat)
```










































