Volcano Plot is a scatter plot used in differential expression analysis (RNA-seq, proteomics, microarray) to quickly identify statistically significant and biologically meaningful changes.
- X-axis: Biological effect size ($\log_2\text{FoldChange}$).
- Y-axis: Statistical significance represented as $-\log_{10}(p_{\text{adj}})$.
- Interpretation:
  - Up-regulated genes: Top right quadrant (High $\log_2\text{FC}$, High $-\log_{10} p_{\text{adj}}$).
  - Down-regulated genes: Top left quadrant (Low $\log_2\text{FC}$, High $-\log_{10} p_{\text{adj}}$).


## Step 1: Preparing the data
```python
data["neg_log10_p"] = -np.log10(data[p_col])
```
- `df.copy()`: Creates a duplicate of our data so the function doesn't accidentally change our original spreadsheet.
- `-np.log10(...)`: Converts small raw p-values into larger numbers.
	- If a gene has a p-value of 0.05, this becomes 1.3.
	- If a gene has a highly significant p-value of 0.0001, this becomes 4.0.
	- This mathematical transformation ensures highly significant genes shoot upward toward the top of the plot.


## Step 2: Categorizing the Genes
```python
data["Group"] = "Not Significant"
data.loc[(data[log2fc_col] >= fc_cutoff) & (data[p_col] < p_cutoff), "Group"] = "Up-regulated"
data.loc[(data[log2fc_col] <= -fc_cutoff) & (data[p_col] < p_cutoff), "Group"] = "Down-regulated"
```
This labels every gene into one of three categories based on our cutoffs 1.5 for fold change, 0.05 for p-value:
- Up-regulated: Moved far to the right (positive fold change) and sits high up (low p-value).
- Down-regulated: Moved far to the left (negative fold change) and sits high up (low p-value).
- Not Significant: Everything else that failed to pass both thresholds.

## Step 4: Drawing the Dots (Scatter Plot)
```python
for group, color in colors.items():
    subset = data[data["Group"] == group]
    plt.scatter(subset[log2fc_col], subset["neg_log10_p"], c=color, label=f"{group} ({len(subset)})", ...)
```
- Instead of plotting everything at once, the code loops through the three groups one by one.
- It isolates a `subset` (e.g., just the Up-regulated genes), assigns them their specific color (Red), and plots them.
- By doing this group-by-group, the code can count how many genes are in each group (`len(subset)`) and automatically put that number into the legend.

## Step 5: Adding Threshold Lines
```python
plt.axvline(x=fc_cutoff, color="black", linestyle="--", ...)
plt.axvline(x=-fc_cutoff, color="black", linestyle="--", ...)
plt.axhline(y=-np.log10(p_cutoff), color="black", linestyle="--", ...)
```
- `axvline` draws vertical lines at our positive and negative fold-change cutoffs (e.g., `-1.5` and `1.5`).
- `axhline` draws a horizontal line at the converted significance threshold (e.g., `1.3`).
- These lines visually divide the graph into boundaries, making it easy to see which dots fell into the significant zones.


## Step 6: Labeling the Top Genes
```python
top_genes = data[(data["Group"] != "Not Significant")].sort_values(by=p_col).head(5)
texts = []
for _, row in top_genes.iterrows():
    texts.append(plt.text(row[log2fc_col], row["neg_log10_p"], str(row[gene_col]), ...))

adjust_text(texts, arrowprops=dict(arrowstyle="-", color='black', lw=0.5))
```
- `sort_values(by=p_col).head(5)` finds the 5 genes with the absolute lowest, most significant p-values (excluding the "Not Significant" ones).
- A loop places text on the chart at the exact coordinates of those genes and collects them into a list called texts.
- Finally, `adjust_text(texts)` algorithmically rearranges those 5 labels so they don't overlap, drawing tiny pointer lines (arrows) back to the original dots if they had to be moved.















