# Python for Bioinformatics: A Complete Learning Path

**A 9-phase, 8-10 month curriculum from Linux basics to job-ready bioinformatician.**

## About This Repository

This repo teaches computational biology through real projects and datasets. You'll learn Python, statistics, and bioinformatics tools by building actual analyses—not toy problems.

**By the end, you'll have:**
- 4 portfolio projects (RNA-seq, variant annotation, protein prediction, custom tool)
- Mastery of Python + Pandas + Biopython
- Understanding of algorithms behind BLAST, alignment, phylogenetics
- Statistical foundation for interpreting biological data
- Professional-grade CLI tools ready to show employers

## Timeline & Phases (32 weeks total)

| Phase | Duration | Focus                     |
| ----- | -------- | ------------------------- |
| 0     | 2 weeks  | Linux, Bash, Git          |
| 1     | 3 weeks  | Python Fundamentals       |
| 2     | 2 weeks  | NumPy                     |
| 3     | 3 weeks  | Pandas                    |
| 4     | 3 weeks  | Statistics                |
| 5     | 2 weeks  | Visualization             |
| 6     | 3 weeks  | Biopython                 |
| 7     | 3 weeks  | Bioinformatics Algorithms |
| 8     | 4 weeks  | Machine Learning          |
| 9     | 7 weeks  | Capstone Projects         |

## How to Use This Repo

### 1. **Clone and setup**
```bash
git clone https://github.com/Fuad8548/python-bioinformatics.git
cd python-bioinformatics
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
pip install -r requirements.txt
```

### 2. **Start with Phase 0**
```bash
cd phase-0-linux-git/01-command-line-basics
cat lesson.md           # Read the tutorial
cat examples.sh         # Study the examples
bash exercises.sh       # Solve the problems
bash solutions.sh       # Check your answers
```

### 3. **Structure of each lesson**
Each lesson folder contains:
- `lesson.md` — Comprehensive tutorial (what you need to know)
- `examples.sh` — Annotated code showing the concept in action
- `exercises.sh` — Problems for you to solve (answers at bottom)
- `solutions.sh` — Reference answers with detailed explanations
- `README.md` — Lesson objectives and biological context

### 4. **Mini-projects**
After completing a phase's lessons, do the mini-projects:
```bash
cd phase-0-linux-git/mini-projects
cat 01-fasta-analyzer.md          # Read the project spec
# Complete the 8 tasks and 3 challenges
bash 01-fasta-analyzer-solutions.sh  # Reference solution
```

### 5. **Capstone projects (Phase 9)**
At the end, you'll have 4 complete projects in `phase-9-capstone/`:
- Each is a real bioinformatics problem
- Each produces a polished deliverable (script, report, or tool)
- These go in your GitHub portfolio

## What You Need

### System Requirements
- Linux or macOS (Windows: WSL 2)
- Python 3.10+
- 2-4 hours/week for 8 months

### Optional but Helpful
- Basic understanding of biology (transcription, DNA sequences, proteins)
- GitHub account (for version control practice in Phase 0)
- Text editor or IDE (VS Code, PyCharm, or `nano`)

## Key Datasets Included

Each phase uses real data from public repositories:
- **FASTQ sequences** — NGS reads (NCBI SRA)
- **Gene expression** — TCGA, GEO databases
- **Variant data** — 1000 Genomes VCF files
- **Protein sequences** — UniProt, PDB
- **Alignment files** — Example BAM, SAM

All datasets are curated and included in the `datasets/` folder — no downloads needed.

## Philosophy

**Project-first learning.** You don't learn loops in isolation—you use them to process DNA sequences. Statistics isn't abstract—it's testing whether expression differences are significant.

**Biological context from day one.** Every lesson explains *why* a concept matters in bioinformatics, not just how it works.

**Real tools, real data.** By Phase 6, you're using BLAST, parsing GenBank files, and querying NCBI. Not simulated versions.

**Portfolio-ready output.** Phases 1–8 build toward Phase 9 capstone projects that you can show employers or use in grad school applications.

## Repository Structure

```
python-bioinformatics/
├── README.md (this file)
├── requirements.txt
├── .gitignore
├── phase-0-linux-git/
│   ├── 01-command-line-basics/
│   ├── 02-bash-scripting/
│   ├── 03-git-version-control/
│   ├── mini-projects/
│   └── README.md
├── phase-1-python-fundamentals/
│   ├── 01-variables-datatypes/
│   ├── 02-functions-control-flow/
│   ├── 03-strings-sequences/
│   ├── 04-file-io/
│   ├── mini-projects/
│   └── README.md
├── phase-2-numpy/
├── phase-3-pandas/
├── phase-4-statistics/
├── phase-5-visualization/
├── phase-6-biopython/
├── phase-7-algorithms/
├── phase-8-machine-learning/
├── phase-9-capstone/
│   ├── project-1-rnaseq-pipeline/
│   ├── project-2-variant-annotation/
│   ├── project-3-protein-prediction/
│   └── project-4-custom-tool/
├── datasets/ (curated public data)
├── utils/ (reusable Python modules)
└── docs/ (reference guides and cheat sheets)
```

## Getting Help

- **Stuck on a lesson?** Check the `solutions.sh` or `README.md` for that lesson
- **Don't understand a concept?** Reread the `lesson.md` and try the `examples.sh` code yourself
- **Want to dig deeper?** See `docs/` for cheat sheets and links to external resources
- **Ready to contribute?** Fork this repo and submit improvements via GitHub

## Learning Tips

1. **Type, don't copy-paste.** Typing builds muscle memory. Copy-paste builds nothing.
2. **Run examples before doing exercises.** See how the concept works in action first.
3. **Read the solutions after.** Check your answer, but also read the solution explanation—you'll learn different approaches.
4. **Do mini-projects immediately after each phase.** Don't move on until you've integrated all the phase's concepts.
5. **Keep a learning journal.** Write down what confused you, what clicked, what you built. This helps cement learning.

## FAQ

**Q: Do I need a biology background?**
A: No. We explain biological concepts as needed. A high-school understanding of DNA is enough.

**Q: Can I do this on Windows?**
A: Yes—use Windows Subsystem for Linux (WSL 2). Phase 0 has setup instructions.

**Q: How much time per week?**
A: 8-12 hours/week is ideal. 32 weeks × 10 hours = 320 hours total. You can spread it over longer.

**Q: Can I skip Phase 0 (Linux)?**
A: Not recommended. By Phase 6, you're processing massive genomics files. Bash is essential.

**Q: Do I need to know Python first?**
A: No. Phase 1 assumes no prior Python experience.

## Contributing

Found a typo? Better example? Please contribute! Fork the repo and submit a pull request.

## License

MIT License. Feel free to use, modify, and share.

---

**Ready to start?** Go to `phase-0-linux-git/01-command-line-basics/` and open `lesson.md`.

Good luck! 🧬🐍
