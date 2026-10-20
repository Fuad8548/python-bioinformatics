# Module 6: Population Genetics & Allele Frequencies
In population genetics, scientists track single-letter variations in DNA called SNPs (Single Nucleotide Polymorphisms) across huge cohorts of patients. This allows us to discover which genetic mutations are linked to diseases.
Instead of working with characters, a population's genotypes are stored in a dense 2D NumPy array:
- 0 = Homozygous Normal (Wildtype / No mutation)
- 1 = Heterozygous Variant (Carries 1 copy of the mutation)
- 2 = Homozygous Variant (Carries 2 copies of the mutation)
Because every individual possesses two copies of each chromosome, the total number of possible allele copies at any genomic site is exactly 2 × number of people. We will use NumPy's vectorization across axis=0 to scan a whole population and calculate these variant frequencies instantly without slow loops.


## The Scenario: What do the numbers mean?
Humans have two copies of every chromosome (one from mom, one from dad). At any specific genetic location (called a SNP), a person can have 0, 1, or 2 copies of a mutated (variant) gene:
• 0 = No mutations (Wild type)
• 1 = 1 mutated copy, 1 normal copy (Heterozygous)
• 2 = 2 mutated copies (Homozygous mutant)
In your data matrix:
• Each row is a patient (4 total).
• Each column is a specific genetic location/SNP (5 total).

## Code Breakdown & Design Choices
- `np.sum(..., axis=0)`: Using `axis=0` forces NumPy to sum vertically down the columns rather than horizontally. This means the array collapses from a (4, 5) grid into a clean (1, 5) vector, representing one aggregated count value per genetic marker site.
- Vectorized Division: Dividing the `total_variant_alleles` array by the scalar `max_alleles_in_population` automatically calculates the final percentages across all 5 sites in parallel without a single python loop structure.


## Output
```bash
--- Variant Allele Counts per SNP Site ---
[3 2 6 3 1]

--- Final Population Allele Frequencies ---
[0.38 0.25 0.75 0.38 0.12]
```

- Total Max Alleles Calculation: With 4 patients, the maximum possible variant count at any site is 2 × 4 = 8 total copies.
- SNP Site 1 (Column 1): Vertically, the counts are 0 + 1 + 2 + 0 = 3. The frequency is calculated as 3 / 8 = 0.375, which rounds perfectly to 0.38. This is a moderately common mutation in this population.
- SNP Site 3 (Column 3): Vertically, the counts are 2 + 1 + 1 + 2 = 6. The frequency is calculated as 6 / 8 = 0.75. Biologically, this shows that almost the entire population carries this mutation, meaning it is likely a highly conserved variant or a fixated population trait.
- SNP Site 4 (Column 3): Vertically, the counts are 0 + 0 + 0 + 1 = 2. The frequency is calculated as 1 / 8 = 0.125, which rounds to 0.12. This represents a rare variant in this cohort.


































