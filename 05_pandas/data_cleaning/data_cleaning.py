import pandas as pd
import numpy as np

# 2. Data Cleaning in Omics ========================
# DataFrame with missing values and zeros
dirty_data = {
    "Control_1": [120, 0, np.nan, 450],
    "Control_2": [115, 5, 12, 460],
    "Treated_1": [340, np.nan, 8, 480],
    "Treated_2": [355, 2, 10, 475]
}

genes = ["Gene_A", "Gene_B", "Gene_C", "Gene_D"]
df_counts = pd.DataFrame(dirty_data, index=genes)

# A. Identifying Missing Values
print("Missing Values per Column:\n", df_counts.isna().sum())

# B. Impute missing counts with zero or drop non-quantified rows
df_cleaned = df_counts.fillna(0)  

# C. Add Pseudocount (+1) to avoid log2(0) error
df_log2 = np.log2(df_cleaned + 1)

print("\n--- Log2 Transformed Counts (with +1 Pseudocount) ---")
print(np.round(df_log2, 2))