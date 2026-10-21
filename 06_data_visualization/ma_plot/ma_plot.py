import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

def generate_ma_plot(
    df: pd.DataFrame, 
    base_mean_col: str = "baseMean", 
    log2fc_col: str = "log2FoldChange", 
    p_col: str = "pvalue",
    p_cutoff: float = 0.05,
    save_path: str = None
):
    """
    Generates a publication-ready MA Plot for RNA-seq Differential Expression Analysis.
    df: Dataframe containing gene abundance metrics, log2FC, and p-values.
    """
    data = df.copy()
    
    # 1. BIOLOGICAL CRITICAL STEP: Filter out genes with zero expression 
    # Log scales break down mathematically if an expression value is 0.
    data = data[data[base_mean_col] > 0]
    
    # 2. Segment points into Significant vs Not Significant based on p-value
    significant = data[data[p_col] < p_cutoff]
    not_significant = data[data[p_col] >= p_cutoff]
    
    # Setup high-resolution figure canvas
    plt.figure(figsize=(9, 6), dpi=300)
    
    # 3. Scatter plot layer 1: Plot background (non-significant genes) in gray
    plt.scatter(
        not_significant[base_mean_col], 
        not_significant[log2fc_col], 
        c="#A0A0A0", 
        alpha=0.4, 
        s=10, 
        label=f"Not Significant (p >= {p_cutoff})"
    )
    
    # Scatter plot layer 2: Plot foreground (statistically altered genes) in red
    plt.scatter(
        significant[base_mean_col], 
        significant[log2fc_col], 
        c="#E41A1C", 
        alpha=0.7, 
        s=12, 
        label=f"Significant (p < {p_cutoff}, n={len(significant)})"
    )
    
    # 4. Standard horizontal line at Log2FC = 0 (baseline where nothing changes)
    plt.axhline(y=0, color="black", linestyle="-", linewidth=1, alpha=0.6)
    
    # Optional guide lines tracking standard 1.5 fold change levels
    plt.axhline(y=1.5, color="gray", linestyle="--", linewidth=0.8, alpha=0.5)
    plt.axhline(y=-1.5, color="gray", linestyle="--", linewidth=0.8, alpha=0.5)
    
    # 5. MATHEMATICAL SCALE AXIS TWEAK: Set X-axis to logarithmic base 10 scale
    # Raw abundance spreads from 1 to over 100,000. A log scale keeps it clean.
    plt.xscale('log')
    
    # Labels and production design
    plt.xlabel("Mean of Expression Across Samples (BaseMean)", fontsize=12, fontweight="bold")
    plt.ylabel(r"$\log_2$ Fold Change", fontsize=12, fontweight="bold")
    plt.title("MA Plot: Gene Expression Changes vs Mean Abundance", fontsize=14, fontweight="bold", pad=15)
    
    # Position the legend safely inside the plot layout
    plt.legend(loc="upper right", frameon=True, facecolor="white", edgecolor="none")
    plt.grid(True, which="both", linestyle="--", alpha=0.3)
    plt.tight_layout()
    
    # 6. File exporter engine
    if save_path:
        plt.savefig(save_path, dpi=300, bbox_inches="tight")
        print(f"MA Plot safely written to disk at: {save_path}")
        
    plt.show()

# Example Usage
if __name__ == "__main__":
    np.random.seed(42)
    n_genes = 5000
    
    # Simulate a typical logarithmic gene abundance distribution (baseMean)
    mock_base_mean = np.exp(np.random.uniform(0, 10, n_genes))
    
    # Low-abundance genes naturally have higher experimental noise/variance in log2FC
    mock_log2fc = np.random.normal(loc=0, scale=2.5 / (np.log1p(mock_base_mean)), size=n_genes)
    
    # Randomly inject artificially induced biological alterations to test the code
    altered_indices = np.random.choice(n_genes, size=400, replace=False)
    mock_log2fc[altered_indices] += np.random.choice([-3, 3], size=400)
    
    # Assign p-values (smaller p-values matching our altered indices)
    mock_pvalues = np.random.uniform(0.06, 1.0, n_genes)
    mock_pvalues[altered_indices] = np.random.uniform(0.00001, 0.049, 400)
    
    # Format into a classic DESeq2-style DataFrame structure
    rnaseq_data = pd.DataFrame({
        "baseMean": mock_base_mean,
        "log2FoldChange": mock_log2fc,
        "pvalue": mock_pvalues
    })
    
    # Run and generate visual file
    generate_ma_plot(rnaseq_data, save_path="ma_plot.png")
