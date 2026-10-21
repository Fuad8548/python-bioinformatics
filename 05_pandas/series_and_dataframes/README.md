# 1. Creating Biological DataFrames
This section establishes how a standard RNA-seq or differential gene expression dataset is built and navigated in Python Pandas. When you run a differential expression analysis tool like DESeq2 or EdgeR, the final statistical result is exported as a large table. This code simulates that exact format.

- Creating a Structured Dictionary (`gene_data`): We store biological columns as keys and arrays of data as values.
  - `GeneSymbol`: Common biological names of the genes.
  - `Chromosome`: The genomic address where the gene physically lives.
  - `BaseMean`: The average normalized expression level across all sequencing samples.
  - `log2FoldChange`: The magnitude of expression shift between groups. A positive number means the gene turned "on" (up-regulated) in treated samples; a negative number means it turned "off" (down-regulated).
  - `pvalue`: The statistical significance score. Smaller numbers mean the result is highly likely to be biologically true rather than an experimental fluke.

- Injecting Custom Indices (`index=gene_ids`): By default, Pandas numbers rows from 0, 1, 2.... We deliberately override this with stable Ensembl Gene IDs (ENSG...).
- Naming the Index Axis (`df.index.name = "GeneID"`): We formally title the row marker column so it prints clearly and maps cleanly to relational databases.

3. **Why It Matters in Bioinformatics**
Common symbols change over time as new discoveries are made (e.g., a gene symbol might be renamed). However, Ensembl Database IDs are globally unique and immutable biological identifiers. Using them as the DataFrame row index prevents duplicate identification errors and establishes a professional foundation for large genomic integrations.

**Label-Based (`loc`) vs. Integer-Based (`iloc`) Indexing**
- `loc[row_label, col_label]`: Accesses data by row names (Gene IDs) and column names.
- `iloc[row_index, col_index]`: Accesses data by 0-based numerical positions.

## Output
```bash
--- Initial RNA-seq DataFrame ---
                
GeneID     GeneSymbol  Chromosome BaseMean log2FC pvalue      

ENSG00000141510       TP53      chr17    1420.5   2.35  0.00010
ENSG00000012048      BRCA1      chr17     890.2  -1.82  0.00230
ENSG00000146648       EGFR       chr7    3400.8   0.12  0.65000
ENSG00000136997        MYC       chr8     510.0   3.45  0.00001
ENSG00000111640      GAPDH      chr12   12500.4  -0.05  0.89000
```

