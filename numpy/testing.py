import numpy as np

# Simulated Phred quality scores for 10 sequencing bases
phred_scores = np.array([34, 38, 12, 40, 28, 9, 31, 35, 15, 39])

# Define quality threshold
min_q = 20

# Create boolean mask
pass_mask = phred_scores >= min_q
filtered_scores = phred_scores[pass_mask]

print("Original Scores: ", phred_scores)
print("Pass Mask:       ", pass_mask)
print("Filtered Scores: ", filtered_scores)
print(f"Pass Rate:        {np.mean(pass_mask) * 100:.1f}%")