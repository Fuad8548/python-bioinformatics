# Protein 3D Distance Matrix
To make this module production-grade for structural biology, we need to replace raw string calculations with a script that processes 3D protein coordinates (like those found in a PDB file).
Instead of writing nested loops to compare every amino acid to every other amino acid—which would cripple your performance on large proteins—we will use NumPy Broadcasting (`np.newaxis`) to compute an entire pairwise distance matrix in parallel.



## Code Breakdown & Design Choices

- `np.newaxis`: This tool inserts a new dimension into the array structural definitions. By subtracting a column vector of shape `(4, 1, 3)` from a row vector of shape `(1, 4, 3)`, NumPy automatically stretches both matrices to match each other. This computes the spatial separation vectors for all 16 pair combinations simultaneously.
- `axis=-1`: This parameter ensures the summation operation only targets the innermost dimension (the paired differences of dx², dy², dz²). This collapses our temporary 3D matrix cleanly back down into a flat 2D distance grid.


## Understanding the Output
```bash
--- Structural Array Info ---
Coordinates Array Shape: (4, 3)
Distance Matrix Shape:    (4, 4)

--- 3D Pairwise Distance Matrix (Angstroms) ---
[[ 0.    5.2  10.39  2.45]
 [ 5.2   0.    5.2   4.58]
 [10.39  5.2   0.    9.49]
 [ 2.45  4.58  9.49  0.  ]]
```

- The Zero Diagonal: The value at row index [0, 0] or [1, 1] is exactly 0.0. This makes physical sense because an atom's distance from itself is zero.
- Perfect Grid Symmetry: The value at row 1, column 2 (5.2) perfectly matches row 2, column 1 (5.2). The calculated distance from Residue A to Residue B is inherently identical to the distance from B to A.
- Folding Insight: Notice that Residue 1 and Residue 4 are only 2.45 Angstroms apart in space. Even though they are separated along the linear chain sequence, they are closely interacting in 3D space, showing us exactly where a loop or fold occurs.

















