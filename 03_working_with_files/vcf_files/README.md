# Parsing VCF files with `pysam.VariantFile`

`pysam.VariantFile` exposes indexed VCF/BCF streams, enabling programmatic variant inspection and filtering.

```python
import pysam

def filter_snps_by_quality(vcf_path, min_qual=30, min_dp=10):
    """
    Extracts high-confidence biallelic single nucleotide variants (SNVs).
    """
    vcf_in = pysam.VariantFile(vcf_path)
    high_conf_snps = []
    
    for record in vcf_in.fetch():
        # 1. Restrict to PASS filter variants
        if "PASS" not in record.filter.keys() and len(record.filter) > 0:
            continue
            
        # 2. Check quality score
        if record.qual is None or record.qual < min_qual:
            continue
            
        # 3. Check for single nucleotide variant (SNV)
        if len(record.ref) == 1 and len(record.alts[0]) == 1:
            # Extract depth (DP) from INFO tags
            depth = record.info.get("DP", 0)
            if depth >= min_dp:
                variant_data = {
                    "chrom": record.chrom,
                    "pos": record.pos,
                    "ref": record.ref,
                    "alt": record.alts[0],
                    "qual": record.qual,
                    "depth": depth
                }
                high_conf_snps.append(variant_data)
                
    vcf_in.close()
    return high_conf_snps

# Example execution
# snps = filter_snps_by_quality("sample_variants.vcf")
# print(f"Retained {len(snps)} high-confidence SNVs")
```

**Explanation**:
This Python script uses a specialized bioinformatics library called `pysam` to read a VCF file (**Variant Call Format**) and filter out low-quality genetic mutations.
A raw VCF line contains columns like this:
```text
#CHROM  POS      ID   REF  ALT  QUAL  FILTER  INFO
chr1    10234    .    A    G    45    PASS    DP=15;AF=0.5
```
1. `vcf_in = pysam.VariantFile(vcf_path)` => opens the VCF file. `for record in vcf_in.fetch():` loops through every single mutation row in the file, one by one. 
2. Filter 1: The "PASS" Check
```python
if "PASS" not in record.filter.keys() and len(record.filter) > 0:
    continue
```
   - Looks at the FILTER column
   - If the variant calling software flagged the mutation as bad (e.g., `LowQual` or `StrandBias`), the script skips it. It only allows rows that are marked PASS (or are completely blank).
3. Filter 2: The Quality Check
```python
if record.qual is None or record.qual < min_qual:
    continue
```
   - Looks at the `QUAL` column and checks if it is lower than `30`.
   - A quality score of `30` means there is only a 1-in-1000 chance that this mutation is a mistake. Anything lower is considered too risky/noisy and is ignored.
4. Filter 3: The SNV Check (Single Nucleotide Variant)
```python
if len(record.ref) == 1 and len(record.alts[0]) == 1:
```
   - Measures the text length of the reference base (`REF`) and the alternative mutated base (`ALT`).
   - The script only wants SNVs (single-letter swaps, like `A` changing to `G`). If `REF` is `ATT` and `ALT` is `A`, that is an insertion/deletion (indel), which this script skips.
5. Filter 4: Read Depth (DP) Check
```python
depth = record.info.get("DP", 0)
if depth >= min_dp:
```
   - Looks inside the `INFO` column for `DP` (Depth), which is the number of times the sequencer read this specific genomic spot. It checks if it was read at least `10` times.
   - if a spot was only read 2 or 3 times, we can't trust the data. Higher depth means higher confidence.

**The Final Result:**
If a mutation survives all 4 checks, the script copies its details into a dictionary and saves it.
```bash
{
    "chrom": "chr1",
    "pos": 10234,
    "ref": "A",
    "alt": "G",
    "qual": 45.0,
    "depth": 15
}
```





































