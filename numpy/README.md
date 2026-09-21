Numerical computing forms the computational foundation of high-throughput genomic data processing. The `numpy` library provides N-dimensional arrays (`ndarray`) that store contiguous, homogeneous memory blocks, allowing vectorized matrix operations that outperform standard Python list loops by orders of magnitude.

# 1. N-Dimensional Arrays (`arrays/`)
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


# 2. Indexing, Slicing, and Masking (`indexing_and_slicing/`)
NumPy enables fast coordinate retrieval, sub-region extraction, and conditional filtering across multi-dimensional genomic datasets.

## Sliding Window GC Content Calculation
Sliding windows parse genomic sequences into overlapping intervals of size $w$ with step size $s$:
            $$GC\% = \frac{N_G + N_C}{w} \times 100$$

```python
import numpy as np

def sliding_window_gc(sequence: str, window_size: int = 4, step: int = 1) -> np.ndarray:
    """
    Computes GC content across sliding windows using vectorized array slicing.
    """
    # Convert sequence to upper ASCII array
    seq_arr = np.frombuffer(sequence.upper().encode('ascii'), dtype=np.uint8)
    
    # ASCII codes: G = 71, C = 67
    is_gc = (seq_arr == 71) | (seq_arr == 67)
    
    num_windows = (len(sequence) - window_size) // step + 1
    gc_percentages = np.zeros(num_windows, dtype=np.float64)
    
    for i in range(num_windows):
        start = i * step
        end = start + window_size
        gc_percentages[i] = np.mean(is_gc[start:end]) * 100
        
    return gc_percentages

# Test sliding window
genome_chunk = "ATGCGATCGATCGATCGATCGATCG"
gc_results = sliding_window_gc(genome_chunk, window_size=5, step=2)
print("Sliding Window GC (%):", gc_results)
```

**Explanation**:
1. **Finding all 'G' and 'C' letters at once:**
```python
seq_arr = np.frombuffer(sequence.upper().encode('ascii'), dtype=np.uint8)
is_gc = (seq_arr == 71) | (seq_arr == 67)
```
- First, it turns the DNA text into ASCII numbers.
- Then, it checks every position to see if it is a `G` (71) OR a `C` (67).
- This creates a flat array of True and False values (where True means it's a G or C, and False means it's an A or T).
2. **Setting up the Sliding Window**: 
In our test case, we set `window_size=5` and `step=2`. This means the computer will look at chunks of **5 letters at a time**, and then jump forward by **2 letters** for the next chunk:
   -  **Window 1**: Starts at index 0 \(\rightarrow \) `A T G C G`
   -  **Window 2**: Jumps forward 2 steps, starts at index 2 \(\rightarrow \) `G C G A T`
   -  **Window 3**: Jumps forward 2 steps, starts at index 4 \(\rightarrow \) `G A T C G`(and so on until it reaches the end of the sequence)
3. **Calculating the Percentages (The Loop):**
`gc_percentages[i] = np.mean(is_gc[start:end]) * 100`  => For each window, it takes the average (`np.mean`) of the True/False values inside that specific chunk.
   - Because Python treats `True` as `1` and `False` as `0`, the average of `[True, False, True, True, False]` (which is 1, 0, 1, 1, 0) is \(\frac{3}{5} = 0.6\).Multiplying by 100 converts 0.6 into 60.0%.
   - Multiplying by `100` converts `0.6` into `60.0%`.

**Output**:
When we run this on your test sequence "`ATGCGATCGATCGATCGATCGATCG`", we get a list of percentages:
```bash
Sliding Window GC (%): [60. 60. 60. 40. 60. 40. 60. 40. 60. 40. 60.]
```

## Boolean Masking for Quality Control
Boolean indexing extracts sequence positions or reads that satisfy quality score thresholds based on Phred scores:
        $$\text{Phred Score } Q = -10 \cdot \log_{10}(P_{\text{error}})$$

```python
import numpy as np

# Simulated Phred quality scores for 10 sequencing bases
phred_scores = np.array([34, 38, 12, 40, 28, 9, 31, 35, 15, 39])

# Define quality threshold
min_q = 20

# Create boolean mask
pass_mask = phred_scores >= min_q
filtered_scores = phred_scores[pass_mask]

print("Original Scores: ", phred_scores)
print("Pass Mask:       ", pass_mask)
print("Filtered Scores: ", filtered_scores)
print(f"Pass Rate:        {np.mean(pass_mask) * 100:.1f}%")
```

**Explanations**:


# 3. Vectorization and Broadcasting (`vectorization/`)

## Vectorized Distance Operations: Hamming Distance
The Hamming distance $D_H$ between two equal-length sequences $S_1$ and $S_2$ measures the number of mismatching positions:
    $$D_H(S_1, S_2) = \sum_{i=1}^{N} \mathbb{I}(S_1[i] \neq S_2[i])$$





















