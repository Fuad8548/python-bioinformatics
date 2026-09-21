# Indexing, Slicing, and Masking (`indexing_and_slicing/`)
NumPy enables fast coordinate retrieval, sub-region extraction, and conditional filtering across multi-dimensional genomic datasets.

## Sliding Window GC Content Calculation
Sliding windows parse genomic sequences into overlapping intervals of size $w$ with step size $s$:
        $\text{GC}\% = \frac{N_G + N_C}{w} \times 100$

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
   -  **Window 1**: Starts at index 0 
        $\Longrightarrow$ `A T G C G`
   -  **Window 2**: Jumps forward 2 steps, starts at index 2 $\Longrightarrow$ `G C G A T`
   -  **Window 3**: Jumps forward 2 steps, starts at index 4 $\Longrightarrow$ `G A T C G`(and so on until it reaches the end of the sequence)
1. **Calculating the Percentages (The Loop):**
`gc_percentages[i] = np.mean(is_gc[start:end]) * 100`  => For each window, it takes the average (`np.mean`) of the True/False values inside that specific chunk.
   - Because Python treats `True` as `1` and `False` as `0`; the average of `[True, False, True, True, False]` (which is 1, 0, 1, 1, 0) is $\(\frac{3}{5} = 0.6\)$.
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

## Breakdown of the Code Logic
    
    $$\text{Phred Score } Q = -10 \cdot \log_{10}(P_{\text{error}})$$

A score of `Q = 20` means the probability of a sequencing error is **1 in 100(1%)**.Your code evaluates each base's score against this threshold.Bases at indices 2(Q=12), 5(Q=9), and 8(Q=15) have error probabilities much higher than 1% (e.g., Q=10 means a massive 10% error rate). 

- `pass_mask`: The array `pass_mask = phred_scores >= min_q` identifies these unreliable positions as `False` and eliminates them, ensuring that our `filtered_scores` array only contains high-confidence genomic data (**1% error rate or lower**). All other elements evaluate to `True`.
- `filtered_scores`: Drops the three low-quality values, keeping the remaining 7 bases that meet or exceed your threshold.
- **Pass Rate**: Since 7 out of 10 bases passed, the mean of the boolean array evaluates to 0.7, giving exactly 70.0%.


**Why is Boolean Masking Needed in Bioinformatics?**:
In bioinformatics, boolean masking serves as an essential, high-performance filter to weed out unreliable sequencing data before it corrupts downstream genomic analyses.
Next-Generation Sequencing (**NGS**) machines process millions to billions of DNA fragments simultaneously. However, chemical instabilities and optical noise mean the machine occasionally misreads a base.

Bioinformatics relies on boolean masking for three major reasons:
1. **Preventing "Garbage In, Garbage Out"**
   If a base has a low Phred score (high error probability), including it in downstream pipelines can lead to false positives—such as identifying a sequencing error as a genetic mutation (variant calling) or misassembling a genome.
2. **Extreme Computational Efficiency** 
   DNA data files (like FASTQ or BAM) are massive, often gigabytes or terabytes in size. Traditional python loops (for loops with if statements) are far too slow. NumPy handles boolean masks at the hardware level using vectorized operations (C-level execution), filtering millions of data points almost instantly.
3. **Dynamic Thresholding** 
   Depending on the application, strictness varies. For clinical diagnostics, you might mask out everything below Q30 (0.1% error rate). For rough organism identification, Q20 (1% error rate) might suffice. Boolean masks allow us to change one parameter (`min_q`) to instantly update the entire dataset. 































