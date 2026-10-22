import numpy as np
import pandas as pd
from statsmodels.stats.multitest import multipletests

def adjust_pvalues_bh(pvalues: list[float], alpha: float = 0.05) -> pd.DataFrame:
    """
    Applies Benjamini-Hochberg (FDR) multiple testing correction to a list of p-values.
    """
    p_arr = np.array(pvalues)
    
    # Using statsmodels multipletests
    reject, qvalues, _, _ = multipletests(p_arr, alpha=alpha, method="fdr_bh")
    
    df_results = pd.DataFrame({
        "Raw_pvalue": p_arr,
        "FDR_qvalue": qvalues,
        "Significant": reject
    })
    
    return df_results.sort_values(by="Raw_pvalue")

# Example Usage
if __name__ == "__main__":
    np.random.seed(42)
    # Simulate 1,000 p-values (mostly null, a few true signal)
    null_pvals = np.random.uniform(0, 1, 950)
    signal_pvals = np.random.exponential(scale=0.01, size=50)
    signal_pvals = np.clip(signal_pvals, 1e-6, 0.05)
    
    all_pvals = np.concatenate([null_pvals, signal_pvals])
    
    results_df = adjust_pvalues_bh(all_pvals)
    
    raw_sig = (all_pvals < 0.05).sum()
    fdr_sig = results_df["Significant"].sum()
    
    print(f"Total Genes Tested: {len(all_pvals)}")
    print(f"Significant at raw p < 0.05 (Uncorrected): {raw_sig}")
    print(f"Significant at FDR q < 0.05 (Benjamini-Hochberg): {fdr_sig}")