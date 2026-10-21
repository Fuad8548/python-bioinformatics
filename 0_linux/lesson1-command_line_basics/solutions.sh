#!/bin/bash

# Phase 0, Lesson 1: Command-Line Basics - SOLUTIONS
# This file shows reference answers to all 10 exercises
# Run this after attempting exercises.sh

echo "===== Phase 0, Lesson 1: Exercise Solutions ====="
echo ""

# Create test data (same as in exercises.sh)
mkdir -p exercise_data

cat > exercise_data/sequences.fasta << 'EOF'
>chr1_region1 length=50
ATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGC
>chr1_region2 length=35
GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTAGC
>chr2_region1 length=60
ATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATG
>chr2_region2 length=25
GCTAGCTAGCTAGCTAGCTAGCTA
>chr3_region1 length=45
ATGCATGCATGCATGCATGCATGCATGCATGCATGCATGC
EOF

cat > exercise_data/reads.fastq << 'EOF'
@read_1/1
ATGCATGCATGCATGCATGC
+
IIIIIIIIIIIIIIIIHHHH
@read_2/1
GCTAGCTAGCTAGCTAGCTA
+
IIIHHHHHHHHHHHHHHIII
@read_3/1
ATGCATGCATGCATGCATGC
+
IIIIIIIIIIIIIIIIIIII
@read_4/1
NNNNNATGCATGCATGCNNNN
+
####IIIIIIIIIIII####
EOF

cat > exercise_data/variants.vcf << 'EOF'
##fileformat=VCFv4.2
##INFO=<ID=DP,Type=Integer>
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO
chr1	1000	rs123	A	T	100	PASS	DP=50
chr1	2000	rs124	C	G	85	PASS	DP=45
chr1	3000	.	G	A	20	LowQual	DP=15
chr2	1500	rs125	T	C	95	PASS	DP=48
chr2	2500	rs126	A	G	60	PASS	DP=35
EOF

echo "Test data created. Running solutions..."
echo ""

# ===== SOLUTION 1 =====
echo "========================================"
echo "SOLUTION 1: Count Sequences"
echo "========================================"
echo "Question: How many sequences are in exercise_data/sequences.fasta?"
echo ""
echo "Command:"
echo "  grep -c '^>' exercise_data/sequences.fasta"
echo ""
echo "Explanation:"
echo "  grep -c '^>' = Count lines starting with '>'"
echo "  In FASTA format, each sequence starts with a header line (>)"
echo "  So counting headers = counting sequences"
echo ""
echo "Result:"
grep -c "^>" exercise_data/sequences.fasta
echo ""
echo "Alternative solution:"
echo "  grep '^>' exercise_data/sequences.fasta | wc -l"
grep "^>" exercise_data/sequences.fasta | wc -l
echo ""
echo "---"
echo ""

# ===== SOLUTION 2 =====
echo "========================================"
echo "SOLUTION 2: Extract Headers"
echo "========================================"
echo "Question: Extract all sequence headers"
echo ""
echo "Command:"
echo "  grep '^>' exercise_data/sequences.fasta"
echo ""
echo "Explanation:"
echo "  grep '^>' = Find lines starting with '>'"
echo "  This is the definition of a header in FASTA format"
echo ""
echo "Result:"
grep "^>" exercise_data/sequences.fasta
echo ""
echo "---"
echo ""

# ===== SOLUTION 3 =====
echo "========================================"
echo "SOLUTION 3: Find Specific Sequence"
echo "========================================"
echo "Question: Extract header and sequence for 'chr2_region1'"
echo ""
echo "Command:"
echo "  grep -A 1 '^>chr2_region1' exercise_data/sequences.fasta"
echo ""
echo "Explanation:"
echo "  grep -A 1 = Find match + print 1 line after it"
echo "  '^>chr2_region1' = Find header line starting with >chr2_region1"
echo "  This gives us the header plus the next line (the sequence)"
echo ""
echo "Result:"
grep -A 1 "^>chr2_region1" exercise_data/sequences.fasta
echo ""
echo "---"
echo ""

