# Phase 0: Linux, Bash & Git Essentials

**Duration:** Weeks 1–2 (10 hours total)

## Why This Phase?

Every bioinformatician lives on Linux. Your data—FASTQ files with millions of reads, BAM files with alignments, VCF files with variants—lives in text. You'll spend more time at the command line than in Python.

This phase teaches you to:
- Navigate the file system (pwd, ls, cd)
- Search and process text files (grep, sed, awk, pipes)
- Write simple automation scripts (bash loops, functions)
- Version control your code (git, GitHub)
- Understand bioinformatics file formats (FASTQ, BAM, VCF)

By the end, you'll be comfortable running real bioinformatics tools and processing real genomic data.

## Lessons

### Lesson 1: Command-Line Basics (3 hours)
Master essential Linux commands and file operations.
- **Learn:** pwd, cd, ls, mkdir, cp, mv, rm, grep, find, pipes, redirection
- **Do:** Work with real FASTA and FASTQ files
- **Build:** A FASTA analyzer (count sequences, calculate stats)

### Lesson 2: Bash Scripting (4 hours)
Write scripts that automate repetitive tasks.
- **Learn:** Variables, loops, functions, conditionals
- **Do:** Build a FASTQ quality filter script
- **Build:** A bioinformatics pipeline (file processing automation)

### Lesson 3: Git & Version Control (3 hours)
Track changes and collaborate on code.
- **Learn:** git init, add, commit, push, pull, branches
- **Do:** Push your scripts to GitHub
- **Build:** A proper project repo structure

## Mini-Projects

After Lesson 3, complete the mini-project:

### Mini-Project 1: FASTA Sequence Analyzer
Write a bash script that:
1. Counts sequences in a FASTA file
2. Calculates sequence lengths
3. Finds the longest/shortest sequence
4. Reports GC content for each sequence
5. Handles edge cases (empty files, malformed data)

**Deliverable:** A polished, documented bash script + results report

## Biological Context

Why Linux? Because bioinformatics is "big data biology."

- A single RNA-seq experiment produces 50–200 million reads
- Each read is ~100 base pairs
- That's 5–20 **gigabytes** of text data per sample
- You can't open gigabyte files in Excel or import them to a Python list

Solution? Process text files with **Linux command-line tools**. A single `grep` command can search 20GB of data in seconds.

## What's Next?

After Phase 0, you'll know:
- How to work with real genomic data files
- How to write scripts that automate tasks
- How to track your code in version control

Phase 1 (Python Fundamentals) builds on this. You'll use Python to *parse* files and *analyze* data—but the files themselves? You'll prep them with bash.

---

**Let's begin:** Open `01-command-line-basics/lesson.md`
