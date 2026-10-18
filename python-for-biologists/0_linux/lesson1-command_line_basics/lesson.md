# Lesson 1: Command-Line Basics

**Objective:** Understand the Linux file system and master essential commands for file navigation, searching, and processing.

**Time:** 3 hours

## What You'll Learn

By the end of this lesson, you'll be able to:
- Navigate the file system confidently (pwd, cd, ls)
- Understand file paths (absolute vs. relative)
- Search and filter text (grep, find, pipes)
- Understand input/output redirection (<, >, >>)
- Peek inside bioinformatics files (FASTA, FASTQ, VCF)

## Why This Matters in Bioinformatics

A typical RNA-seq workflow:
1. **Download reads** from a sequencing machine → `sample.fastq` (5 GB)
2. **Filter by quality** using grep/awk → removes bad reads
3. **Check file size** with `ls` and `wc` → 5 GB → 3 GB
4. **Count total reads** with `grep` → 50 million reads
5. **Extract first 1000 reads** with `head` → for testing

Every step uses command-line tools. Python can't efficiently handle gigabyte files—bash can.

---

## Part 1: Understanding the File System

### The Directory Structure

Linux organizes files in a tree:
```
/                           # Root directory (the beginning of everything)
├── home/                   # Home directories for users
│   └── fuad/               # Your home directory (~)
│       ├── Documents/
│       ├── Desktop/
│       └── bioinformatics/ # Your projects go here
├── usr/                    # System programs
├── var/                    # System data
└── tmp/                    # Temporary files
```

Your **home directory** is `/home/fuad/` (or `/Users/fuad` on macOS).
Shortcut: `~` means your home directory.

### Key Concepts

**Absolute path:** Starts from `/`
```
/home/fuad/bioinformatics/data/sample.fasta
```

**Relative path:** Relative to where you are now
```
If you're in /home/fuad/, then:
bioinformatics/data/sample.fasta  (means ./bioinformatics/...)
../Desktop/file.txt               (go up one level, then Desktop)
```

---

## Part 2: Essential Commands

### 1. **pwd** — Print Working Directory

Shows where you are right now.

```bash
pwd
# Output: /home/fuad
```

Use it: Whenever you're confused about which folder you're in.

---

### 2. **ls** — List Files

Shows all files and folders in the current directory.

```bash
ls
# Output: Documents  Desktop  bioinformatics

# List with details (size, date, permissions)
ls -l
# Output:
# drwxr-xr-x 5 fuad fuad 4096 Aug 30 10:20 bioinformatics
# drwxr-xr-x 3 fuad fuad 4096 Aug 25 14:30 Documents
# -rw-r--r-- 1 fuad fuad 1024 Aug 29 09:15 file.txt

# List hidden files too (ones starting with .)
ls -la

# List with human-readable sizes (KB, MB, GB)
ls -lh
```

Read `ls -l` output:
```
drwxr-xr-x  5  fuad  fuad  4096  Aug 30 10:20  bioinformatics
│ permissions    owner group  size  date/time     filename
d = directory
- = regular file
rwx = read, write, execute for owner
r-x = read, execute for group
r-x = read, execute for others
```

---

### 3. **cd** — Change Directory

Move to a different folder.

```bash
# Go to a folder
cd bioinformatics
pwd
# Output: /home/fuad/bioinformatics

# Go up one level (to parent directory)
cd ..
pwd
# Output: /home/fuad

# Go to home directory
cd ~
# or just
cd

# Go to absolute path
cd /tmp
pwd
# Output: /tmp
```

---

### 4. **mkdir** — Make Directory

Create a new folder.

```bash
mkdir my_project
# Creates a folder called 'my_project'

# Create nested directories
mkdir -p data/sequences/fasta
# Creates data/, then data/sequences/, then data/sequences/fasta/
```

---

### 5. **cp** — Copy Files

Copy a file from one place to another.

```bash
# Copy a single file
cp file.txt backup.txt
# Makes a copy called backup.txt

# Copy a file to a different folder
cp file.txt ../Documents/
# Copies to the Documents folder

# Copy a whole directory (with -r flag)
cp -r my_project my_project_backup
# Copies the folder and everything inside it
```

---

### 6. **mv** — Move or Rename

Move files to a different folder, or rename them.

```bash
# Rename a file
mv old_name.txt new_name.txt

# Move a file to a different folder
mv file.txt ../Documents/
# File is no longer in current directory

# Move and rename
mv file.txt ../Documents/new_name.txt
```

---

### 7. **rm** — Remove (Delete)

