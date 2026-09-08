# RNA Basics with Python

Transcription converts a double-stranded DNA template into a single-stranded RNA molecule by replacing Thymine (T) with Uracil (U). Open Reading Frames (ORFs) represent spans of RNA bounded by a canonical Start Codon (`AUG`) and a Stop Codon (`UAA`, `UAG`, `UGA`).

## 1. DNA to RNA Transcription & Reverse Transcription

```python
def transcribe_dna_to_rna(dna_sequence: str) -> str:
    """Converts coding DNA sequence to mRNA."""
    return dna_sequence.upper().replace("T", "U")

def reverse_transcribe_rna_to_dna(rna_sequence: str) -> str:
    """Converts mRNA sequence back to complementary cDNA."""
    return rna_sequence.upper().replace("U", "T")
```

## 2. Identifying Open Reading Frames (ORFs) across 3 Forward Reading Frames

```python
def find_forward_orfs(rna_sequence: str, min_protein_len: int = 10) -> list[dict]:
    """
    Scans an RNA sequence in all 3 forward reading frames linearly in O(N) time.
    """
    rna = rna_sequence.upper()
    stop_codons = {"UAA", "UAG", "UGA"}
    start_codon = "AUG"
    orfs = []

    for frame in range(3):
        current_start = None  # Tracks the start index of the active ORF
        
        # Step through the sequence in steps of 3
        for i in range(frame, len(rna) - 2, 3):
            codon = rna[i:i+3]
            
            if current_start is None:
                # Look for a start codon if we aren't currently inside an ORF
                if codon == start_codon:
                    current_start = i
            else:
                # Look for a stop codon if we are inside an active ORF
                if codon in stop_codons:
                    end_pos = i + 3
                    orf_seq = rna[current_start:end_pos]
                    protein_len = (len(orf_seq) // 3) - 1   # Calculates the number of amino acids. It subtracts 1 to exclude the stop codon itself (as it doesn't code for amino acids)
                    
                    if protein_len >= min_protein_len:
                        orfs.append({
                            "frame": frame + 1,
                            "start": current_start,
                            "end": end_pos,
                            "length_bp": len(orf_seq),
                            "orf_sequence": orf_seq
                        })
                    
                    current_start = None  # Reset tracker for the next ORF

    return orfs

# Test ORF extraction
rna_test = "AUGGCCUUGAAAUAGCCCAUGUUUUAG"
detected_orfs = find_forward_orfs(rna_test, min_protein_len=2)
print("Detected ORFs:", detected_orfs)
```

**Output**:
```bash
Detected ORFs: [{'frame': 1, 'start': 0, 'end': 15, 'length_bp': 15, 'orf_sequence': 'AUGGCCUUGAAAUAG'}, {'frame': 1, 'start': 18, 'end': 27, 'length_bp': 9, 'orf_sequence': 'AUGUUUUAG'}]
```

