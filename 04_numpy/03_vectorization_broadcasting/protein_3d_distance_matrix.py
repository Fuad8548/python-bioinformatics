import numpy as np

# 1. Simulated 3D coordinates (x, y, z) for 4 sequential amino acid residues (Alpha Carbons)
# Shape: (4, 3) -> 4 atoms, each with 3 spatial coordinates
protein_coords = np.array([
    [1.0, 2.0, 3.0],  # Residue 1
    [4.0, 5.0, 6.0],  # Residue 2
    [7.0, 8.0, 9.0],  # Residue 3
    [2.0, 1.0, 5.0]   # Residue 4
])

# 2. Use Broadcasting to calculate structural differences between all pairs
# Shape manipulation: (4, 1, 3) - (1, 4, 3) -> Results in a temporary (4, 4, 3) matrix
coord_diffs = protein_coords[:, np.newaxis, :] - protein_coords[np.newaxis, :, :]

# 3. Compute Euclidean distance matrix: sqrt(dx^2 + dy^2 + dz^2)
# axis=-1 tells NumPy to sum across the spatial coordinate axis (the x, y, z values)
distance_matrix = np.sqrt(np.sum(coord_diffs**2, axis=-1))

print("--- Structural Array Info ---")
print(f"Coordinates Array Shape: {protein_coords.shape}")
print(f"Distance Matrix Shape:    {distance_matrix.shape}")

print("\n--- 3D Pairwise Distance Matrix (Angstroms) ---")
print(np.round(distance_matrix, 2))
