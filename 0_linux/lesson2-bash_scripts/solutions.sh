#!/bin/bash

# Phase 0, Lesson 2: Bash Scripting - SOLUTIONS
# Reference answers to all 10 exercises

echo "===== Phase 0, Lesson 2: Bash Scripting - Solutions ====="
echo ""

# Create test data (same as in exercises.sh)
mkdir -p exercise_data

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

for i in 1 2 3; do
    cp exercise_data/reads.fastq exercise_data/sample_${i}.fastq
done

echo ""

# ===== SOLUTION 1 =====
echo "========================================"
echo "SOLUTION 1: Variables and Echo"
echo "========================================"
echo "Task: Create variables and echo them"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'name="Alice"'
echo 'favorite_number=42'
echo 'echo "Name: $name"'
echo 'echo "Favorite number: $favorite_number"'
echo ""
echo "Running solution:"
name="Alice"
favorite_number=42
echo "Name: $name"
echo "Favorite number: $favorite_number"
echo ""

# ===== SOLUTION 2 =====
echo "========================================"
echo "SOLUTION 2: File Checking"
echo "========================================"
echo "Task: Check if a file exists"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'file=$1'
echo 'if [ -f $file ]; then'
echo '    echo "File found: $file"'
echo 'else'
echo '    echo "File not found: $file"'
echo 'fi'
echo ""
echo "Running solution:"

# Create a temporary script
cat > temp_exercise_2.sh << 'EOFSCRIPT'
#!/bin/bash
file=$1
if [ -f $file ]; then
    echo "File found: $file"
else
    echo "File not found: $file"
fi
EOFSCRIPT

bash temp_exercise_2.sh exercise_data/sequences.fasta
echo ""

# ===== SOLUTION 3 =====
echo "========================================"
echo "SOLUTION 3: For Loop - Count Files"
echo "========================================"
echo "Task: Loop through FASTA files and count sequences"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'for file in exercise_data/*.fasta; do'
echo '    count=$(grep -c "^>" $file)'
echo '    echo "$file: $count sequences"'
echo 'done'
echo ""
echo "Running solution:"

