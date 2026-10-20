import numpy as np

# 1. Standard biological sequences
seq_vertical = "GCAT"    # Rows
seq_horizontal = "GATT"  # Columns

num_rows = len(seq_vertical) + 1
num_cols = len(seq_horizontal) + 1

# 2. Scoring System Parameters
match_score = 1
mismatch_penalty = -1
gap_penalty = -2

# 3. Initialize matrix and fill boundaries
scoring_matrix = np.zeros((num_rows, num_cols), dtype=int)
scoring_matrix[0, :] = np.arange(num_cols) * gap_penalty
scoring_matrix[:, 0] = np.arange(num_rows) * gap_penalty

# 4. Fill the rest of the matrix (The dynamic programming step)
for r in range(1, num_rows):
    for c in range(1, num_cols):
        # Determine if the letters match or mismatch
        # We subtract 1 because index 1 in the matrix corresponds to index 0 in the string
        if seq_vertical[r-1] == seq_horizontal[c-1]:
            diagonal_score = scoring_matrix[r-1, c-1] + match_score
        else:
            diagonal_score = scoring_matrix[r-1, c-1] + mismatch_penalty
            
        # Calculate scores from taking a gap
        top_score = scoring_matrix[r-1, c] + gap_penalty
        left_score = scoring_matrix[r, c-1] + gap_penalty
        
        # The cell takes the best (maximum) possible score
        scoring_matrix[r, c] = max(diagonal_score, top_score, left_score)

print("--- Completed Needleman-Wunsch Scoring Grid ---")
print(scoring_matrix)
