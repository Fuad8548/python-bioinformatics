import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def generate_volcano_plot(
    df: pd.DataFrame, 
    log2fc_col: str = "log2FoldChange", 
    p_col: str = "pvalue", 
    gene_col: str = "GeneSymbol",
    fc_cutoff: float = 1.5, 
    p_cutoff: float = 0.05
):
    """
    Generates a publication-ready Volcano Plot for Differential Expression Analysis.
    """
    # Create a copy to prevent modifying original data
    data = df.copy()
    
    # Calculate -log10(p-value)
    data["neg_log10_p"] = -np.log10(data[p_col])
    
    # Define gene categories
    data["Group"] = "Not Significant"
    data.loc[(data[log2fc_col] >= fc_cutoff) & (data[p_col] < p_cutoff), "Group"] = "Up-regulated"
    data.loc[(data[log2fc_col] <= -fc_cutoff) & (data[p_col] < p_cutoff), "Group"] = "Down-regulated"
    
    # Setup plot aesthetics
    plt.figure(figsize=(9, 7), dpi=300)
    
    colors = {
        "Not Significant": "#A0A0A0", 
        "Up-regulated": "#E41A1C", 
        "Down-regulated": "#377EB8"
    }
    
    # Scatter plot per group
    for group, color in colors.items():
        subset = data[data["Group"] == group]
        plt.scatter(
            subset[log2fc_col], 
            subset["neg_log10_p"], 
            c=color, 
            label=f"{group} ({len(subset)})", 
            alpha=0.7, 
            s=25, 
            edgecolors='none'
        )
        
    # Threshold lines
    plt.axvline(x=fc_cutoff, color="black", linestyle="--", linewidth=1, alpha=0.7)
    plt.axvline(x=-fc_cutoff, color="black", linestyle="--", linewidth=1, alpha=0.7)
    plt.axhline(y=-np.log10(p_cutoff), color="black", linestyle="--", linewidth=1, alpha=0.7)
    
    # Label top differentially expressed genes
    top_genes = data[(data["Group"] != "Not Significant")].sort_values(by=p_col).head(5)
    for _, row in top_genes.iterrows():
        plt.text(
            row[log2fc_col] + 0.05, 
            row["neg_log10_p"] + 0.1, 
            str(row[gene_col]), 
            fontsize=9, 
            fontweight="bold"
        )
        
    # Labels and formatting
    plt.xlabel(r"$\log_2$ Fold Change", fontsize=12, fontweight="bold")
    plt.ylabel(r"$-\log_{10}$ ($p$-value)", fontsize=12, fontweight="bold")
    plt.title("Differential Gene Expression Analysis", fontsize=14, fontweight="bold")
    plt.legend(loc="upper right", frameon=True)
    plt.tight_layout()
    plt.show()

# Example Usage
if __name__ == "__main__":
    np.random.seed(42)
    n = 1000
    mock_df = pd.DataFrame({
        "GeneSymbol": [f"Gene_{i}" for i in range(1, n + 1)],
        "log2FoldChange": np.random.normal(0, 1.2, n),
        "pvalue": np.random.uniform(0.00001, 1, n)
    })
    generate_volcano_plot(mock_df)