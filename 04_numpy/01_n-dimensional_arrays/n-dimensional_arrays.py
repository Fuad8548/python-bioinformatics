import numpy as np

# 1. Define a raw DNA sequence
raw_sequence = "ATGCGATCGATCGATCGATAGCGC"

# 2. Convert to an N-dimensional array enforcing a 1-byte Character dtype ('S1')
# This optimizes memory allocation for massive genomic datasets
dna_array = np.array(list(raw_sequence), dtype='S1')

# 3. View structural properties of our genomic array
print("--- Array Metadata ---")
print(f"Array Shape: {dna_array.shape}")
print(f"Data Type (dtype): {dna_array.dtype}")
print(f"Memory size per element: {dna_array.itemsize} byte")
print(f"Total Array Memory: {dna_array.nbytes} bytes")

print("\n--- Array Representation ---")
print(f"Raw NumPy Array Output: {dna_array}")
