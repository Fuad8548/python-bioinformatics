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