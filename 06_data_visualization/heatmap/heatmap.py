import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

def generate_clustered_heatmap(
    df_counts: pd.DataFrame, 
    sample_groups: dict = None, 
    top_n_genes: int = 30,
    save_path: str = None
):
    """
    Filters for top variable genes, performs Z-score normalization, 
    and generates a publication-ready Clustered Heatmap with sample legends.
    """
    # 1. MODIFICATION: Calculate variance and filter for top N variable genes
    # Essential for actual biological datasets to filter out unchanging genes
    gene_variances = df_counts.var(axis=1)
    top_genes = gene_variances.nlargest(top_n_genes).index
    filtered_df = df_counts.loc[top_genes]
    
    # 2. Row-wise Z-score transformation
    scaled_df = filtered_df.apply(lambda row: (row - row.mean()) / row.std(), axis=1)
    
    # 3. MODIFICATION: Add Sample Group color track with fixed indexing alignment
    col_colors = None
    legend_patches = []
    if sample_groups:
        unique_groups = sorted(list(set(sample_groups.values())))
        palette = sns.color_palette("Set2", len(unique_groups))
        group_to_color = dict(zip(unique_groups, palette))
        
        # Build the color mapping aligned strictly with the data columns
        col_colors = pd.Series(scaled_df.columns.map(sample_groups), index=scaled_df.columns).map(group_to_color)
        
        # Create legend elements for the groups
        for group, color in group_to_color.items():
            legend_patches.append(mpatches.Patch(color=color, label=group))

    # 4. Plot Clustered Heatmap
    g = sns.clustermap(
        scaled_df,
        method="ward",            # Hierarchical clustering linkage method
        metric="euclidean",       # Distance metric
        cmap="vlag",              # Diverging colormap (Blue = Low, Red = High)
        z_score=None,             
        col_colors=col_colors,
        figsize=(10, 8),
        linewidths=0.5,
        cbar_kws={"label": "Z-Score"}
    )
    
    # Add title with dynamic adjustments to prevent overlap with the dendrogram
    g.fig.suptitle(f"Hierarchical Clustering of Top {top_n_genes} Variable Genes", 
                   fontsize=14, fontweight="bold", y=1.02)
    
    # 5. MODIFICATION: Add the missing sample group legend to the figure layout
    if legend_patches:
        # Places the legend box neatly in the top-right open area of the layout
        g.fig.legend(handles=legend_patches, title="Sample Groups", 
                     loc="upper right", bbox_to_anchor=(0.98, 0.95), frameon=True)

    # 6. MODIFICATION: Add high-resolution image saving engine
    if save_path:
        g.savefig(save_path, dpi=300, bbox_inches="tight")
        print(f"Heatmap successfully saved to: {save_path}")
        
    plt.show()

# Example Usage
if __name__ == "__main__":
    np.random.seed(42)
    # Simulating a dataset with 100 total genes to verify the filtering feature
    genes = [f"Gene_{i}" for i in range(1, 101)]
    samples = [f"Control_{i}" for i in range(1, 5)] + [f"Treated_{i}" for i in range(1, 5)]
    
    # Mock data generation
    data = np.random.randn(100, 8)
    data[:25, 4:] += 3.0  # Induce strong variation in a block of genes
    
    counts_df = pd.DataFrame(data, index=genes, columns=samples)
    groups = {s: "Control" if "Control" in s else "Treated" for s in samples}
    
    # Execute function and save a production-ready file
    generate_clustered_heatmap(counts_df, sample_groups=groups, top_n_genes=30, save_path="clustered_heatmap.png")
