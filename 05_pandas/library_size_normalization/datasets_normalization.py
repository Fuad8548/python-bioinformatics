import pandas as pd
import numpy as np

# 4. Biological Dataset Normalization =====================
# Load raw read count table
raw_counts = pd.DataFrame({
    "Sample_1": [1500, 0, 8000, 250],
    "Sample_2": [1650, 10, 8200, 210],
    "Sample_3": [1200, 5, 9500, 300]
}, index=["GAPDH", "MYC", "ACTB", "TP53"])

# Compute Total Reads per Sample (Column sums)
library_sizes = raw_counts.sum(axis=0)

# Calculate CPM matrix
cpm_matrix = raw_counts.divide(library_sizes, axis=1) * 1e6

print("--- Raw Read Counts ---")
print(raw_counts)
print("\n--- Normalized Counts Per Million (CPM) ---")
print(np.round(cpm_matrix, 2))