High-throughput biological experiments generate massive datasets subject to biological noise, batch effects, and high-dimensional variance. Applying rigorous statistical methods allows bioinformaticians to separate genuine biological signals from technical noise, evaluate statistical confidence, and control false discovery rates across thousands of parallel hypothesis tests.

## 1. The Foundations of Biostatistical Testing
When comparing two groups, our baseline assumption is the Null Hypothesis ($\(H_{0}\)$): There is no difference in gene expression between Group A and Group B. Our goal is to see if we have enough mathematical evidence to reject $\(H_{0}\)$ in favor of the Alternative Hypothesis ($\(H_{1}\)$): There is a significant difference.

To choose the right test, statisticians divide methods into two categories based on data behavior:
1. Parametric Tests (t-test): These are highly powerful tests, but they carry strict requirements. They assume the data is normally distributed (bell-curved) and that both groups have roughly the same amount of variation (homoscedasticity).
2. Non-Parametric Tests (Mann-Whitney U): These are backup tests used when data is messy, skewed, or has extreme outliers. Instead of comparing the actual measurement values (means), they rank the data from smallest to largest and compare the order (medians).

Running a t-test on data that violates these rules can lead to false positives (Type I errors) or missed discoveries (Type II errors).

## 2. Setting up the Experiment
```python
if __name__ == "__main__":
    np.random.seed(42)
    control_counts = np.random.normal(loc=12.5, scale=1.5, size=10)
    treated_counts = np.random.normal(loc=18.2, scale=3.0, size=10)
```
- `np.random.seed(42)`: This ensures that every time we run this script, it generates the exact same "random" numbers. This is critical in bioinformatics for reproducibility.
- `control_counts`: This simulates data for 10 control samples (size=10). It draws numbers from a normal distribution where the true biological average expression is 12.5 (loc=12.5) and the natural standard deviation/variation is 1.5 (scale=1.5).
- `treated_counts`: This simulates data for 10 treated samples. Notice that the mean is higher (18.2) and it is twice as volatile/variable (scale=3.0). This mimics a real drug treatment where some samples respond heavily and others do not, creating unequal variance.

## 3. The Testing Pipeline
```python
    # 1. Normality test (Shapiro-Wilk)
    _, p_norm_a = stats.shapiro(group_a)
    _, p_norm_b = stats.shapiro(group_b)
```
### 3.1: Normality Testing
The Shapiro-Wilk test checks if a sample deviates significantly from a perfect normal distribution shape.
- The Math: It outputs a test statistic (discarded here using _) and a p-value.
- Interpretation: If p > 0.05, the data is safely normal. If $\(p \le 0.05\)$, the data fails the normality test, meaning a parametric t-test might give unreliable results.

### 3.2 Homogeneity of Variance Testing
```python
    # 2. Variance homogeneity test (Levene's Test)
    _, p_var = stats.levene(group_a, group_b)
```
Standard t-tests pool the variance of both groups together. If one group is wildly more volatile than the other, that calculation breaks. Levene’s test checks if the variances are statistically equal.
- Interpretation: If p_var > 0.05, the variances are close enough to be considered equal. If $\(p \le 0.05\)$, the variances are significantly different.


### 3.3: Conditional Execution of the \(t\)-test
```python
    # 3. Two-sample t-test (Welch's if variances are unequal)
    equal_var = p_var > 0.05
    t_stat, p_val = stats.ttest_ind(group_a, group_b, equal_var=equal_var)
```
It creates a True/False flag called equal_var.
- If Levene's p-value is >0.05, `equal_var` becomes True, and `stats.ttest_ind` runs a standard Student's t-test.
- If Levene's p-value is $\(\le 0.05\)$, `equal_var` becomes False. The function automatically switches gears to run Welch's t-test, which mathematically adjusts the degrees of freedom to account for the mismatched group variances.


### 3.4: The Non-Parametric Fallback
```python
    # 4. Non-parametric alternative (Mann-Whitney U) if normality fails
    u_stat, p_val_mannwhitney = stats.mannwhitneyu(group_a, group_b)
```
Regardless of what happened above, the script runs a Mann-Whitney U test. It converts all 20 gene expression values across both groups into a single ranked list (1st smallest to 20th largest) and checks if one group dominates the top ranks. This acts as a fallback dataset comparison for when the assumptions in steps 3.1 or 3.2 fail completely.

## Output
```bash
Mean_A: 13.1721
Mean_B: 15.8280
Levene_p_value: 0.0407
Equal_Variance_Assumed: False
t_statistic: -3.3433
t_test_p_value: 0.0053
Mann_Whitney_p_value: 0.0073
```

1. The Biological Signal (Direction of Change)
- Metric: `Mean_A` = 13.1721 | `Mean_B` = 15.8280
- Interpretation: The average gene expression level increases from 13.17 in Group A (Control) to 15.83 in Group B (Treated). This indicates that the treatment has an upregulating effect on this specific gene.


2. Evaluating the Variance (The Safety Check)
- Metric: `Levene_p_value` = 0.0407 | `Equal_Variance_Assumed` = False
- Interpretation: Because the Levene's test p-value is less than 0.05, we must reject the assumption of equal variances. Group B has significantly more spread/volatility than Group A. Your script successfully caught this and automatically set `Equal_Variance_Assumed` to False.
- Action taken: This means the script bypassed the standard Student's t-test and calculated the Welch’s t-test instead to protect against a false positive.


3. Final Significance Testing (The \(p\)-value)
Depending on your sample's distribution, you have two highly significant choices:
- If the data is normally distributed (Welch's t-test):
	- `t_test_p_value` = 0.0053
	- Since 0.0053 < 0.05, the difference is highly statistically significant. There is only a 0.53% chance that this increase in gene expression happened by random coincidence.
- If the data is skewed/non-normal (Mann-Whitney U test):
	- `Mann_Whitney_p_value` = 0.0073
	- Even if we completely discard the normal distribution assumption and rely entirely on ranking the data, the p-value (0.0073) remains well below the 0.05 threshold.


### Final Conclusion
Whether we choose the parametric track (Welch's t-test) or the non-parametric track (Mann-Whitney), the result is robustly significant. We can confidently report that the treatment significantly upregulates this gene's expression.







Descriptive Statistics & Probability Distributions (descriptive_statistics/ & probability/)Summary Metrics in Biological DatasetsBiological parameters (e.g., gene expression levels) often follow skewed distributions. It is critical to select appropriate metrics:Parametric Metrics (Normal Distributions): Mean ($\mu$), Variance ($\sigma^2$), Standard Deviation ($\sigma$).Non-Parametric Metrics (Skewed Omics Data): Median, Interquartile Range ($\text{IQR} = Q_3 - Q_1$), Median Absolute Deviation (MAD).Key Distributions in GenomicsPoisson Distribution: Models sparse count data where mean equals variance ($\mu = \sigma^2$). Often used for basic sequencing read coverage models.Negative Binomial Distribution: The standard distribution for RNA-seq read counts (e.g., in DESeq2 and edgeR). It incorporates an extra dispersion parameter ($\alpha$) to handle overdispersion ($\sigma^2 > \mu$):$$\text{Var}(X) = \mu + \alpha \mu^2$$2. Hypothesis Testing: Two-Group Comparisons (hypothesis_testing/)Student's $t$-test vs. Welch's $t$-testWhen comparing expression levels between two conditions (e.g., Control vs. Treated):Student's $t$-test: Assumes equal variances between groups ($\sigma_1^2 = \sigma_2^2$).Welch's $t$-test: Does not assume equal variances; preferred for omics datasets.












































