#!/bin/bash

# Phase 0, Lesson 2: Bash Scripting - EXERCISES
# Solve these 10 problems by writing bash scripts
# Check your answers against solutions.sh

echo "===== Phase 0, Lesson 2: Bash Scripting - Exercises ====="
echo ""
echo "For each exercise, write a bash script to solve the problem."
echo "Save each script as exercise_N.sh and run it: bash exercise_N.sh"
echo ""

# Create test data
mkdir -p exercise_data

# Create FASTA files
cat > exercise_data/sequences.fasta << 'EOF'
>seq1
ATGCATGCATGCATGC
>seq2
GCTAGCTAGCTAGCTA
>seq3
ATGCATGCATGCATGCATGCATGCATGC
>seq4
GCTAGCTAGCTA
>seq5
ATGCATGCATGCATGCATGCATGCATGCATGCATGC
EOF

# Create FASTQ file
cat > exercise_data/reads.fastq << 'EOF'
@read_1
ATGCATGCATGCATGC
+
IIIIIIIIIIHHHHHH
@read_2
GCTAGCTAGCTAGCTA
+
IIIIIIIIIIIIIIII
@read_3
ATGCATGCATGCATGC
+
IHHHHHHHHHHHHHHH
@read_4
NNNNNATGCATGCNNNN
+
####IIIIIIII####
@read_5
ATGCATGCATGCATGCATGC
+
IIIIIIIIIIIIIIIIIIII
EOF

# Create multiple samples
for i in 1 2 3; do
    cp exercise_data/reads.fastq exercise_data/sample_${i}.fastq
done

echo "Test data created in exercise_data/"
echo ""

# ===== EXERCISES =====

