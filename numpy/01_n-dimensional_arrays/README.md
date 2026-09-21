# N-Dimensional Arrays (`arrays/`)
Genomic sequences, quality scores, and variant matrices are converted into numeric array structures for mathematical manipulation.

## Memory Layout and Data Types
Unlike Python lists storing references to heterogeneous objects, NumPy arrays hold contiguous data of fixed primitive types (`uint8`, `int32`, `float64`).

```python
import numpy as np

# creating an array of nucleotide ASCII codes
dna_seq = "ATGCGATC"
ascii_array = np.frombuffer(dna_seq.encode ('ascii'), dtype = np.uint8)   # translates the text into raw bytes using ASCII numbering system

print("ASCII Array:", ascii_array)
print("Shape:", ascii_array.shape, "| Dtype:", ascii_array.dtype)
```

**Explanation**:
1. `np.frombuffer()`: Reads the raw bytes directly out of your computer's memory.
2. `dtype = np.uint8`: Tells NumPy to interpret each byte as an **8-bit unsigned integer** (a whole number from 0 to 255). Because every ASCII character is exactly 1 byte long, this splits your DNA sequence perfectly into individual numbers

**Output**: 
If you run this code, your output will look like this:
- **ASCII Array**: `[65 84 71 67 71 65 84 67]` (These are the number codes for A, T, G, C...)
- **Shape**: `(8,)` (There are exactly 8 letters/numbers in the sequence)
- **Dtype**: `uint8` (The data type used to store them)

**Why to do this?**
Processing DNA as numbers instead of text strings makes data analysis much faster. If you have a file with billions of DNA letters, converting them to numbers allows graphics cards (GPUs) and processors to scan, match, and analyze the sequence at lightning speed.

## One-Hot Encoding DNA Sequences
Genomic deep learning and statistical models represent DNA bases as 4-dimensional binary vectors:
- $A \rightarrow [1, 0, 0, 0]$
- $C \rightarrow [0, 1, 0, 0]$
- $G \rightarrow [0, 0, 1, 0]$
- $T \rightarrow [0, 0, 0, 1]$

```python
import numpy as np

def one_hot_encode(sequence: str) -> np.ndarray:
    """
    Encodes a DNA sequence into a 2D one-hot binary array of shape (N, 4).
    """
    mapping = {'A': 0, 'C': 1, 'G': 2, 'T': 3}
    seq_upper = sequence.upper()
    
    # Initialize zero matrix
    encoded = np.zeros((len(seq_upper), 4), dtype=np.uint8)
    
    for i, base in enumerate(seq_upper):
        if base in mapping:
            encoded[i, mapping[base]] = 1
            
    return encoded

# Example usage
dna = "ACGTTAGC"
one_hot = one_hot_encode(dna)
print("One-Hot Encoded Matrix Shape:", one_hot.shape)
print(one_hot)
```

**Explanation**:
This script performs one-hot encoding, which transforms a text-based DNA sequence into a **2D matrix of 1s and 0s**. This format is essential because machine learning models and neural networks cannot process text directly—they require numerical arrays.

1. **Initializing zero matrix**: `encoded = np.zeros((len(seq_upper), 4), dtype=np.uint8)` => this createds a grid filled entirely with zeros
    - The number of rows matches the length of your DNA sequence (8 rows for "ACGTTAGC").
    - The number of columns is always 4 (one for each possible base).
2. **Filling the Matrix (The Loop)**: 
    ```python
    for i, base in enumerate(seq_upper):
    if base in mapping:
        encoded[i, mapping[base]] = 1
    ```
The code loops through your DNA sequence one letter at a time. For every letter, it looks up its column index and changes that specific position from a `0` to a `1`.

**Output:**
```bash
Row (Base)    [ A,  C,  G,  T ]
-------------------------------
0 ('A')  -->  [ 1,  0,  0,  0 ]   # 1 is in the 'A' column
1 ('C')  -->  [ 0,  1,  0,  0 ]   # 1 is in the 'C' column
2 ('G')  -->  [ 0,  0,  1,  0 ]   # 1 is in the 'G' column
3 ('T')  -->  [ 0,  0,  0,  1 ]   # 1 is in the 'T' column
4 ('T')  -->  [ 0,  0,  0,  1 ]   # 1 is in the 'T' column
5 ('A')  -->  [ 1,  0,  0,  0 ]   # 1 is in the 'A' column
6 ('G')  -->  [ 0,  0,  1,  0 ]   # 1 is in the 'G' column
7 ('C')  -->  [ 0,  1,  0,  0 ]   # 1 is in the 'C' column
```
**Shape**: (8, 4) because there are 8 bases, and each base is represented by a 4-element binary vector.
