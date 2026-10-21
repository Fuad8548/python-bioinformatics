#!/bin/bash

# Phase 0, Lesson 1: Command-Line Basics - EXERCISES
# Solve these 10 problems using Linux commands
# After solving, check solutions.sh to see reference answers

echo "===== Phase 0, Lesson 1: Exercises ====="
echo ""
echo "For each exercise, write the command(s) needed to solve it."
echo "Check your answer against solutions.sh"
echo ""

# Create test data for exercises
mkdir -p exercise_data

# Create test FASTA file with 5 sequences
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

# Create test FASTQ file with 4 reads
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

# Create test VCF file with variants
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

echo "Test data created in exercise_data/"
echo ""

# ===== EXERCISES =====

echo "========================================"
echo "EXERCISE 1: Count Sequences"
echo "========================================"
echo "How many sequences are in exercise_data/sequences.fasta?"
echo ""
echo "Hint: Use grep to find header lines (start with '>'), then count them"
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output: 5"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 2: Extract Headers"
echo "========================================"
echo "Extract all sequence headers from exercise_data/sequences.fasta"
echo ""
echo "Hint: Use grep to find lines starting with '>'"
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output:"
echo ">chr1_region1 length=50"
echo ">chr1_region2 length=35"
echo ">chr2_region1 length=60"
echo ">chr2_region2 length=25"
echo ">chr3_region1 length=45"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 3: Find Specific Sequence"
echo "========================================"
echo "Extract the header and sequence for 'chr2_region1' from exercise_data/sequences.fasta"
echo ""
echo "Hint: Use grep -A 1 to print the matching line plus one line after"
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output:"
echo ">chr2_region1 length=60"
echo "ATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATG"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 4: Count FASTQ Reads"
echo "========================================"
echo "How many reads are in exercise_data/reads.fastq?"
echo ""
echo "Hint: FASTQ files have 4 lines per read. Use wc -l to count total lines,"
echo "then divide by 4. Or use grep -c to count header lines (start with '@')"
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output: 4"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 5: Filter by Quality"
echo "========================================"
echo "How many reads in exercise_data/reads.fastq have perfect quality (all 'I')?"
echo ""
echo "Hint: Quality scores are on the 4th line of each read."
echo "Lines with all 'I' characters have perfect quality."
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output: 1"
echo "(Only read_3 has all I's)"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 6: Find Low-Quality Reads"
echo "========================================"
echo "How many reads contain 'N' (unknown base) in exercise_data/reads.fastq?"
echo ""
echo "Hint: Sequence lines contain N's. Use grep to find them."
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output: 1"
echo "(Only read_4 contains N's)"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 7: Filter VCF by Quality"
echo "========================================"
echo "How many variants in exercise_data/variants.vcf have QUAL ≥ 90?"
echo ""
echo "Hint: The QUAL field is column 6. Use grep -v to skip header lines (^#),"
echo "then check which rows have QUAL ≥ 90"
echo "Or use awk to filter by column value"
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output: 3"
echo "(rs123, rs125, rs126 have QUAL ≥ 90)"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 8: Find SNPs on chr1"
echo "========================================"
echo "How many variants in exercise_data/variants.vcf are on chromosome 1?"
echo ""
echo "Hint: Chromosome is in column 1. Filter for 'chr1' and skip headers."
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Expected output: 3"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 9: Save Results to File"
echo "========================================"
echo "Extract all sequences from exercise_data/sequences.fasta and save them"
echo "(without headers) to exercise_data/sequences_only.fasta"
echo ""
echo "Hint: Use grep -v '^>' to skip header lines,"
echo "then use '>' to redirect to a new file"
echo ""
echo "Your command:"
echo "$ "
echo ""
echo "Then verify with: wc -l exercise_data/sequences_only.fasta"
echo "Expected output: 5 (one sequence per line)"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 10: Combined Analysis"
echo "========================================"
echo "For exercise_data/sequences.fasta, create a report showing:"
echo "  - Total number of sequences"
echo "  - Sequences from chr1"
echo "  - Sequences from chr2"
echo "  - Sequences from chr3"
echo ""
echo "Hint: Use grep and pipes to filter and count"
echo ""
echo "Your commands:"
echo "$ "
echo ""
echo "Expected output:"
echo "Total sequences: 5"
echo "chr1: 2"
echo "chr2: 2"
echo "chr3: 1"
echo ""
echo "---"
echo ""

echo "========================================"
echo "SOLUTIONS"
echo "========================================"
echo ""
echo "Check your answers against solutions.sh:"
echo "  bash solutions.sh"
echo ""
echo "After you finish:"
echo "  1. Compare your commands to the reference solutions"
echo "  2. Try different approaches (there's usually >1 way!)"
echo "  3. Move to the next lesson: 02-bash-scripting"
echo ""