Delete files or folders. **Warning: No undo button!**

```bash
# Delete a file
rm file.txt

# Delete multiple files
rm file1.txt file2.txt file3.txt

# Delete a directory and everything inside it
rm -r my_folder
# -r = recursive (delete folder + all contents)
```

**Safety tip:** Use `ls` before `rm` to double-check what you're deleting.

---

### 8. **cat** — Display File Contents (concatenate)

Print the entire contents of a file.

```bash
cat sequence.fasta
# Output: Prints all lines of the file

# Combine files
cat file1.txt file2.txt
# Outputs both files, one after another
```

**Problem:** For huge files (like 5GB FASTQ), this is slow and unreadable.
**Solution:** Use `head` and `tail` instead.

---

### 9. **head** and **tail** — View File Portions

View the first or last N lines of a file (fast, even for huge files).

```bash
# First 10 lines
head sample.fastq

# First 3 lines
head -n 3 sample.fastq

# Last 10 lines
tail sample.fastq

# Last 5 lines
tail -n 5 sample.fastq
```

**In bioinformatics:** Always use `head` to "peek inside" a file before processing it.

```bash
head sample.fasta
# Output:
# >sequence_1
# ATGCATGCATGCATGCATGC
# >sequence_2
# ATGCATGCATGCATGCATGC
```

---

### 10. **wc** — Word/Line Count

Count lines, words, or characters.

```bash
# Count lines
wc -l sample.fastq
# Output: 400000 sample.fastq
# (400,000 lines in the file)

# In FASTQ, each sequence = 4 lines
# So 400,000 lines = 100,000 sequences

# Count words
wc -w file.txt

# Count characters
wc -c file.txt

# Count all three at once
wc file.txt
```

---

### 11. **grep** — Search Text (Global Regular Expression Print)

Find lines matching a pattern.

```bash
# Find all lines containing "ATGC"
grep "ATGC" sequences.fasta

# Count matching lines (instead of printing them)
grep -c "ATGC" sequences.fasta
# Output: 45
# (45 lines contain ATGC)

# Find lines that DON'T match
grep -v "ATGC" sequences.fasta

# Make search case-insensitive
grep -i "atgc" sequences.fasta

# Show line numbers
grep -n "ATGC" sequences.fasta

# Combine multiple flags
grep -cn ">seq" sequences.fasta
# Counts lines starting with ">seq" (sequence headers)
```

**Example in bioinformatics:**
```bash
# Count how many sequences are in a FASTA file
grep -c "^>" sequences.fasta
# ^> means "lines starting with >"

# Extract specific sequences
grep -A 1 ">seq_5" sequences.fasta
# -A 1 means "print matching line plus 1 line after"
# Output:
# >seq_5
# ATGCATGCATGCATGC
```

---

### 12. **find** — Search for Files

Find files by name, size, type, or date.

```bash
# Find all .txt files in current directory
find . -name "*.txt"

# Find all .fasta files in current directory and subdirectories
find . -name "*.fasta"

# Find files larger than 1 MB
find . -size +1M

# Find files modified in the last 7 days
find . -mtime -7

# Combine multiple conditions
find . -name "*.fasta" -size -10M
# Files ending in .fasta AND smaller than 10MB
```

---

## Part 3: Pipes and Redirection

### Pipes: `|`

Send output from one command as input to another. This is **powerful**.

```bash
# Count how many sequences are in a FASTA file
grep "^>" sequences.fasta | wc -l
# grep finds all header lines
# | pipes them to wc
# wc counts them

# Find lines with "ATGC", then count them
grep "ATGC" sequences.fasta | wc -l

# Find long sequences (>100 characters)
# First, extract sequence lines (skip headers)
grep -v "^>" sequences.fasta | awk 'length($0) > 100'
```

### Redirection: `>` and `>>`

Save output to a file instead of printing it.

```bash
# Save output to a new file
grep "^>" sequences.fasta > headers.txt
# Creates headers.txt with all header lines

# Append to an existing file
echo "Analysis complete" >> results.txt
# Adds a line to results.txt without overwriting it

# Redirect error messages
command_that_fails 2> errors.log
# 2> means "redirect errors (file descriptor 2) to errors.log"

# Redirect both output and errors
command 1> output.log 2> errors.log
# 1> is standard output, 2> is standard error
```

---

## Part 4: Looking Inside Bioinformatics Files

### FASTA Format

DNA or protein sequences. Each sequence has a header and bases/amino acids.

