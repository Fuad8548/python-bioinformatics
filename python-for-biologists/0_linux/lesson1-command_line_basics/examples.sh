#!/bin/bash

# Phase 0, Lesson 1: Command-Line Basics - Examples
# This file shows 50+ runnable examples of essential Linux commands
# To use: bash examples.sh (or source examples.sh)

# Note: These examples assume you have sample data in a 'data/' folder
# If you don't, they'll show you the expected output anyway

echo "===== Phase 0, Lesson 1: Command-Line Basics - Examples ====="
echo ""

# ============================================================
# PART 1: Navigation and File Listing
# ============================================================

echo "--- PART 1: Navigation and File Listing ---"
echo ""

# Example 1: Show current directory
echo "1. Show current directory (pwd):"
echo "   Command: pwd"
echo "   Expected output: /home/fuad/python-bioinformatics"
pwd
echo ""

# Example 2: List files in current directory
echo "2. List files (ls):"
echo "   Command: ls"
ls | head -n 5  # Show first 5 items
echo ""

# Example 3: List files with details
echo "3. List files with details (ls -l):"
echo "   Command: ls -l"
ls -l | head -n 3  # Show first 3 lines
echo ""

# Example 4: List files with human-readable sizes
echo "4. List files with human-readable sizes (ls -lh):"
echo "   Command: ls -lh"
ls -lh | head -n 3
echo ""

# Example 5: Change directory
echo "5. Change directory (cd):"
echo "   Command: cd phase-0-linux-git"
echo "   Note: We're just showing the command; to actually change directories,"
echo "   you need to run 'source' this file or type commands manually"
echo ""

# ============================================================
# PART 2: File Operations
# ============================================================

echo "--- PART 2: File Operations ---"
echo ""

# Create a test directory and files for demonstration
mkdir -p test_data

# Example 6: Create files
echo "6. Create a test file:"
echo ">sequence_1" > test_data/sample.fasta
echo "ATGCATGCATGCATGC" >> test_data/sample.fasta
echo ">sequence_2" >> test_data/sample.fasta
echo "GCTAGCTAGCTAGCTA" >> test_data/sample.fasta
echo "   Created: test_data/sample.fasta"
echo "   Contents:"
cat test_data/sample.fasta
echo ""

# Example 7: Copy a file
echo "7. Copy a file (cp):"
echo "   Command: cp test_data/sample.fasta test_data/sample_backup.fasta"
cp test_data/sample.fasta test_data/sample_backup.fasta
echo "   Result:"
ls -l test_data/sample*
echo ""

# Example 8: Display file contents
echo "8. Display file contents (cat):"
echo "   Command: cat test_data/sample.fasta"
cat test_data/sample.fasta
echo ""

# ============================================================
# PART 3: Viewing Large Files
# ============================================================

echo "--- PART 3: Viewing Large Files (head, tail) ---"
echo ""

# Create a larger test file (FASTQ format)
cat > test_data/sample.fastq << 'EOF'
@read_1
ATGCATGCATGCATGC
+
IIIIIIIIIIIIIIII
@read_2
ATGCATGCATGCATGC
+
IIIIIIIIHHHHHHHH
@read_3
GCTAGCTAGCTAGCTA
+
IIIHHHHHHHHHHHHH
EOF

echo "9. View first N lines (head):"
echo "   Command: head -n 4 test_data/sample.fastq"
head -n 4 test_data/sample.fastq
echo ""

echo "10. View last N lines (tail):"
echo "    Command: tail -n 4 test_data/sample.fastq"
tail -n 4 test_data/sample.fastq
echo ""

# ============================================================
# PART 4: Counting and Searching
# ============================================================

echo "--- PART 4: Counting and Searching (wc, grep) ---"
echo ""

echo "11. Count lines in a file (wc -l):"
echo "    Command: wc -l test_data/sample.fastq"
wc -l test_data/sample.fastq
echo "    → 12 lines total (3 reads × 4 lines each)"
echo ""

echo "12. Search for lines containing a pattern (grep):"
echo "    Command: grep '^@' test_data/sample.fastq"
echo "    (Find all lines starting with '@' = read headers)"
grep "^@" test_data/sample.fastq
echo ""

echo "13. Count matching lines (grep -c):"
echo "    Command: grep -c '^@' test_data/sample.fastq"
grep -c "^@" test_data/sample.fastq
echo "    → 3 reads (matches the 3 @read lines)"
echo ""

echo "14. Find lines NOT matching (grep -v):"
echo "    Command: grep -v '^@' test_data/sample.fastq"
echo "    (Skip header lines, show sequences and quality)"
grep -v "^@" test_data/sample.fastq
echo ""

echo "15. Show line numbers with matches (grep -n):"
echo "    Command: grep -n 'ATGC' test_data/sample.fastq"
grep -n "ATGC" test_data/sample.fastq
echo ""

