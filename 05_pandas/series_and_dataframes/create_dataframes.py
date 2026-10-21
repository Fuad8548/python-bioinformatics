import pandas as pd
import numpy as np

# 1. Constructing a DataFrame from a Dictionary
gene_data = {
    "GeneSymbol": ["TP53", "BRCA1", "EGFR", "MYC", "GAPDH"],
    "Chromosome": ["chr17", "chr17", "chr7", "chr8", "chr12"],
    "BaseMean": [1420.5, 890.2, 3400.8, 510.0, 12500.4],
    "log2FoldChange": [2.35, -1.82, 0.12, 3.45, -0.05],
    "pvalue": [0.0001, 0.0023, 0.6500, 0.00001, 0.8900]
}

# Set custom index using Gene IDs
gene_ids = ["ENSG00000141510", "ENSG00000012048", "ENSG00000146648", "ENSG00000136997", "ENSG00000111640"]
df = pd.DataFrame(gene_data, index=gene_ids)
df.index.name = "GeneID"

print("--- Initial RNA-seq DataFrame ---")
print(df)

# Select specific gene row by ID and columns using .loc
tp53_info = df.loc["ENSG00000141510", ["GeneSymbol", "log2FoldChange", "pvalue"]]
print("\n--- TP53 Metadata (.loc) ---")
print(tp53_info)

# Select first 3 rows and first 2 columns using .iloc
sub_matrix = df.iloc[0:3, 0:2]
print("\n--- Sub-matrix Slice (.iloc) ---")
print(sub_matrix)

















































