import numpy as np
import pandas as pd
from scipy import stats

def compare_gene_expression(group_a: np.ndarray, group_b: np.ndarray) -> dict:
    """
    Performs normality testing, homoscedasticity testing, and appropriate t-test.
    """
    # 1. Normality test (Shapiro-Wilk)
    _, p_norm_a = stats.shapiro(group_a)
    _, p_norm_b = stats.shapiro(group_b)
    
    # 2. Variance homogeneity test (Levene's Test)
    _, p_var = stats.levene(group_a, group_b)
    
    # 3. Two-sample t-test (Welch's if variances are unequal)
    equal_var = p_var > 0.05
    t_stat, p_val = stats.ttest_ind(group_a, group_b, equal_var=equal_var)
    
    # 4. Non-parametric alternative (Mann-Whitney U) if normality fails
    u_stat, p_val_mannwhitney = stats.mannwhitneyu(group_a, group_b)
    
    return {
        "Mean_A": np.mean(group_a),
        "Mean_B": np.mean(group_b),
        "Levene_p_value": p_var,
        "Equal_Variance_Assumed": equal_var,
        "t_statistic": t_stat,
        "t_test_p_value": p_val,
        "Mann_Whitney_p_value": p_val_mannwhitney
    }

# Example Usage
if __name__ == "__main__":
    np.random.seed(42)
    control_counts = np.random.normal(loc=12.5, scale=1.5, size=10)
    treated_counts = np.random.normal(loc=18.2, scale=3.0, size=10)
    
    results = compare_gene_expression(control_counts, treated_counts)
    for k, v in results.items():
        print(f"{k}: {v:.4f}" if isinstance(v, float) else f"{k}: {v}")