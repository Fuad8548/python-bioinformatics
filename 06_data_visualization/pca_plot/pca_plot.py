import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler  # NEW: For proper scaling

def generate_pca_plot(
    df_counts: pd.DataFrame, 
    sample_conditions: list[str], 
    save_path: str = None
):
    """
    Computes and plots a standardized 2D PCA for RNA-seq expression matrices.
    df_counts: Rows = Genes, Columns = Samples
    """
    # 1. Transpose matrix so rows = Samples, columns = Genes
    X = df_counts.T.values
    
    # 2. MODIFICATION: Standardize features (mean=0, variance=1)
    # Crucial for biology so high-abundance genes don't overwhelm the math
    X_scaled = StandardScaler().fit_transform(X)
    
    # 3. Fit PCA model
    pca = PCA(n_components=2)
    pca_result = pca.fit_transform(X_scaled)
    
    # Variance explained
    pc1_var = pca.explained_variance_ratio_[0] * 100
    pc2_var = pca.explained_variance_ratio_[1] * 100
    
    # Create DataFrame for plotting
    pca_df = pd.DataFrame({
        "PC1": pca_result[:, 0],
        "PC2": pca_result[:, 1],
        "Condition": sample_conditions,
        "Sample": df_counts.columns
    })
    
    # 4. Plotting
    fig, ax = plt.subplots(figsize=(8, 6), dpi=300)
    sns.scatterplot(
        data=pca_df, 
        x="PC1", 
        y="PC2", 
        hue="Condition", 
        style="Condition", 
        s=140,  # Slightly larger markers
        palette="Set1",
        ax=ax
    )
    
    # MODIFICATION: Dynamic label offsets based on data scale
    # Hardcoded +0.2 breaks if the axis limits shrink or grow wildly
    x_range = pca_df["PC1"].max() - pca_df["PC1"].min()
    y_range = pca_df["PC2"].max() - pca_df["PC2"].min()
    x_offset = x_range * 0.02
    y_offset = y_range * 0.01
    
    for _, row in pca_df.iterrows():
        ax.text(
            row["PC1"] + x_offset, 
            row["PC2"] + y_offset, 
            row["Sample"], 
            fontsize=9, 
            fontweight="semibold"
        )
        
    plt.xlabel(f"PC1 ({pc1_var:.1f}% Variance Explained)", fontsize=12, fontweight="bold")
    plt.ylabel(f"PC2 ({pc2_var:.1f}% Variance Explained)", fontsize=12, fontweight="bold")
    plt.title("Principal Component Analysis (PCA)", fontsize=14, fontweight="bold", pad=15)
    
    plt.grid(True, linestyle="--", alpha=0.5)
    
    # Move legend outside safely
    plt.legend(bbox_to_anchor=(1.02, 1), loc='upper left', borderaxespad=0)
    
    # 5. MODIFICATION: Secure layout configuration & file exporter
    plt.tight_layout()
    
    if save_path:
        # bbox_inches="tight" forces matplotlib to calculate the true boundary,
        # preventing the legend and titles from clipping off-canvas.
        plt.savefig(save_path, dpi=300, bbox_inches="tight")
        print(f"PCA plot successfully saved to: {save_path}")
        
    plt.show()

# Example Usage
if __name__ == "__main__":
    np.random.seed(42)
    
    # 500 genes across 6 samples
    data_ctrl = np.random.normal(loc=10, scale=2, size=(500, 3))
    data_treat = np.random.normal(loc=14, scale=2, size=(500, 3))
    
    data_mat = np.hstack([data_ctrl, data_treat])
    sample_names = ["Ctrl_1", "Ctrl_2", "Ctrl_3", "Treat_1", "Treat_2", "Treat_3"]
    conditions = ["Control", "Control", "Control", "Treated", "Treated", "Treated"]
    
    expression_df = pd.DataFrame(data_mat, columns=sample_names)
    generate_pca_plot(expression_df, conditions, save_path="pca_plot.png")
