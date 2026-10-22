import pandas as pd
from scipy import stats
from statsmodels.stats.multicomp import pairwise_tukeyhsd

# Mock dataset across 3 treatment groups
data = pd.DataFrame({
    "Expression": [10.2, 11.1, 10.8, 15.4, 16.1, 15.8, 22.1, 21.5, 23.0],
    "Group": ["Control", "Control", "Control", "Low_Dose", "Low_Dose", "Low_Dose", "High_Dose", "High_Dose", "High_Dose"]
})

# 1. One-way ANOVA
ctrl = data[data["Group"] == "Control"]["Expression"]
low = data[data["Group"] == "Low_Dose"]["Expression"]
high = data[data["Group"] == "High_Dose"]["Expression"]

f_stat, p_val_anova = stats.f_oneway(ctrl, low, high)
print(f"One-way ANOVA F-statistic: {f_stat:.3f}, p-value: {p_val_anova:.2e}")

# 2. Post-hoc Tukey HSD Test
if p_val_anova < 0.05:
    tukey = pairwise_tukeyhsd(endog=data["Expression"], groups=data["Group"], alpha=0.05)
    print("\n--- Tukey HSD Post-Hoc Comparison ---")
    print(tukey)