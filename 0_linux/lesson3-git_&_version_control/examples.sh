cat > /home/claude/phase-0-lesson-3-examples.sh << 'EXAMPLEEOF'
#!/bin/bash

# Phase 0, Lesson 3: Git & Version Control - Examples
# This file demonstrates Git workflows with actual commands

echo "===== Phase 0, Lesson 3: Git & Version Control - Examples ====="
echo ""
echo "This lesson teaches Git by doing. Each example shows:"
echo "  • The Git command(s)"
echo "  • What it does"
echo "  • Expected output"
echo ""
echo "WARNING: These examples modify your file system!"
echo "They create a demo repository in git_demo/ folder"
echo ""

# Create a demo directory
demo_dir="git_demo_lesson3"
rm -rf "$demo_dir"
mkdir -p "$demo_dir"
cd "$demo_dir"

# ============================================================
# PART 1: Initialize a Repository
# ============================================================

echo "--- PART 1: Initialize and Basic Commits ---"
echo ""

echo "1. Initialize a Git repository:"
echo "   Command: git init"
git init
echo ""

echo "2. Check Git status:"
echo "   Command: git status"
git status
echo ""

echo "3. Create a file:"
echo "   Command: echo 'ATGC' > sequence.fasta"
echo "ATGC" > sequence.fasta
echo ""

echo "4. Check status (file not yet tracked):"
echo "   Command: git status"
git status
echo ""

echo "5. Stage the file:"
echo "   Command: git add sequence.fasta"
git add sequence.fasta
echo ""

echo "6. Check status (file staged):"
echo "   Command: git status"
git status
echo ""

echo "7. Commit the file:"
echo "   Command: git commit -m 'Add DNA sequence'"
git commit -m "Add DNA sequence"
echo ""

# ============================================================
# PART 2: View History
# ============================================================

echo "--- PART 2: View History ---"
echo ""

echo "8. View commit history (detailed):"
echo "   Command: git log"
git log
echo ""

echo "9. View commit history (short):"
echo "   Command: git log --oneline"
git log --oneline
echo ""

echo "10. View commit history (showing changes):"
echo "    Command: git log -p"
git log -p | head -n 20
echo ""

# ============================================================
# PART 3: Make Changes
# ============================================================

echo "--- PART 3: Making and Tracking Changes ---"
echo ""

echo "11. Modify the file:"
echo "    Command: echo 'GCTA' >> sequence.fasta"
echo "GCTA" >> sequence.fasta
echo ""

echo "12. View differences:"
echo "    Command: git diff"
git diff
echo ""

echo "13. Stage and commit the change:"
echo "    Commands:"
echo "      git add sequence.fasta"
echo "      git commit -m 'Add second sequence'"
git add sequence.fasta
git commit -m "Add second sequence"
echo ""

echo "14. View updated history:"
echo "    Command: git log --oneline"
git log --oneline
echo ""

# ============================================================
# PART 4: Branches
# ============================================================

echo "--- PART 4: Branches (Parallel Development) ---"
echo ""

echo "15. List branches:"
echo "    Command: git branch"
git branch
echo ""

echo "16. Create a new branch:"
echo "    Command: git checkout -b feature/add-quality-scores"
git checkout -b feature/add-quality-scores
echo ""

echo "17. Confirm we're on the new branch:"
echo "    Command: git branch"
git branch
echo ""

echo "18. Make changes on this branch:"
echo "    Command: echo 'Quality: IIIIII' >> sequence.fasta"
echo "Quality: IIIIII" >> sequence.fasta
git add sequence.fasta
git commit -m "Add quality scores"
echo ""

echo "19. View history on feature branch:"
echo "    Command: git log --oneline"
git log --oneline
echo ""

echo "20. Switch back to main:"
echo "    Command: git checkout main"
git checkout main
echo ""

echo "21. View history on main (quality line is NOT here):"
echo "    Command: cat sequence.fasta"
cat sequence.fasta
echo ""

