# CSV and TSV Data Processing

Tab-Separated Value (TSV) and Comma-Separated Value (CSV) formats hold experimental metadata, count matrices, and differential expression outputs.

## Standard Library Parsing
The Python `csv` module efficiently handles custom delimiters, quotes, and structural parsing.

```python
import csv
# Reading TSV sample metadata
metadata = {}
with open("./samples.tsv", mode="r", newline="") as tsv_file:
    reader = csv.DictReader(tsv_file, delimiter="\t")
    for row in reader:
        sample_id = row["ID_REF"]
        metadata[sample_id] = {
            "condition": row["Ctrl_1"],
            "batch": row["BRCA1_1"]
        }

print(metadata)
```

## High-Performance Processing with Pandas
For large gene expression tables, `pandas` allows vectorized operations, filtering, and missing value handling.

```python
import pandas as pd
import numpy as np

# Read gene counts (TSV format)
df = pd.read_csv("samples.tsv", sep="\t", index_col="ID")

# Filter out low-expressed genes (sum across all samples < 10)
filtered_df = df[df.sum(axis=1) >= 10]    #  It throws away any gene that has a total sum of less than 10 reads

# Calculate log2 TPM/ CPM normalization (simplified example)
cpm = filtered_df.divide(filtered_df.sum(axis=0), axis=1) * 1e6   # filtered_df.sum(axis=0) counts the total number of reads in each individual sample column.
# .divide(..., axis=1) divides each gene's count by its sample's total count. This gives a proportion.
# * 1e6 multiplies that proportion by 1 million (10⁶). This converts the values into Counts Per Million (CPM).

log2_cpm = (cpm + 1).apply(np.log2)
# Gene expression data often has a few genes with massive values (e.g., 50,000 CPM) and many with small values (e.g., 5 CPM). Taking the log squishes this massive range down, making it much easier to graph and analyze statistically.
# cpm + 1: You cannot calculate the logarithm of zero (\(\log_2(0)\) is undefined). Adding 1 ensures that a count of 0 CPM safely becomes \(\log_2(1) = 0\), avoiding mathematical crashes.
# .apply(np.log2): Converts all values in the table to a \(\log _{2}\) scale.


# save filtered results
log2_cpm.to_csv("normalized_counts.tsv", sep="\t")
```

