# ===== SOLUTION 4 =====
echo "========================================"
echo "SOLUTION 4: Count FASTQ Reads"
echo "========================================"
echo "Question: How many reads are in the FASTQ file?"
echo ""
echo "Command (Method 1: Count headers):"
echo "  grep -c '^@' exercise_data/reads.fastq"
grep -c "^@" exercise_data/reads.fastq
echo ""
echo "Explanation:"
echo "  In FASTQ format, each read has 4 lines:"
echo "    Line 1: @read_id (header starting with @)"
echo "    Line 2: sequence"
echo "    Line 3: + (separator)"
echo "    Line 4: quality scores"
echo "  So counting headers (lines starting with @) = number of reads"
echo ""
echo "Command (Method 2: Divide total lines by 4):"
echo "  Total lines:"
wc -l exercise_data/reads.fastq
echo "  Number of reads = $($(wc -l exercise_data/reads.fastq | awk '{print $1}') / 4)"
echo ""
echo "---"
echo ""

# ===== SOLUTION 5 =====
echo "========================================"
echo "SOLUTION 5: Filter by Quality (Perfect Quality)"
echo "========================================"
echo "Question: How many reads have perfect quality (all 'I')?"
echo ""
echo "Command:"
echo "  grep -E '^I+$' exercise_data/reads.fastq"
echo ""
echo "Explanation:"
echo "  Quality scores are on line 4 of each read"
echo "  Grep alone can't easily filter by line number, so we need awk:"
echo ""
echo "Better command (using awk):"
echo "  awk 'NR % 4 == 0 && /^I+$/ { count++ } END { print count }' exercise_data/reads.fastq"
echo ""
echo "Explanation:"
echo "  NR % 4 == 0 = Every 4th line (quality lines)"
echo "  /^I+$/ = Lines that are ONLY 'I' characters (perfect quality)"
echo "  count++ = Increment counter"
echo "  END { print count } = Print final count"
echo ""
echo "Result:"
awk 'NR % 4 == 0 && /^I+$/ { count++ } END { print count }' exercise_data/reads.fastq
echo ""
echo "Verify by looking at quality lines:"
echo "  Quality scores for each read:"
awk 'NR % 4 == 0 { print "Read " ($0 == "IIIIIIIIIIIIIIIIIIII" ? "(perfect)" : "(has bad bases)") ": " $0 }' exercise_data/reads.fastq
echo ""
echo "---"
echo ""

# ===== SOLUTION 6 =====
echo "========================================"
echo "SOLUTION 6: Find Low-Quality Reads (with N)"
echo "========================================"
echo "Question: How many reads contain 'N' (unknown base)?"
echo ""
echo "Command:"
echo "  grep -c 'N' exercise_data/reads.fastq"
echo ""
echo "Explanation:"
echo "  N = unknown base (sequencer couldn't determine which base)"
echo "  We want to count how many reads have at least one N"
echo "  grep 'N' = find all lines containing N"
echo "  grep -c = count matching lines"
echo ""
echo "But wait—this counts all lines with N, not just sequence lines!"
echo "Better approach:"
echo "  grep -E '^[ATGCN]+$' exercise_data/reads.fastq | grep -c 'N'"
echo ""
echo "Or, more precisely (sequence lines only):"
echo "  awk 'NR % 4 == 2 && /N/ { count++ } END { print count }' exercise_data/reads.fastq"
echo "  (NR % 4 == 2 = every 2nd line in groups of 4 = sequence lines)"
echo ""
echo "Result:"
awk 'NR % 4 == 2 && /N/ { count++ } END { print count }' exercise_data/reads.fastq
echo ""
echo "---"
echo ""

# ===== SOLUTION 7 =====
echo "========================================"
echo "SOLUTION 7: Filter VCF by Quality"
echo "========================================"
echo "Question: How many variants have QUAL ≥ 90?"
echo ""
echo "Command:"
echo "  grep -v '^#' exercise_data/variants.vcf | awk '\$6 >= 90 { count++ } END { print count }'"
echo ""
echo "Explanation:"
echo "  grep -v '^#' = Skip header lines (start with #)"
echo "  awk '\$6 >= 90' = Check if column 6 (QUAL) >= 90"
echo "  count++ = Increment counter"
echo "  END { print count } = Print final count"
echo ""
echo "Result:"
grep -v "^#" exercise_data/variants.vcf | awk '$6 >= 90 { count++ } END { print count }'
echo ""
echo "Let's verify by showing which ones pass:"
echo ""
echo "  Variants with QUAL >= 90:"
grep -v "^#" exercise_data/variants.vcf | awk '$6 >= 90 { print "  " $1 "\t" $2 "\t" $4 "\t" $5 "\t(QUAL=" $6 ")" }'
echo ""
echo "---"
echo ""

