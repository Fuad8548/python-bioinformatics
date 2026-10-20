import numpy as np

# 1. Simulated genetic data for 4 individuals across 5 different SNP locations
# Rows = Individual patients | Columns = Specific SNP genomic positions
population_genotypes = np.array([
    [0, 1, 2, 0, 0], # Patient 1
    [1, 0, 1, 2, 0], # Patient 2
    [2, 0, 1, 0, 0], # Patient 3
    [0, 1, 2, 1, 1]  # Patient 4
])

# 2. Extract population dimensions
num_patients, num_snps = population_genotypes.shape

# 3. Calculate the total count of variant alleles at each genomic site
# axis=0 sums vertically down the rows for each column position independently
total_variant_alleles = np.sum(population_genotypes, axis=0)

# 4. Compute allele frequency: Total observed mutations / Total possible copies
# Since each person carries 2 copies of a chromosome, max possible alleles = 2 * num_patients
max_alleles_in_population = 2 * num_patients
allele_frequencies = total_variant_alleles / max_alleles_in_population

print("--- Variant Allele Counts per SNP Site ---")
print(total_variant_alleles)

print("\n--- Final Population Allele Frequencies ---")
print(np.round(allele_frequencies, 2))
