# 2. Data Cleaning in Omics
Omics datasets frequently contain missing expression values (`NaN`), unmapped reads, or infinite values resulting from $\log_2(0)$ division errors. This section addresses a universal challenge in high-throughput biology: processing messy raw count matrices and converting them into normalized mathematical distributions.
Raw data from sequencing machines (like Illumina sequencers) or mass spectrometers is rarely pristine. It frequently contains missing values due to technical limitations and highly skewed ranges. This step stabilizes the data before running downstream statistical analysis.


## Part A: Identifying Missing Values

- Detecting Missing Cells (`.isna()`): The `.isna()` method checks every single coordinate in the `df_counts` DataFrame. It flags actual data points as `False` and empty, missing positions (`np.nan`) as `True`.
- Summing Up the Flagged Blanks (`.sum()`): Because Python treats True as 1 and False as 0, chain-linking `.sum()` down the column adds up all the True flags. It outputs the total count of missing data points for each individual experimental sample.

**Why It Matters in Bioinformatics**
In transcriptomics (RNA-seq) or proteomics, missing data (represented as `NaN` or "Not a Number") happens for two reasons:
- Biological Dropouts: The gene or protein is genuinely not expressed in that sample.
- Technical Dropouts: The instrument failed to capture the gene because its expression was too low or the tissue sample degraded.

## Part B: Imputing Missing Values
```python
df_cleaned = df_counts.fillna(0)  
```

- Imputing with Zeros (`.fillna(0)`): The .fillna(0) tool targets every single missing `NaN` value in our table and swaps it out for a flat 0.
- The Context of `df_counts`: Looking at our starting data, `Control_1` for `Gene_C` was `np.nan`. Similarly, `Treated_1` for `Gene_B` was `np.nan`. After executing this line, those two specific empty slots become explicit numerical zeros.

**Why It Matters in Bioinformatics**
Most algebraic math models, statistical tests (like ANOVA), and machine learning packages will crash if they hit a NaN value. Replacing missing data with calculated guesses is called imputation.

## Part C: The Log2 Transformation and the "Pseudocount"
```python
df_log2 = np.log2(df_cleaned + 1)
```
- Adding a Pseudocount (`df_cleaned + 1`): Before applying any logarithmic math, the code adds exactly 1 to every single cell value in the matrix.
• Calculating base-2 Logarithms (`np.log2`): NumPy calculates the binary logarithm for each modified coordinate.


**Why It Matters in Bioinformatics**
This step resolves two significant mathematical roadblocks in computational biology:
• The log(0) Singularity Error: In pure mathematics, $\(\log_2(0)\)$ is undefined (it approaches negative infinity). Since biological count tables are filled with zeros, calculating a log transformation directly would completely break our software. By adding a pseudocount of +1, any absolute zero shifts cleanly to 1. Because $\(\log_2(1) = 0\)$, our non-expressed genes safely remain mapped to a clean numerical zero.


## Output
```bash
--- Log2 Transformed Counts (with +1 Pseudocount) ---
        Control_1  Control_2  Treated_1  Treated_2
Gene_A       6.92       6.86       8.41       8.48
Gene_B       0.00       2.58       0.00       1.58
Gene_C       0.00       3.70       3.17       3.46
Gene_D       8.82       8.85       8.91       8.89
```

- Tracing `Gene_A` in `Control_1`:
The raw count was 120.
The script added the +1 pseudocount to get `121`.
$\(\log_2(121) \approx \mathbf{6.92}\)$.
- Tracing the Cleaned Dropouts (`Gene_B` in `Treated_1` & `Gene_C` in `Control_1`):
Both originally held an empty `NaN` string.
The `.fillna(0)` method converted them to `0`.
The +1 step shifted them to `1`.
$\(\log_2(1) = \mathbf{0.00}\)$.
The technical missing data points have been safely converted into clean numerical baselines ready for statistical comparison.


