# ===== SOLUTION 8 =====
echo "========================================"
echo "SOLUTION 8: Find SNPs on chr1"
echo "========================================"
echo "Question: How many variants are on chromosome 1?"
echo ""
echo "Command:"
echo "  grep -v '^#' exercise_data/variants.vcf | grep -c '^chr1'"
echo ""
echo "Explanation:"
echo "  grep -v '^#' = Skip header lines"
echo "  grep -c '^chr1' = Count lines starting with 'chr1'"
echo ""
echo "Result:"
grep -v "^#" exercise_data/variants.vcf | grep -c "^chr1"
echo ""
echo "Or using awk (more robust):"
echo "  grep -v '^#' exercise_data/variants.vcf | awk '\$1 == \"chr1\" { count++ } END { print count }'"
grep -v "^#" exercise_data/variants.vcf | awk '$1 == "chr1" { count++ } END { print count }'
echo ""
echo "Variants on chr1:"
grep -v "^#" exercise_data/variants.vcf | awk '$1 == "chr1"'
echo ""
echo "---"
echo ""

# ===== SOLUTION 9 =====
echo "========================================"
echo "SOLUTION 9: Save Results to File"
echo "========================================"
echo "Question: Extract sequences (without headers) and save to new file"
echo ""
echo "Command:"
echo "  grep -v '^>' exercise_data/sequences.fasta > exercise_data/sequences_only.fasta"
echo ""
echo "Explanation:"
echo "  grep -v '^>' = Find all lines that do NOT start with '>'"
echo "  > exercise_data/sequences_only.fasta = Save to new file"
echo ""
echo "Running command:"
grep -v "^>" exercise_data/sequences.fasta > exercise_data/sequences_only.fasta
echo ""
echo "Verify:"
echo "  wc -l exercise_data/sequences_only.fasta"
wc -l exercise_data/sequences_only.fasta
echo ""
echo "Contents of new file:"
cat exercise_data/sequences_only.fasta
echo ""
echo "---"
echo ""

# ===== SOLUTION 10 =====
echo "========================================"
echo "SOLUTION 10: Combined Analysis Report"
echo "========================================"
echo "Question: Create a report showing total and per-chromosome counts"
echo ""
echo "Commands:"
echo ""
echo "Total sequences:"
echo "  grep -c '^>' exercise_data/sequences.fasta"
grep -c "^>" exercise_data/sequences.fasta
echo ""
echo "Sequences from chr1:"
echo "  grep -c '^>chr1' exercise_data/sequences.fasta"
grep -c "^>chr1" exercise_data/sequences.fasta
echo ""
echo "Sequences from chr2:"
echo "  grep -c '^>chr2' exercise_data/sequences.fasta"
grep -c "^>chr2" exercise_data/sequences.fasta
echo ""
echo "Sequences from chr3:"
echo "  grep -c '^>chr3' exercise_data/sequences.fasta"
grep -c "^>chr3" exercise_data/sequences.fasta
echo ""
echo "Complete report in one command:"
echo "  grep '^>' exercise_data/sequences.fasta | sed 's/>\\([a-z0-9]*\\)_.*/\\1/' | sort | uniq -c"
echo ""
grep "^>" exercise_data/sequences.fasta | sed "s/>\\([a-z0-9]*\\)_.*/\\1/" | sort | uniq -c
echo ""
echo "---"
echo ""

echo "========================================"
echo "SUMMARY"
echo "========================================"
echo ""
echo "Key concepts used in solutions:"
echo ""
echo "1. grep '^>' = Find headers in FASTA files"
echo "2. grep '^@' = Find headers in FASTQ files"
echo "3. grep -c = Count matching lines"
echo "4. grep -v = Find non-matching lines (invert match)"
echo "5. grep -A N = Print match + N lines after"
echo "6. wc -l = Count lines in a file"
echo "7. awk = Process columns and perform calculations"
echo "8. > = Redirect output to a file"
echo "9. | (pipe) = Chain commands together"
echo ""
echo "Next steps:"
echo "  1. Compare your solutions to these reference answers"
echo "  2. Try alternative approaches (multiple solutions work!)"
echo "  3. Clean up: rm -r exercise_data/"
echo "  4. Move to Lesson 2: Bash Scripting"
echo ""
