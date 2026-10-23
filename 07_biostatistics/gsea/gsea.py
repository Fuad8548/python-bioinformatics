import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import gseapy as gp

def generate_ranked_genomic_signal() -> pd.DataFrame:
    """Simulates a pre-ranked list of genes sorted by expression score."""
    np.random.seed(42)
    n_genes = 1000
    
    # Simulate a metric combining fold change and p-value sign
    # Highly positive values = highly upregulated, negative = downregulated
    scores = np.random.normal(loc=0.0, scale=2.5, size=n_genes)
    scores = np.sort(scores)[::-1] # Sort descending from top upregulation to downregulation
    
    gene_names = [f"GENE_{i}" for i in range(n_genes)]
    
    df_ranked = pd.DataFrame({
        "Gene": gene_names,
        "Score": scores
    })
    return df_ranked

if __name__ == "__main__":
    # 1. Load your ranked genomics data
    df_ranked_data = generate_ranked_genomic_signal()
    
    # 2. Define a Mock Pathway Database (Simulating MSigDB / Gene Ontology)
    # We define 3 pathways with known gene memberships
    custom_pathways = {
        "CELL_CYCLE_PHASE": [f"GENE_{i}" for i in range(5, 45)],       # Clustered at the very top (Upregulated)
        "APOPTOSIS_PATHWAY": [f"GENE_{i}" for i in range(940, 990)],    # Clustered at the very bottom (Downregulated)
        "RANDOM_NOISE_SET": [f"GENE_{i}" for i in range(200, 800, 15)]  # Scattered randomly across the middle (Null)
    }
    
    # 3. Execute Pre-ranked GSEA
    # Prerank requires a DataFrame with two columns (Gene names, Numeric scores)
    gsea_results = gp.prerank(
        rnk=df_ranked_data,
        gene_sets=custom_pathways,
        permutation_num=100, # Run 100 random permutations for speed (use 1000+ in production)
        outdir=None,         # Do not save files to disk automatically
        seed=42
    )
    
    # 4. Extract metrics into a readable DataFrame
    df_res = gsea_results.res2d.reset_index()
    
    # Dynamically find the p-value column name to prevent KeyError variations
    p_col = [col for col in df_res.columns if 'p-val' in col.lower() or col == 'pval'][0]
    fdr_col = [col for col in df_res.columns if 'fdr' in col.lower() or col == 'fdr'][0]
    
    print("\n--- GSEA Pathway Analysis Results ---")
    print(df_res[["Term", "ES", "NES", p_col, fdr_col]])