```
>sequence_1 |length=100
ATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGCATGC
ATGCATGCATGCATGC
>sequence_2 |length=50
ATGCATGCATGCATGCATGC
```

**How to check a FASTA file:**
```bash
head sequences.fasta
# Check if it looks right

wc -l sequences.fasta
# If there are N lines, roughly N/2 sequences

grep -c "^>" sequences.fasta
# Exact count of sequences

# Check for duplicate headers
grep "^>" sequences.fasta | sort | uniq -d
# Shows headers that appear more than once
```

### FASTQ Format

Sequencing reads with quality scores. Each read = 4 lines.

```
@read_1
ATGCATGCATGCATGC
+
IIIIIIIIIIIIIIII
@read_2
ATGCATGCATGCATGC
+
IIIIIIIIIIHHHHHH
```

**How to check a FASTQ file:**
```bash
# Peek at the first read
head -n 4 sample.fastq

# Count total reads (lines / 4)
wc -l sample.fastq | awk '{print $1 / 4}'

# Check quality scores
head sample.fastq | tail -n 1
# Last line of first read = quality scores
```

### VCF (Variant Call Format)

Variant data (SNPs, indels). Tab-separated text.

```
##fileformat=VCFv4.2
##INFO=<ID=DP,Number=1,Type=Integer,Description="Read Depth">
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO
chr1    1000    .       A       T       60      PASS    DP=100
chr1    2000    .       C       G       45      PASS    DP=80
```

**How to check a VCF file:**
```bash
# Skip headers, show first variant
grep -v "^#" sample.vcf | head -n 1

# Count total variants
grep -c -v "^#" sample.vcf

# Extract specific columns (with awk)
grep -v "^#" sample.vcf | cut -f1,2,4,5
# Shows: CHROM, POS, REF, ALT
```

---

## Part 5: Combining Everything

A realistic bioinformatics task:

```bash
# Task: Filter a FASTQ file to keep only reads with quality > 90%

# Step 1: Check the file
head sample.fastq
wc -l sample.fastq

# Step 2: Write a script to extract high-quality reads
# (We'll do this in Lesson 2 with bash scripting)

# For now, extract reads manually:
grep -n "^[ATGC]" sample.fastq | head
# Shows sequence lines (bases only, no quality info)

# Step 3: Save good reads to a new file
grep "IIIIII" sample.fastq > high_quality.fastq
# Saves reads with high-quality scores (I = Q40+)
```

---

## Summary of Key Commands

| Command   | What it does           | Example                            |
| --------- | ---------------------- | ---------------------------------- |
| `pwd`     | Show current directory | `pwd`                              |
| `ls`      | List files             | `ls -lh`                           |
| `cd`      | Change directory       | `cd data/`                         |
| `mkdir`   | Create directory       | `mkdir -p data/raw`                |
| `cp`      | Copy file              | `cp file.txt backup.txt`           |
| `mv`      | Move/rename file       | `mv file.txt new_name.txt`         |
| `rm`      | Delete file            | `rm file.txt`                      |
| `cat`     | Print file contents    | `cat data.txt`                     |
| `head`    | First N lines          | `head -n 10 large.fastq`           |
| `tail`    | Last N lines           | `tail -n 5 results.txt`            |
| `wc`      | Count lines            | `wc -l data.txt`                   |
| `grep`    | Search text            | `grep "ATGC" sequences.fasta`      |
| `find`    | Find files             | `find . -name "*.fasta"`           |
| \| (pipe) | Chain commands         | `grep "header" file.txt \| wc -l`  |
| `>`       | Redirect to file       | `grep "seq" data.txt > output.txt` |
| `>>`      | Append to file         | `echo "done" >> log.txt`           |

---

## Practice Tips

1. **Type every command.** Don't copy-paste. Your fingers need to learn.
2. **Experiment first.** Before deleting anything, check with `ls`.
3. **Use `head` liberally.** Check files before processing them.
4. **Combine pipes gradually.** First test `grep`, then add a pipe and test that.

Example workflow:
```bash
# Test step 1
grep "^>" sequences.fasta | head

# Test step 2
grep "^>" sequences.fasta | wc -l

# Final command (now you're confident)
grep "^>" sequences.fasta > headers.txt
```

---

## What's Next?

After mastering these commands, you'll move to Lesson 2: **Bash Scripting**.
You'll write **scripts** that automate these tasks. Instead of typing commands one by one, a script runs them all in sequence.

But first: **do the exercises!** They're in `exercises.sh`.

---

**Ready?** Open `exercises.sh` and start solving problems.
