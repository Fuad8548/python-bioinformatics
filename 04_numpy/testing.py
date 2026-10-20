
import numpy as np

def pairwise_hamming_matrix(sequences: list[str]) -> np.ndarray:
    """
    Computes a pairwise Hamming distance matrix across a list of aligned sequences.
    """
    # 1. Convert list of strings to 2D uint8 matrix (num_seqs, seq_len)
    char_matrix = np.array([list(s) for s in sequences], dtype='U1')
    ascii_matrix = char_matrix.view(np.int32)
    
    # Expand dimensions for broadcasting: (N, 1, L) != (1, N, L) -> (N, N, L)
    diff_tensor = ascii_matrix[:, np.newaxis, :] != ascii_matrix[np.newaxis, :, :]
    
    # Sum mismatches along length axis (axis 2)
    dist_matrix = np.sum(diff_tensor, axis=2)
    return dist_matrix

seq_list = ["ATGC", "ATGA", "ACGC", "TTGC"]
dist_mat = pairwise_hamming_matrix(seq_list)
print("Pairwise Distance Matrix:\n", dist_mat)













































