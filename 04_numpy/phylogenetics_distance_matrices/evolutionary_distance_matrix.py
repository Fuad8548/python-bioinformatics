import numpy as np

# 1. Aligned genomic sequences for 4 different species
# All sequences must be the same length after alignment
species_names = ["Human", "Chimp", "Gorilla", "Mouse"]
sequences = np.array([
    ['A', 'G', 'C', 'T', 'T', 'A'],  # Human
    ['A', 'G', 'C', 'T', 'T', 'G'],  # Chimp   (1 difference from Human)
    ['A', 'G', 'C', 'A', 'T', 'G'],  # Gorilla (2 differences from Human)
    ['T', 'A', 'C', 'A', 'G', 'G']   # Mouse   (4 differences from Human)
])

num_species = len(species_names)

# 2. Initialize a blank square matrix for our evolutionary distances
distance_matrix = np.zeros((num_species, num_species), dtype=int)

# 3. Calculate the number of mismatched letters between every pair of species
for i in range(num_species):
    for j in range(num_species):
        # np.sum(sequences[i] != sequences[j]) counts how many positions do NOT match
        distance_matrix[i, j] = np.sum(sequences[i] != sequences[j])

print("--- Pairwise Evolutionary Distance Matrix ---")
print(distance_matrix)
