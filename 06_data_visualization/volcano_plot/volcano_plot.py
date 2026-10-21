import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from adjustText import adjust_text  # Run pip install adjustText first!

def generate_volcano_plot(
    df: pd.DataFrame, 
    log2fc_col: str = "log2FoldChange", 
    p_col: str = "pvalue", 
    gene_col: str = "GeneSymbol",
    fc_cutoff: float = 1.5, 
    p_cutoff: float = 0.05,
    save_path: str = None  # Added save parameter
):
    """
    Generates a publication-ready Volcano Plot for Differential Expression Analysis.
    """
    data = df.copy()
    data["neg_log10_p"] = -np.log10(data[p_col])
    
    # Categorize genes
    data["Group"] = "Not Significant"
    data.loc[(data[log2fc_col] >= fc_cutoff) & (data[p_col] < p_cutoff), "Group"] = "Up-regulated"
    data.loc[(data[log2fc_col] <= -fc_cutoff) & (data[p_col] < p_cutoff), "Group"] = "Down-regulated"
    
    plt.figure(figsize=(9, 7), dpi=300)
    
    colors = {
        "Not Significant": "#A0A0A0", 
        "Up-regulated": "#E41A1C", 
        "Down-regulated": "#377EB8"
    }
    
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
    plt.axvline(x=fc_cutoff, color="black", linestyle="--", linewidth=1, alpha=0.5)
    plt.axvline(x=-fc_cutoff, color="black", linestyle="--", linewidth=1, alpha=0.5)
    plt.axhline(y=-np.log10(p_cutoff), color="black", linestyle="--", linewidth=1, alpha=0.5)
    
    # MODIFICATION: Smart-labeling using adjustText to prevent overlapping text
    top_genes = data[(data["Group"] != "Not Significant")].sort_values(by=p_col).head(5)
    texts = []
    for _, row in top_genes.iterrows():
        texts.append(
            plt.text(
                row[log2fc_col], 
                row["neg_log10_p"], 
                str(row[gene_col]), 
                fontsize=9, 
                fontweight="bold"
            )
        )
    # Automatically push labels away from each other and points
    if texts:
        adjust_text(texts, arrowprops=dict(arrowstyle="-", color='black', lw=0.5))
        
    plt.xlabel(r"$\log_2$ Fold Change", fontsize=12, fontweight="bold")
    plt.ylabel(r"$-\log_{10}$ ($p$-value)", fontsize=12, fontweight="bold")
    plt.title("Differential Gene Expression Analysis", fontsize=14, fontweight="bold")
    plt.legend(loc="upper right", frameon=True)
    plt.tight_layout()
    
    # MODIFICATION: Code snippet to save the figure
    if save_path:
        # bbox_inches="tight" ensures labels don't get cropped out at the edges
        plt.savefig(save_path, dpi=300, bbox_inches="tight")
        print(f"Plot successfully saved to: {save_path}")
        
    plt.show()

if __name__ == "__main__":
    np.random.seed(42)
    n = 1000
    mock_df = pd.DataFrame({
        "GeneSymbol": [f"Gene_{i}" for i in range(1, n + 1)],
        "log2FoldChange": np.random.normal(0, 1.2, n),
        "pvalue": np.random.uniform(0.00001, 1, n)
    })
    
    # Pass your filename/path here (.png, .pdf, or .svg for vector formats)
    generate_volcano_plot(mock_df, save_path="volcano_plot.png")
