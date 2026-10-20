import numpy as np

# 1. One-hot encoded genetic data for 3 distinct species (A, B, and C)
# Rows = Species (Index 0: Species A, Index 1: Species B, Index 2: Species C)
# Columns = 6 specific positions in a DNA sequence alignment
# 1 = reference nucleotide match, 0 = mutation/different nucleotide
species_dna = np.array([    
    [1, 0, 1, 0, 1, 0],  # Species A (Highly mutated/distant)
    [1, 1, 0, 1, 0, 1],  # Species B 
    [0, 0, 0, 1, 1, 1]   # Species C (Very close to B)
])

# 2. Extract matrix dimensions
num_species, sequence_length = species_dna.shape

# 3. Count shared genetic markers using the Matrix Dot Product
# Transposing (.T) flips the matrix shape from (3, 6) to (6, 3)
shared_markers = np.dot(species_dna, species_dna.T)

# 4. Convert shared markers into an Evolutionary Distance Matrix
# Formula: Distance = Total Sequence Length - Shared Markers
evolutionary_distance = sequence_length - shared_markers

print("--- Shared Genetic Markers Matrix ---")
print(shared_markers)

print("\n--- Final Evolutionary Distance Matrix ---")
print(evolutionary_distance)
