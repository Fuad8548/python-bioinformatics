# 1. The Basics of Functional Enrichment Analysis (GSEA)
```text
 [ Raw Expression Data ]
                     │
                     ▼
          [ Differential Expression ]  <-- (t-test, ANOVA, FDR)
                     │
                     ▼
             [ Ranked Gene List ]      <-- Sorted by fold change / p-value
                     │
                     ▼
          [ Gene Set Library (MSigDb) ] <-- (Known molecular pathways)
                     │
                     ▼
    [ Gene Set Enrichment Analysis (GSEA) ] 
                     │
                     ▼
       { Final Biological Insights }   <-- (e.g., "Apoptosis Activated")
```

## How the GSEA Algorithm Works:
Unlike traditional over-representation tests (like hypergeometric testing), which only look at a strict cutoff of "significant" genes, GSEA uses all the genes in our experiment.
1. Rank the Genes: First, we sort every single gene from our study in a ranked list from top to bottom based on its expression behavior—typically using a combination of its effect size and statistical significance (e.g., $\(Score = \text{sign}(\text{Log2FC}) \times -\log_{10}(p\text{-value})\)$). The most heavily upregulated genes sit at the very top, unaffected genes sit in the middle, and heavily downregulated genes sit at the bottom.
2. Pass a Known Gene Set: We overlay a pre-defined biological "Gene Set" from an established database like **MSigDB** (Molecular Signatures Database). For example, we might fetch the known "Interferon Signaling Pathway" gene set, which contains a list of 40 specific genes known to coordinate anti-viral defenses.
3. The Running Enrichment Score (ES): The algorithm walks down our ranked master list from rank 1 to rank 20,000.
	- Every time it encounters a gene that belongs to our target pathway, it increases a running tally score.
	- Every time it hits a gene that is not in the pathway, it decreases the tally score.
4. Find the Peak: The highest peak hit during that walk becomes the Enrichment Score (ES).
	- If the pathway genes cluster heavily at the top of our list (upregulated), the score peaks early and high (Positive Enrichment).
	- If they cluster at the bottom (downregulated), the score drops low (Negative Enrichment).
5. Permutation Testing: The algorithm randomly scrambles our gene names thousands of times to see if our peak could have happened by pure random chance, yielding a highly robust, multiple-testing corrected FDR q-value.


# 2. Step-by-Step Codebase Implementation
In Python, the golden standard library for executing this analysis is `gseapy` (a native Python wrapper for the original Broad Institute GSEA desktop software).
The following pipeline simulates a complete ranked gene list for 1,000 genes and checks them against a custom pathway library using the `gseapy.prerank` function.

## 3.1: Building the Ranking Metric
```python
scores = np.sort(scores)[::-1]
```
- Sorts our combined statistical scores from highest positive values down to lowest negative values. GSEA strictly requires our inputs to be ordered this way so it can walk down from the "most upregulated" end to the "most downregulated" end.

## 3.2: Mapping the Gene Sets
```python
custom_pathways = {
    "CELL_CYCLE_PHASE": [f"GENE_{i}" for i in range(5, 45)],
    ...
}
```
Mimics a `.gmt` database file. We explicitly forced the 40 genes inside `CELL_CYCLE_PHASE` to have indices between 5 and 45. Because our dataframe is sorted, these genes automatically align perfectly with the highest positive scores in our ranked list, setting up a strong biological signal.

## 3.3: Launching the Prerank Engine
```bash
gsea_results = gp.prerank(rnk=df_ranked_data, gene_sets=custom_pathways, permutation_num=100)
```
- `gp.prerank` runs the analysis. It takes our numeric scores, calculates the exact running enrichment paths for each category inside our dictionary, and builds empirical null distributions via permutation shuffling to assign our final significance profiles.


## Output interpretation
```bash
--- GSEA Pathway Analysis Results ---
                Term        ES       NES  NOM p-val  FDR q-val
0  APOPTOSIS_PATHWAY -0.989474 -3.918461   0.000000   0.000000
1   CELL_CYCLE_PHASE  0.994792  3.365544   0.000000   0.000000
2   RANDOM_NOISE_SET  0.222917  0.815661   0.830189   0.801242
```
1. ES (Enrichment Score): The absolute raw peak score calculated during the walk.
2. NES (Normalized Enrichment Score): This is the most critical value for cross-pathway comparisons. Because large pathways naturally grab higher raw scores simply by having more genes, the algorithm normalizes the score based on the size of the gene set.
	- A high positive NES (e.g., 2.11) indicates the pathway is strongly upregulated.
	- A low negative NES (e.g., -1.95) indicates the pathway is strongly downregulated.
3. FDR q-val (False Discovery Rate): Just like our multiple testing correction chapter, evaluating multiple pathways simultaneously introduces false positive risks. An `FDR q-val < 0.05` means the pathway enrichment is statistically robust.


### Why the NES scores are much higher (3.36 and -3.91)?
- A Normalized Enrichment Score above 2.0 or below -2.0 is considered exceptionally strong in genomics. Because we deliberately placed the pathway genes at the absolute extreme tips of the 1,000-gene list (indices 5–45 for Cell Cycle and 940–990 for Apoptosis), the running enrichment score peaked almost perfectly at the very beginning and end of the walk. The algorithm recognized that this clustering is incredibly tight, resulting in a massive NES.

### Why the Random Noise p-value is 0.83?
In our output, the `RANDOM_NOISE_SET` has a `NOM p-val` of 0.830189 (83%) and an `FDR q-val` of 0.801242 (80%).
- This confirms that the permutation test worked flawlessly. It means that when `gseapy` scrambled our gene names 100 times, a random chunk of genes achieved a better enrichment score than our noise set 83% of the time. It proves mathematically that this pathway has zero biological relevance to our data.




























































