import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

def generate_high_dimensional_genomics() -> tuple[pd.DataFrame, list[str]]:
    """Simulates an expression matrix: 30 samples (rows) x 5000 genes (columns)."""
    np.random.seed(88)
    n_samples_per_group = 10
    n_genes = 5000
    
    # Define groups
    groups = (["Control"] * n_samples_per_group + 
              ["Treatment_A"] * n_samples_per_group + 
              ["Treatment_B"] * n_samples_per_group)
    
    # 1. Base random expression matrix (Noise baseline)
    matrix = np.random.normal(loc=8.0, scale=1.5, size=(30, n_genes))
    
    # 2. Inject distinct biological signals into specific gene subsets
    # Treatment A upregulates genes 0-500
    matrix[10:20, 0:500] += np.random.normal(loc=2.5, scale=0.5, size=(10, 500))
    # Treatment B downregulates genes 4000-4500
    matrix[20:30, 4000:4500] -= np.random.normal(loc=3.0, scale=0.5, size=(10, 500))
    
    gene_names = [f"Gene_{i}" for i in range(n_genes)]
    df_expr = pd.DataFrame(matrix, columns=gene_names)
    
    return df_expr, groups

if __name__ == "__main__":
    # Load expression matrix and metadata labels
    X, sample_groups = generate_high_dimensional_genomics()
    
    # Step A: Standard Scaling (Critical Step for PCA)
    # Scales each column (gene) to mean=0, variance=1
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    # Step B: Instantiate and Fit PCA
    # We explicitly extract the first 2 principal components
    pca = PCA(n_components=2)
    X_pca = pca.fit_transform(X_scaled)
    
    # Step C: Structure coordinates into a clean plotting DataFrame
    df_pca = pd.DataFrame(data=X_pca, columns=["PC1", "PC2"])
    df_pca["Cohort"] = sample_groups
    
    # Step D: Harvest the Explained Variance Ratio
    explained_variance = pca.explained_variance_ratio_
    pc1_var = explained_variance[0] * 100
    pc2_var = explained_variance[1] * 100
    
    # Step E: Visualize the Low-Dimensional Space
    plt.figure(figsize=(8, 6))
    sns.set_theme(style="whitegrid")
    
    sns.scatterplot(
        data=df_pca, x="PC1", y="PC2", hue="Cohort",
        palette=["#3182bd", "#de2d26", "#31a354"], s=100, alpha=0.9, edgecolor="black"
    )
    
    # Label axes dynamically with their respective variance percentages
    plt.title("Genomic Sample Clustering via PCA", fontsize=14, weight="bold")
    plt.xlabel(f"PC1 ({pc1_var:.2f}% Variance Explained)", fontsize=12)
    plt.ylabel(f"PC2 ({pc2_var:.2f}% Variance Explained)", fontsize=12)
    plt.legend(title="Biological Condition", loc="best")
    
    plt.tight_layout()
    plt.show()
    
    print(f"Total variance captured by first 2 components: {sum(explained_variance)*100:.2f}%")
