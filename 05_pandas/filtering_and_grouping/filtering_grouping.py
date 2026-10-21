from create_dataframes import df

# 3. Boolean filtering for Differentially Expressed Genes (DEGs) ==========================
log2fc_threshold = 1.5
p_threshold = 0.01

# Condition 1: Significantly Up-regulated
up_regulated = df[(df["log2FoldChange"] >= log2fc_threshold) & (df["pvalue"] < p_threshold)]

# Condition 2: Significantly Down-regulated
down_regulated = df[(df["log2FoldChange"] <= -log2fc_threshold) & (df["pvalue"] < p_threshold)]

print(f"Up-regulated genes: {len(up_regulated)}")
print(f"Down-regulated genes: {len(down_regulated)}")


# Chromosome-wise Grouping and Aggregation (groupby)
# Compute median expression and total genes per chromosome
chrom_summary = df.groupby("Chromosome").agg(
    GeneCount=("GeneSymbol", "count"),
    MeanBaseMean=("BaseMean", "mean"),
    MaxLog2FC=("log2FoldChange", "max")
)

print("\n--- Chromosome Aggregate Metrics ---")
print(chrom_summary)
