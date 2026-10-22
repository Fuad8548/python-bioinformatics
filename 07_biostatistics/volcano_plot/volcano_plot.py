import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from statsmodels.stats.multitest import multipletests

def generate_differential_expression_data(n_genes: int = 1000) -> pd.DataFrame:
    """Simulates a differential gene expression study with biological signals."""
    np.random.seed(101)
    
    # 1. Simulate true biological effect sizes (Log2 Fold Changes)
    # Most genes show 0 change. A few are highly upregulated or downregulated.
    log2fc = np.random.normal(loc=0, scale=0.8, size=n_genes)
    
    # 2. Simulate raw p-values correlated with their true effect size
    # Large changes produce small p-values; no change produces random uniform p-values
    base_noise = np.random.uniform(0, 1, n_genes)
    signal_strength = np.exp(-np.abs(log2fc) * 3)  # Large absolute log2fc drops the p-value
    raw_pvals = np.clip(base_noise * signal_strength, 1e-10, 1.0)
    
    # 3. Apply Benjamini-Hochberg Multiple Testing Correction
    _, qvals, _, _ = multipletests(raw_pvals, alpha=0.05, method="fdr_bh")
    
    # 4. Compile into a standard genomic DataFrame
    df = pd.DataFrame({
        "Gene": [f"Gene_{i}" for i in range(n_genes)],
        "Log2FC": log2fc,
        "pvalue": raw_pvals,
        "FDR_qvalue": qvals
    })
    
    # Calculate visual transformations
    df["neg_log10_q"] = -np.log10(df["FDR_qvalue"])
    
    # 5. Classify genes based on thresholds
    # Thresholds: |Log2FC| > 1 (2x change) AND FDR q-value < 0.05 (neg_log10_q > 1.3)
    df["Status"] = "Not Significant"
    df.loc[(df["Log2FC"] >= 1.0) & (df["FDR_qvalue"] < 0.05), "Status"] = "Upregulated"
    df.loc[(df["Log2FC"] <= -1.0) & (df["FDR_qvalue"] < 0.05), "Status"] = "Downregulated"
    
    return df

if __name__ == "__main__":
    df_expression = generate_differential_expression_data()
    
    # Plotting the Volcano Plot
    plt.figure(figsize=(9, 7))
    sns.set_theme(style="whitegrid")
    
    # Custom color palette matching genomic software standards
    color_map = {
        "Upregulated": "#de2d26",      # Red
        "Downregulated": "#3182bd",    # Blue
        "Not Significant": "#969696"   # Grey
    }
    
    sns.scatterplot(
        data=df_expression, x="Log2FC", y="neg_log10_q", 
        hue="Status", palette=color_map, alpha=0.7, edgecolor="none", s=25
    )
    
    # Add target cutoff thresholds as dashed guidelines
    plt.axhline(y=-np.log10(0.05), color="black", linestyle="--", linewidth=1, label="FDR q = 0.05")
    plt.axvline(x=1.0, color="black", linestyle=":", linewidth=1, label="|Log2FC| = 1.0")
    plt.axvline(x=-1.0, color="black", linestyle=":", linewidth=1)
    
    plt.title("Differential Gene Expression Analysis (Volcano Plot)", fontsize=14, weight="bold")
    plt.xlabel("Log2 Fold Change (Biological Effect Size)", fontsize=12)
    plt.ylabel("-Log10 Adjusted p-value (Statistical Stringency)", fontsize=12)
    plt.legend(loc="upper center", bbox_to_anchor=(0.5, -0.15), ncol=4)

    
    plt.tight_layout()
    plt.show()
    
    # Print summary metrics
    print(df_expression["Status"].value_counts())