for file in exercise_data/*.fasta; do
    count=$(grep -c "^>" $file)
    echo "$file: $count sequences"
done
echo ""

# ===== SOLUTION 4 =====
echo "========================================"
echo "SOLUTION 4: While Loop - Counter"
echo "========================================"
echo "Task: Count from 1 to N"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'N=$1'
echo 'counter=1'
echo 'while [ $counter -le $N ]; do'
echo '    echo "Iteration $counter"'
echo '    counter=$((counter + 1))'
echo 'done'
echo ""
echo "Running solution (with N=3):"

cat > temp_exercise_4.sh << 'EOFSCRIPT'
#!/bin/bash
N=$1
counter=1
while [ $counter -le $N ]; do
    echo "Iteration $counter"
    counter=$((counter + 1))
done
EOFSCRIPT

bash temp_exercise_4.sh 3
echo ""

# ===== SOLUTION 5 =====
echo "========================================"
echo "SOLUTION 5: Function - Validate FASTA"
echo "========================================"
echo "Task: Create a function to validate FASTA files"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'is_valid_fasta() {'
echo '    [ -f $1 ] && grep -q "^>" $1'
echo '}'
echo 'file="exercise_data/sequences.fasta"'
echo 'if is_valid_fasta $file; then'
echo '    echo "Valid FASTA"'
echo 'else'
echo '    echo "Not a FASTA file"'
echo 'fi'
echo ""
echo "Running solution:"

cat > temp_exercise_5.sh << 'EOFSCRIPT'
#!/bin/bash
is_valid_fasta() {
    [ -f $1 ] && grep -q "^>" $1
}
file="exercise_data/sequences.fasta"
if is_valid_fasta $file; then
    echo "Valid FASTA"
else
    echo "Not a FASTA file"
fi
EOFSCRIPT

bash temp_exercise_5.sh
echo ""

# ===== SOLUTION 6 =====
echo "========================================"
echo "SOLUTION 6: Process Multiple Files"
echo "========================================"
echo "Task: Count reads and high-quality reads in FASTQ files"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'for fastq in exercise_data/*.fastq; do'
echo '    total=$(grep -c "^@" $fastq)'
echo '    # Count lines where 4th line (quality) has >10 I characters'
echo '    high_q=$(awk "NR % 4 == 0 && gsub(/I/, \"I\") > 10" $fastq | wc -l)'
echo '    echo "$fastq: $total reads, $high_q high-quality"'
echo 'done'
echo ""
echo "Running solution:"

for fastq in exercise_data/*.fastq; do
    total=$(grep -c "^@" $fastq)
    high_q=$(awk 'NR % 4 == 0 && gsub(/I/, "I") > 10 { count++ } END { print count }' $fastq)
    echo "$fastq: $total reads, $high_q high-quality"
done
echo ""

# ===== SOLUTION 7 =====
echo "========================================"
echo "SOLUTION 7: Sequence Statistics"
echo "========================================"
echo "Task: Calculate sequence statistics"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'file=$1'
echo 'count=$(grep -c "^>" $file)'
echo 'longest=$(grep -v "^>" $file | awk "{print length}" | sort -rn | head -n 1)'
echo 'shortest=$(grep -v "^>" $file | awk "{print length}" | sort -n | head -n 1)'
echo 'echo "$file: $count sequences"'
echo 'echo "Longest: $longest bases"'
echo 'echo "Shortest: $shortest bases"'
echo ""
echo "Running solution:"

cat > temp_exercise_7.sh << 'EOFSCRIPT'
#!/bin/bash
file=$1
count=$(grep -c "^>" $file)
longest=$(grep -v "^>" $file | awk '{print length}' | sort -rn | head -n 1)
shortest=$(grep -v "^>" $file | awk '{print length}' | sort -n | head -n 1)
echo "$file: $count sequences"
echo "Longest: $longest bases"
echo "Shortest: $shortest bases"
EOFSCRIPT

bash temp_exercise_7.sh exercise_data/sequences.fasta
echo ""

# ===== SOLUTION 8 =====
echo "========================================"
echo "SOLUTION 8: Batch Rename Files"
echo "========================================"
echo "Task: Rename files with a prefix"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'mkdir -p processed'
echo 'for file in exercise_data/*.fastq; do'
echo '    name=$(basename $file)'
echo '    cp $file processed/processed_$name'
echo '    echo "Copied: $name -> processed_$name"'
echo 'done'
echo ""
echo "Running solution:"

mkdir -p processed

for file in exercise_data/*.fastq; do
    name=$(basename $file)
    cp $file processed/processed_$name
    echo "Copied: $name -> processed_$name"
done
echo ""

# ===== SOLUTION 9 =====
echo "========================================"
echo "SOLUTION 9: Generate Report"
echo "========================================"
echo "Task: Create a CSV report of FASTA statistics"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'dir=$1'
echo 'echo "Filename,Sequences,Total_Bases" > report.csv'
echo 'for file in $dir/*.fasta; do'
echo '    name=$(basename $file)'
echo '    seqs=$(grep -c "^>" $file)'
echo '    bases=$(grep -v "^>" $file | wc -c)'
echo '    echo "$name,$seqs,$bases" >> report.csv'
echo 'done'
echo ""
echo "Running solution:"

cat > temp_exercise_9.sh << 'EOFSCRIPT'
#!/bin/bash
dir=$1
echo "Filename,Sequences,Total_Bases" > report.csv
for file in $dir/*.fasta; do
    name=$(basename $file)
    seqs=$(grep -c "^>" $file)
    bases=$(grep -v "^>" $file | wc -c)
    echo "$name,$seqs,$bases" >> report.csv
done
EOFSCRIPT

bash temp_exercise_9.sh exercise_data
echo ""
echo "Contents of report.csv:"
head -n 3 report.csv
echo ""

# ===== SOLUTION 10 =====
echo "========================================"
echo "SOLUTION 10: Complete Pipeline Script"
echo "========================================"
echo "Task: Quality control pipeline"
echo ""
echo "Reference Solution:"
echo '#!/bin/bash'
echo 'fastq=$1'
echo 'threshold=$2'
echo 'total=$(grep -c "^@" $fastq)'
echo 'high_q=$(awk "NR % 4 == 0 && length > $threshold" $fastq | wc -l)'
echo 'percentage=$((high_q * 100 / total))'
echo 'echo "Quality Report" > quality_report.txt'
echo 'echo "==============" >> quality_report.txt'
echo 'echo "Input file: $fastq" >> quality_report.txt'
echo 'echo "Total reads: $total" >> quality_report.txt'
echo 'echo "High-quality reads: $high_q" >> quality_report.txt'
echo 'echo "Percentage passing: $percentage%" >> quality_report.txt'
echo ""
echo "Running solution:"

cat > temp_exercise_10.sh << 'EOFSCRIPT'
#!/bin/bash
fastq=$1
threshold=$2
total=$(grep -c "^@" $fastq)
# Quality lines with length > threshold
high_q=$(awk 'NR % 4 == 0 && length > '$threshold' { count++ } END { print count }' $fastq)
percentage=$((high_q * 100 / total))
echo "Quality Report" > quality_report.txt
echo "==============" >> quality_report.txt
echo "Input file: $fastq" >> quality_report.txt
echo "Total reads: $total" >> quality_report.txt
echo "High-quality reads: $high_q" >> quality_report.txt
echo "Percentage passing: $percentage%" >> quality_report.txt
EOFSCRIPT

bash temp_exercise_10.sh exercise_data/reads.fastq 10
echo ""
echo "Contents of quality_report.txt:"
cat quality_report.txt
echo ""

# Cleanup
echo "========================================"
echo "SUMMARY"
echo "========================================"
echo ""
echo "All solutions executed successfully!"
echo ""
echo "Key concepts demonstrated:"
echo "  1. Variables and string echo"
echo "  2. Conditional file checking"
echo "  3. For loops with file globbing"
echo "  4. While loops with counters"
echo "  5. Functions with return values"
echo "  6. Processing multiple files"
echo "  7. Statistical calculations (max, min)"
echo "  8. File operations (copy, rename)"
echo "  9. CSV generation"
echo " 10. Complete pipeline with reporting"
echo ""
echo "Clean up temporary files:"
rm -f temp_exercise_*.sh
rm -rf processed/
rm -f report.csv quality_report.txt
rm -rf exercise_data/
echo "  ✓ Cleaned up test files"
echo ""
echo "Next steps:"
echo "  1. Try solving the exercises yourself"
echo "  2. Compare your solutions to these references"
echo "  3. Try alternative approaches (multiple solutions are valid!)"
echo "  4. Move to Lesson 3: Git & Version Control"
echo ""