# ============================================================
# PART 5: Merging Branches
# ============================================================

echo "--- PART 5: Merging Branches ---"
echo ""

echo "22. Merge feature branch into main:"
echo "    Command: git merge feature/add-quality-scores"
git merge feature/add-quality-scores
echo ""

echo "23. View file after merge (quality line is NOW here):"
echo "    Command: cat sequence.fasta"
cat sequence.fasta
echo ""

echo "24. View merged history:"
echo "    Command: git log --oneline"
git log --oneline
echo ""

echo "25. Delete the feature branch:"
echo "    Command: git branch -d feature/add-quality-scores"
git branch -d feature/add-quality-scores
echo ""

# ============================================================
# PART 6: More Practical Examples
# ============================================================

echo "--- PART 6: Practical Bioinformatics Workflow ---"
echo ""

echo "26. Create multiple scripts:"
mkdir -p scripts
echo "#!/bin/bash" > scripts/count_sequences.sh
echo "grep -c '^>' \$1" >> scripts/count_sequences.sh
chmod +x scripts/count_sequences.sh

echo "#!/bin/bash" > scripts/calculate_gc.sh
echo "# Calculate GC content" >> scripts/calculate_gc.sh
chmod +x scripts/calculate_gc.sh

echo "    Created: scripts/count_sequences.sh"
echo "    Created: scripts/calculate_gc.sh"
echo ""

echo "27. Stage multiple files at once:"
echo "    Command: git add ."
git add .
echo ""

echo "28. Check what's staged:"
echo "    Command: git status"
git status
echo ""

echo "29. Commit with a descriptive message:"
echo "    Command: git commit -m 'Add bioinformatics utility scripts'"
git commit -m "Add bioinformatics utility scripts"
echo ""

echo "30. View commit with file details:"
echo "    Command: git log --name-status"
git log --name-status | head -n 10
echo ""

# ============================================================
# PART 7: Remote Operations (Simulated)
# ============================================================

echo "--- PART 7: Remote Operations (Conceptual) ---"
echo ""

echo "31. Add a remote (in real workflow, this would be GitHub):"
echo "    Command: git remote add origin https://github.com/user/repo.git"
echo "    (Not running actual command to avoid network errors)"
echo ""

echo "32. View remote:"
echo "    Command: git remote -v"
git remote -v
echo ""

echo "33. What you would do to push to GitHub:"
echo "    Commands:"
echo "      git push -u origin main              # First time"
echo "      git push origin main                  # Subsequent times"
echo ""

# ============================================================
# PART 8: Undoing Changes
# ============================================================

echo "--- PART 8: Undoing Changes ---"
echo ""

echo "34. Make an accidental change:"
echo "    Command: echo 'MISTAKE' >> sequence.fasta"
echo "MISTAKE" >> sequence.fasta
echo ""

echo "35. View the mistake:"
echo "    Command: git diff"
git diff
echo ""

echo "36. Discard the change (restore file):"
echo "    Command: git checkout sequence.fasta"
git checkout sequence.fasta
echo ""

echo "37. Confirm it's restored:"
echo "    Command: git diff"
git diff
echo "    (No output = no differences)"
echo ""

# ============================================================
# SUMMARY
# ============================================================

echo "--- Summary ---"
echo ""
echo "Git workflow demonstrated:"
echo "  1. Initialize repo (git init)"
echo "  2. Create and stage files (git add)"
echo "  3. Commit changes (git commit)"
echo "  4. View history (git log)"
echo "  5. Create branches (git checkout -b)"
echo "  6. Merge branches (git merge)"
echo "  7. Manage remotes (git remote, git push)"
echo "  8. Undo changes (git checkout, git reset)"
echo ""
echo "Demo repository created in: $demo_dir"
echo ""
echo "Next: Run exercises.sh to practice these workflows!"
echo ""

# Clean up (optional - comment out if you want to explore the demo repo)
# cd ..
# rm -rf "$demo_dir"