echo "========================================"
echo "EXERCISE 1: Variables and Echo"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Creates a variable with your name"
echo "  2. Creates a variable with a number"
echo "  3. Echoes both variables"
echo ""
echo "Expected output (example):"
echo "  Name: Alice"
echo "  Favorite number: 42"
echo ""
echo "Hint: Use name='Alice' and number=42"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 2: File Checking"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Takes a filename as an argument (\$1)"
echo "  2. Checks if the file exists"
echo "  3. If it exists, echo 'File found: FILENAME'"
echo "  4. If not, echo 'File not found: FILENAME'"
echo ""
echo "Expected usage: bash exercise_2.sh exercise_data/sequences.fasta"
echo "Expected output: File found: exercise_data/sequences.fasta"
echo ""
echo "Hint: Use [ -f \$1 ] to check if file exists"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 3: For Loop - Count Files"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Loops through all .fasta files in exercise_data/"
echo "  2. For each file, prints its name"
echo "  3. For each file, counts the sequences (lines starting with >)"
echo "  4. Prints: 'FILE: N sequences'"
echo ""
echo "Expected output:"
echo "  exercise_data/sequences.fasta: 5 sequences"
echo ""
echo "Hint: Use for file in exercise_data/*.fasta; do ... done"
echo "      Use grep -c '^>' \$file to count sequences"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 4: While Loop - Counter"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Takes a number N as argument"
echo "  2. Counts from 1 to N using a while loop"
echo "  3. For each iteration, prints 'Iteration X'"
echo ""
echo "Expected usage: bash exercise_4.sh 5"
echo "Expected output:"
echo "  Iteration 1"
echo "  Iteration 2"
echo "  Iteration 3"
echo "  Iteration 4"
echo "  Iteration 5"
echo ""
echo "Hint: Use while [ \$counter -le \$N ]; do ... done"
echo "      counter=\$((counter + 1)) to increment"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 5: Function - Validate FASTA"
echo "========================================"
echo "Task: Write a script with a function that:"
echo "  1. Defines is_valid_fasta() function"
echo "  2. Function takes a filename as argument"
echo "  3. Returns 0 (success) if file starts with '>'"
echo "  4. Returns 1 (failure) if not"
echo "  5. Call the function on exercise_data/sequences.fasta"
echo "  6. Print 'Valid FASTA' or 'Not a FASTA file'"
echo ""
echo "Expected output: Valid FASTA"
echo ""
echo "Hint: is_valid_fasta() { grep -q '^>' \$1; }"
echo "      Then: if is_valid_fasta exercise_data/sequences.fasta; then"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 6: Process Multiple Files"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Loops through all .fastq files in exercise_data/"
echo "  2. For each file, counts total reads"
echo "  3. For each file, counts total reads with quality score 'I' > 10"
echo "  4. Prints: 'FILE: TOTAL_READS reads, HIGH_QUALITY_READS high-quality'"
echo ""
echo "Expected output (approximately):"
echo "  exercise_data/sample_1.fastq: 5 reads, X high-quality"
echo "  exercise_data/sample_2.fastq: 5 reads, X high-quality"
echo "  exercise_data/sample_3.fastq: 5 reads, X high-quality"
echo "  exercise_data/reads.fastq: 5 reads, X high-quality"
echo ""
echo "Hint: grep -c '^@' to count reads"
echo "      awk 'NR%4==0' to extract quality lines"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 7: Sequence Statistics"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Takes a FASTA file as argument"
echo "  2. Counts total sequences"
echo "  3. Finds longest sequence length"
echo "  4. Finds shortest sequence length"
echo "  5. Prints statistics in this format:"
echo "     FILE: N sequences"
echo "     Longest: X bases"
echo "     Shortest: Y bases"
echo ""
echo "Expected output (example):"
echo "  exercise_data/sequences.fasta: 5 sequences"
echo "  Longest: 38 bases"
echo "  Shortest: 12 bases"
echo ""
echo "Hint: grep -c '^>' for count"
echo "      grep -v '^>' | awk '{print length}' for lengths"
echo "      sort -n and head/tail to find max/min"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 8: Batch Rename Files"
echo "========================================"
echo "Task: Write a script that:"
echo "  1. Loops through all .fastq files in exercise_data/"
echo "  2. For each file, creates a new name with 'processed_' prefix"
echo "  3. Copies the file with the new name"
echo "  4. Prints 'Copied: OLD_NAME -> NEW_NAME'"
echo ""
echo "Expected output:"
echo "  Copied: exercise_data/reads.fastq -> processed_reads.fastq"
echo "  Copied: exercise_data/sample_1.fastq -> processed_sample_1.fastq"
echo "  ... (for each .fastq file)"
echo ""
echo "Hint: Use basename to extract filename"
echo "      name=\${file##*/} to get just the filename"
echo "      new_name=\"processed_\${name}\""
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 9: Generate Report"
echo "========================================"
echo "Task: Write a script that generates a CSV report:"
echo "  1. Takes a directory path as argument"
echo "  2. Finds all .fasta files in that directory"
echo "  3. Creates a file called 'report.csv'"
echo "  4. Report has header: 'Filename,Sequences,Total_Bases'"
echo "  5. For each FASTA file, add a row with:"
echo "     - Filename"
echo "     - Number of sequences"
echo "     - Total number of bases (sum of all sequence lengths)"
echo ""
echo "Expected usage: bash exercise_9.sh exercise_data"
echo "Expected output file (report.csv):"
echo "  Filename,Sequences,Total_Bases"
echo "  sequences.fasta,5,127"
echo ""
echo "Hint: echo 'header' > report.csv creates file"
echo "      echo 'data' >> report.csv appends to file"
echo ""
echo "---"
echo ""

echo "========================================"
echo "EXERCISE 10: Complete Pipeline Script"
echo "========================================"
echo "Task: Write a complete bash script that:"
echo "  1. Takes an input FASTQ file and a quality threshold as arguments"
echo "  2. Counts total reads"
echo "  3. Filters reads by quality (simpler version: count 'I' characters)"
echo "  4. Creates an output report with:"
echo "     - Input file name"
echo "     - Total reads"
echo "     - High-quality reads (mostly I's)"
echo "     - Percentage passing quality"
echo "  5. Saves report to 'quality_report.txt'"
echo ""
echo "Expected usage: bash exercise_10.sh exercise_data/reads.fastq 10"
echo "Expected output file content (example):"
echo "  Quality Report"
echo "  =============="
echo "  Input file: exercise_data/reads.fastq"
echo "  Total reads: 5"
echo "  High-quality reads: 3"
echo "  Percentage passing: 60%"
echo ""
echo "Hint: Create a function to count high-quality reads"
echo "      Use expr or awk for percentage calculation"
echo ""
echo "---"
echo ""

echo "========================================"
echo "SOLUTIONS"
echo "========================================"
echo ""
echo "After you complete each exercise:"
echo "  1. Run your script and verify output"
echo "  2. Check against solutions.sh: bash solutions.sh"
echo "  3. Compare your approach with reference solutions"
echo ""
echo "Tips:"
echo "  - Test with small inputs first"
echo "  - Use 'echo' to print debug information"
echo "  - Check file syntax: bash -n exercise_N.sh"
echo "  - Don't worry if your solution differs from reference"
echo "    (there are many ways to solve these!)"
echo ""