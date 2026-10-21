
# 3. Boolean Filtering (DEGs) & Chromosome Grouping
**Volcano Plot Filtering Logic**
This section demonstrates the core analytical phase of a differential expression pipeline. Once genomic data is structured and cleaned, the primary goal is to isolate biologically significant genes and uncover higher-level spatial trends (such as chromosome-wide behaviors). In differential gene expression (DGE) analysis, genes are classified based on effect size ($\text{log2FoldChange}$) and statistical significance ($p_{\text{adj}}$).

## Part A: Boolean Filtering for Differentially Expressed Genes (DEGs)
- Setting Hard Thresholds: We define two statistical cutoffs:
	- `log2fc_threshold = 1.5`: This translates to a $\(\approx 2.8\)$-fold change in actual expression level ($\(2^{1.5}\)$). It filters out genes that only showed tiny, negligible shifts.
	• `p_threshold = 0.01`: This means there is a 1% or lower chance that the observed change happened by pure statistical coincidence.
- Vectorized Boolean Masking: Pandas evaluates conditions across entire columns simultaneously rather than using slow Python loops.
- The Bitwise AND Operator (&): This forces Pandas to check both criteria at once. For a row to pass the filter and make it into the final table, it must have a strong fold-change and a highly significant p-value.

**Why It Matters in Bioinformatics**
A typical RNA-seq run screens over 20,000 human genes. The vast majority of these genes are unaffected background noise. Bioinformaticians use strict multi-conditional filtering to isolate the few key target biomarkers driving a disease process or drug response.
Filtering by fold-change alone is risky because a gene can have a massive change that is highly unstable across replicates (giving a bad p-value). Conversely, filtering only by p-value might yield a gene that is statistically stable but has such a tiny change that it cannot affect cellular biology. We need both conditions met simultaneously.


## Output
```bash
--- Initial RNA-seq DataFrame ---
                
GeneID     GeneSymbol  Chromosome BaseMean log2FC pvalue      

ENSG00000141510       TP53      chr17    1420.5   2.35  0.00010
ENSG00000012048      BRCA1      chr17     890.2  -1.82  0.00230
ENSG00000146648       EGFR       chr7    3400.8   0.12  0.65000
ENSG00000136997        MYC       chr8     510.0   3.45  0.00001
ENSG00000111640      GAPDH      chr12   12500.4  -0.05  0.89000

Up-regulated genes: 2
Down-regulated genes: 1
```
Let’s re-examine our initial dataset row-by-row to see why this happened:
- `TP53`: Log2FC is `2.35` ($\(\ge 1.5\)$) and p-value is `0.0001` ($\(<0.01\)$). It passes both tests. (Counted as **Up-regulated**)
- `MYC`: Log2FC is `3.45` ($\(\ge 1.5\)$) and p-value is `0.00001` ($\(<0.01\)$). It passes both tests. (Counted as **Up-regulated**)
- `BRCA1`: Log2FC is `-1.82` ($\(\le -1.5\)$) and p-value is `0.0023` ($\(<0.01\)$). It passes both tests. (Counted as **Down-regulated**)
- `EGFR`: Log2FC is `0.12` (fails threshold) and p-value is `0.65` (fails significance). It is completely ignored.
- GAPDH: Log2FC is `-0.05` (fails threshold) and p-value is `0.89` (fails significance). It is completely ignored.


## Part B: Chromosome-wise Grouping and Aggregation
- Splitting the Data (`.groupby("Chromosome")`): Pandas temporarily chops the DataFrame into distinct piles based on matching values in the `Chromosome` column (`chr7`, `chr8`, `chr12`, `chr17`).
- Multi-Metric Aggregation (`.agg(...)`): Instead of calculating just one standard metric like a basic mean, we instruct Pandas to run unique, targeted summaries for different data tracks:
	- `GeneCount=("GeneSymbol", "count")`: Count how many total genes belong to each chromosome group.
	- `MeanBaseMean=("BaseMean", "mean")`: Calculate the mathematical average of the baseline expression level for genes in that group.
	- `MaxLog2FC=("log2FoldChange", "max")`: Find the single highest expression surge on that chromosome.


**Why It Matters in Bioinformatics**

Genes do not act in total isolation; their physical architecture on chromosomes plays a massive role in cancer genetics, structural deletions, and gene duplication events. Grouping data by chromosomal location allows bioinformaticians to look at coordinate-scale phenomena. For example, if an entire arm of Chromosome 17 is duplicated in a tumor sample, a `.groupby` operation will instantly expose a uniform surge across all genes mapped to `chr17`.


```bash
--- Chromosome Aggregate Metrics ---
            GeneCount  MeanBaseMean  MaxLog2FC
Chromosome                                    
chr12               1      12500.40      -0.05
chr17               2       1155.35       2.35
chr7                1       3400.80       0.12
chr8                1        510.00       3.45
```

- Analyzing `chr17`: This chromosome has a `GeneCount` of 2 because both `TP53` and `BRCA1` live there. Its `MeanBaseMean` is 1155.35, which is the exact average of their raw base means: (1420.5 + 890.2) / 2. Its `MaxLog2FC` is 2.35 because `TP53` (2.35) had a higher fold change value than BRCA1 (-1.82).

- Analyzing `chr12`: This group captures only our baseline control gene, `GAPDH`. It displays a huge `MeanBaseMean` (12500.40) because housekeeping genes are constantly expressed at massive levels to keep cells alive, but its `MaxLog2FC` sits flat near zero (-0.05), showing **no experimental change**.
















