import numpy as np

# 1. Row labels representing specific genes
gene_names = np.array(["BRCA1", "TP53", "EGFR", "MYC", "IL6", "GAPDH"])

# 2. Columns: [Log2 Fold-Change, p-value]
# Fold-change shows direction/magnitude of change. p-value shows statistical significance.
expression_data = np.array([
    [ 2.5,  0.01],  # BRCA1: Highly up-regulated, significant
    [-0.4,  0.64],  # TP53:  No real change, not significant
    [ 3.1,  0.08],  # EGFR:  High change, but NOT significant (high noise)
    [-2.1,  0.002], # MYC:   Highly down-regulated, highly significant
    [ 0.1,  0.03],  # IL6:   Significant, but basically no change in level
    [-0.2,  0.89]   # GAPDH: Housekeeping gene (stable, controls baseline)
])

# 3. Create independent masks for our scientific criteria
# We use np.abs() because we care about both huge increases (+2) and huge decreases (-2)
fold_change_mask = np.abs(expression_data[:, 0]) >= 2.0
significance_mask = expression_data[:, 1] < 0.05

# 4. Combine masks using the element-wise AND operator (&)
combined_mask = fold_change_mask & significance_mask

# 5. Extract the matching gene names and their data using the mask
filtered_genes = gene_names[combined_mask]
filtered_data = expression_data[combined_mask]

print("--- Filtering Summary ---")
print(f"Total Genes Analyzed: {len(gene_names)}")
print(f"Pass Filter Mask: {combined_mask}")
print(f"Significantly Altered Genes: {filtered_genes}")
print("\n--- Extracted Data Matrix ([Fold-Change, p-value]) ---")
print(filtered_data)
