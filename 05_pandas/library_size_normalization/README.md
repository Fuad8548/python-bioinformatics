# 4. Biological Datasets (`biological_datasets/`)
This section targets a foundational rule of sequencing data analysis: you cannot directly compare raw sequence counts between different experimental samples. This script uses vectorized matrix division to transform raw sequencing counts into a standardized, universally comparable metric. 
Processing an RNA-seq count matrix to calculate CPM (Counts Per Million) and TPM (Transcripts Per Million) normalization metrics.
**Counts Per Million (CPM) Formula**
$\text{CPM}_{i, j} = \frac{C_{i, j}}{\sum_{i} C_{i, j}} \times 10^6$
Where $C_{i, j}$ is the raw read count for gene $i$ in sample $j$.


## Part A: Computing Total Library Sizes
- Summing Along the Rows (`axis=0`): The `.sum(axis=0)` function directs Pandas to slide down each column vertically, adding up the raw integer counts of every single gene detected for that sample.
- Storing Sample Totals (`library_sizes`): This operation creates a single-dimensional Series containing the total sequencing depth of each pool:
  - Sample_1 Total: $\(1500 + 0 + 8000 + 250 = \mathbf{9,750}\)$
  - Sample_2 Total: $\(1650 + 10 + 8200 + 210 = \mathbf{10,070}\)$
  - Sample_3 Total: $\(1200 + 5 + 9500 + 300 = \mathbf{11,005}\)$


**Why It Matters in Bioinformatics**
The sum of all reads in a sample is called its Library Size.
When processing samples on a sequencing machine, individual samples naturally receive slightly different amounts of total reads due to minor pipetting variation or uneven clustering. If Sample 3 randomly generates 1,000 more reads than Sample 1 simply due to technical variance, every gene in Sample 3 will look artificially higher. You must calculate these column totals to track the unique "depth footprint" of each sample before fixing the bias.


## Part B: The Vectorized CPM Broadcast Division
```python
# Calculate CPM matrix
cpm_matrix = raw_counts.divide(library_sizes, axis=1) * 1e6
```

- Sideways Matrix Division (`.divide(..., axis=1)`): This line utilizes a core data-science technique called broadcasting. Instead of utilizing slow loops to divide each individual cell manually, Pandas divides every row value in `Sample_1` by the `Sample_1` sum, every value in `Sample_2` by the `Sample_2` sum, and so forth. Setting `axis=1` ensures the 1D series of library totals aligns perfectly along the columns.
• Scaling to Parts-Per-Million (`* 1e6`): Dividing a small gene count by a massive library size yields tiny, hard-to-read decimals (e.g., 0.0256). Multiplying by one million (10⁶ or 1e6) scales the numbers up, converting them into the number of reads you would find if every sample was sequenced to an identical depth of exactly 1 million reads.


**Why It Matters in Bioinformatics**
Counts Per Million (CPM) is the most common way to eliminate technical variance caused by differing sequence run depths. Once values are converted to CPM, we can safely look across different samples to track real biological shifts in expression, knowing that any background technical imbalances have been neutralized.


## Output
```bash
--- Raw Read Counts ---
       Sample_1  Sample_2  Sample_3
GAPDH      1500      1650      1200
MYC           0        10         5
ACTB       8000      8200      9500
TP53        250       210       300

--- Normalized Counts Per Million (CPM) ---
        Sample_1   Sample_2   Sample_3
GAPDH  153846.15  163853.03  109041.34
MYC         0.00     993.05     454.34
ACTB   820512.82  814299.90  863243.98
TP53    25641.03   20854.02   27260.34
```

• The Fallacy of GAPDH Raw Data: Look at GAPDH across Sample_1 (1500) and Sample_2 (1650). It looks like the expression jumped in Sample 2. However, looking at the CPM values, their normalized abundances are nearly identical (153,846.15 vs 163,853.03). The raw increase was just a technical artifact of Sample 2 having more total sequences.
• The Correction of TP53 Data: In raw counts, Sample_3 (300) looks significantly higher than Sample_1 (250). However, once corrected for the fact that Sample 3 had a much larger total library pool, its CPM (27,260.34) is shown to be highly comparable to Sample 1's CPM (25,641.03).


**Exact Math Walkthrough for TP53 in Sample_1:**

$\(\text{CPM}=\left(\frac{\text{Raw\ Gene\ Count}}{\text{Total\ Library\ Size\ for\ that\ Sample}}\right)\times 1,000,000\)$
$\(\text{CPM}=\left(\frac{250}{9750}\right)\times 1,000,000\approx 0.025641025\times 1,000,000=\mathbf{25,641.03}\)$









