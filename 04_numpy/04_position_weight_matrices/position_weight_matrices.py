import numpy as np

# 1. Raw alignment counts for nucleotides (A, C, G, T) across 5 motif positions
# Rows: 0=A, 1=C, 2=G, 3=T | Columns: Sequence positions 1 to 5
count_matrix = np.array([
    [2, 1, 4, 1, 3],  # Adenine (A)
    [0, 3, 1, 2, 1],  # Cytosine (C) -> 0 at position 1
    [3, 2, 1, 4, 0],  # Guanine (G)  -> 0 at position 5
    [0, 2, 3, 2, 1]   # Thymine (T)  -> 0 at position 1
])

# 2. Apply Laplace Smoothing: Add a pseudocount of +1 to prevent log(0) errors
pseudocount = 1
smoothed_counts = count_matrix + pseudocount

# 3. Convert counts to frequencies (probabilities)
# axis=0 sums down columns to get total observations at each position
column_totals = np.sum(smoothed_counts, axis=0)
position_frequencies = smoothed_counts / column_totals

# 4. Convert frequencies to Log-Likelihood odds ratios (PWM)
# We divide by a background frequency of 0.25 (assuming random distribution of A, C, G, T)
background_freq = 0.25
pwm = np.log2(position_frequencies / background_freq)

print("--- Raw Count Matrix Errors ---")
print(f"Contains zero counts? {np.any(count_matrix == 0)}")

print("\n--- Smoothed Position Frequencies Matrix ---")
print(np.round(position_frequencies, 2))

print("\n--- Final Position Weight Matrix (PWM) ---")
print(np.round(pwm, 2))
