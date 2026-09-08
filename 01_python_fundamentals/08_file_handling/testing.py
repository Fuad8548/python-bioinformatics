sequences = {
    "Gene_01": "ATGCGATCGATCGATCG",
    "Gene_02": "CCGCGATCGCGCGC",
    "Gene_03": "ATATATAATTATATAA"
}

output_tsv_path = "sequence_summary.tsv"

with open(output_tsv_path, mode="w", encoding="utf-8") as out_file:
    # Write TSV Header
    out_file.write("Gene_ID\tLength_bp\tGC_Percentage\n")
    
    for gene_id, seq in sequences.items():
        seq_len = len(seq)
        gc_pct = round(((seq.count("G") + seq.count("C")) / seq_len) * 100, 2)
        
        # Write tab-delimited record line
        out_file.write(f"{gene_id}\t{seq_len}\t{gc_pct}\n")

print(f"Summary report written to {output_tsv_path}")