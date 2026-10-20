```python
import numpy as np

def pairwise_hamming_matrix(sequences: list[str]) -> np.ndarray:
    """
    Computes a pairwise Hamming distance matrix across a list of aligned sequences.
    """
    # 1. Convert list of strings to 2D uint8 matrix (num_seqs, seq_len)
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

## Explanation:
1. Converting Strings to a 2D Array:
It breaks each string into individual characters and stacks them into a 2D grid of size (`num_sequences`, `sequence_length`). For our input, it creates a 4×4 grid of characters.

2. **Converting to Integers for Speed:**
It converts the characters into their numerical Unicode/ASCII values (A becomes 65, T becomes 84, etc.). Computers compare numbers much faster than text characters.

3. **Broadcasting & Comparison (The Clever Part):**
By adding empty dimensions (`np.newaxis`), NumPy automatically compares every sequence against every other sequence character-by-character. It creates a 3D block of True (mismatch) and False (match) values.

4. **Summing the Mismatches:**
It counts how many True values (mismatches) exist between each pair of sequences and returns them as a 2D matrix.


## Output:
```bash
Pairwise Distance Matrix:
[[0 1 1 1]
 [1 0 2 2]
 [1 2 0 2]
 [1 2 2 0]]
```

Each row and column represents one of our sequences in order:
```text
               Col 0     Col 1     Col 2     Col 3
              [ATGC]    [ATGA]    [ACGC]    [TTGC]
               ───       ───       ───       ───
Row 0 [ATGC] │  0         1         1         1  │
Row 1 [ATGA] │  1         0         2         2  │
Row 2 [ACGC] │  1         2         0         2  │
Row 3 [TTGC] │  1         2         2         0  │
```

- The Diagonal (all 0s): A sequence compared to itself has 0 differences (e.g., Row 0, Col 0 is "ATGC" vs "ATGC" = 0).
- Row 0, Col 1 (1): Comparing "ATG**C**" vs "ATG**A**". Only the last character is different, so the distance is 1.
- Row 1, Col 2 (2): Comparing "A**T**G**A**" vs "A**C**G**C**". The 2nd and 4th characters are different, so the distance is 2.








