# ============================================================
# PART 5: FASTA-Specific Operations
# ============================================================

echo "--- PART 5: FASTA-Specific Operations ---"
echo ""

echo "16. Count sequences in a FASTA file:"
echo "    Command: grep -c '^>' test_data/sample.fasta"
grep -c "^>" test_data/sample.fasta
echo "    → 2 sequences"
echo ""

echo "17. Extract sequence headers:"
echo "    Command: grep '^>' test_data/sample.fasta"
grep "^>" test_data/sample.fasta
echo ""

echo "18. Extract a specific sequence (header + sequence):"
echo "    Command: grep -A 1 '^>sequence_1' test_data/sample.fasta"
echo "    (-A 1 means print the match plus 1 line after)"
grep -A 1 "^>sequence_1" test_data/sample.fasta
echo ""

# ============================================================
# PART 6: Piping and Combining Commands
# ============================================================

echo "--- PART 6: Piping and Combining Commands ---"
echo ""

echo "19. Count sequences using a pipe:"
echo "    Command: grep '^>' test_data/sample.fasta | wc -l"
echo "    (Find headers, then count them)"
grep "^>" test_data/sample.fasta | wc -l
echo ""

echo "20. Find lines with specific content AND count them:"
echo "    Command: grep 'ATG' test_data/sample.fasta | wc -l"
echo "    (Find sequences with ATG, then count matches)"
grep "ATG" test_data/sample.fasta | wc -l
echo ""

echo "21. Sort output:"
echo "    Command: grep '^>' test_data/sample.fasta | sort"
grep "^>" test_data/sample.fasta | sort
echo ""

# ============================================================
# PART 7: Redirection
# ============================================================

echo "--- PART 7: Redirection (>, >>) ---"
echo ""

echo "22. Save output to a file (>):"
echo "    Command: grep '^>' test_data/sample.fasta > test_data/headers.txt"
grep "^>" test_data/sample.fasta > test_data/headers.txt
echo "    Created: test_data/headers.txt"
echo "    Contents:"
cat test_data/headers.txt
echo ""

echo "23. Append to a file (>>):"
echo "    Command: echo 'Analysis complete' >> test_data/headers.txt"
echo "Analysis complete" >> test_data/headers.txt
echo "    Updated file:"
cat test_data/headers.txt
echo ""

# ============================================================
# PART 8: Advanced grep Examples
# ============================================================

echo "--- PART 8: Advanced grep Examples ---"
echo ""

echo "24. Case-insensitive search (grep -i):"
echo "    Command: grep -i 'atgc' test_data/sample.fasta"
grep -i "atgc" test_data/sample.fasta
echo ""

echo "25. Search for exact word (grep -w):"
echo "    Command: grep -w 'ATGC' test_data/sample.fasta"
grep -w "ATGC" test_data/sample.fasta
echo ""

# ============================================================
# PART 9: Finding Files
# ============================================================

echo "--- PART 9: Finding Files (find) ---"
echo ""

echo "26. Find all .fasta files:"
echo "    Command: find test_data -name '*.fasta'"
find test_data -name "*.fasta"
echo ""

echo "27. Find all .fastq files:"
echo "    Command: find test_data -name '*.fastq'"
find test_data -name "*.fastq"
echo ""

echo "28. Find files larger than 100 bytes:"
echo "    Command: find test_data -size +100c"
find test_data -size +100c
echo ""

# ============================================================
# PART 10: Bioinformatics File Format Examples
# ============================================================

echo "--- PART 10: Bioinformatics File Formats ---"
echo ""

echo "29. Peek inside a FASTQ file (first read):"
echo "    Command: head -n 4 test_data/sample.fastq"
head -n 4 test_data/sample.fastq
echo ""

echo "30. Count bases in a sequence:"
echo "    Command: head -n 2 test_data/sample.fasta | tail -n 1 | wc -c"
echo "    (Get first sequence, then count characters)"
seq_length=$(head -n 2 test_data/sample.fasta | tail -n 1 | wc -c)
echo "    → $(($seq_length - 1)) bases (wc counts newline, so -1)"
echo ""

# ============================================================
# Cleanup
# ============================================================

echo "--- Summary ---"
echo ""
echo "All examples completed! Test files created in: test_data/"
echo ""
echo "Key takeaways:"
echo "  • Use 'pwd' to know where you are"
echo "  • Use 'ls' to see what's here"
echo "  • Use 'cd' to go somewhere"
echo "  • Use 'head' to peek at large files"
echo "  • Use 'grep' to search"
echo "  • Use 'wc -l' to count"
echo "  • Use pipes (|) to chain commands"
echo "  • Use '>' to save output"
echo ""
echo "Next: Open exercises.sh and solve the problems!"
echo ""
