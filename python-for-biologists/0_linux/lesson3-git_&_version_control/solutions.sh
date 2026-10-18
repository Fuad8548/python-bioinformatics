cat > /home/claude/phase-0-lesson-3-solutions.sh << 'SOLUTIONSEOF'
#!/bin/bash

# Phase 0, Lesson 3: Git & Version Control - SOLUTIONS
# Reference workflows for all exercises

echo "===== Phase 0, Lesson 3: Git & Version Control - Solutions ====="
echo ""
echo "This file shows reference solutions for all 8 exercises."
echo "These are example workflows - your approach might differ."
echo ""

# Create a demo directory to avoid interfering with user's work
solutions_dir="git_solutions_demo"
rm -rf "$solutions_dir"
mkdir -p "$solutions_dir"
cd "$solutions_dir"

# ===== SOLUTION 1 =====
echo "========================================"
echo "SOLUTION 1: Initialize Your First Repo"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Create and navigate to new directory"
echo "   $ mkdir bioinformatics_project"
echo "   $ cd bioinformatics_project"
mkdir -p bioinformatics_project
cd bioinformatics_project

echo ""
echo "2. Initialize Git repository"
echo "   $ git init"
git init

echo ""
echo "3. Check status (should show 'No commits yet')"
echo "   $ git status"
git status

echo ""
echo "4. Create README file"
echo "   $ echo 'My Bioinformatics Project' > README.md"
echo "My Bioinformatics Project" > README.md

echo ""
echo "5. Stage the file"
echo "   $ git add README.md"
git add README.md

echo ""
echo "6. Commit with descriptive message"
echo "   $ git commit -m 'Initial commit: Add README'"
git commit -m "Initial commit: Add README"

echo ""
echo "7. View commit history"
echo "   $ git log --oneline"
git log --oneline

echo ""
echo "---"
echo ""

# ===== SOLUTION 2 =====
echo "========================================"
echo "SOLUTION 2: Track Multiple Files"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Create 3 bioinformatics scripts"
echo "   $ echo '#!/bin/bash' > count_fasta.sh"
echo "   $ echo '#!/bin/bash' > calc_gc.sh"
echo "   $ echo '#!/bin/bash' > filter_fastq.sh"
echo "#!/bin/bash" > count_fasta.sh
echo "#!/bin/bash" > calc_gc.sh
echo "#!/bin/bash" > filter_fastq.sh

echo ""
echo "2. Add placeholder content"
echo "   (Add meaningful comments to each script)"
echo "echo 'Counting sequences...' >> count_fasta.sh"
echo "echo 'Calculating GC content...' >> calc_gc.sh"
echo "echo 'Filtering by quality...' >> filter_fastq.sh"
echo "Counting sequences..." >> count_fasta.sh
echo "Calculating GC content..." >> calc_gc.sh
echo "Filtering by quality..." >> filter_fastq.sh

echo ""
echo "3. Stage all files at once"
echo "   $ git add ."
git add .

echo ""
echo "4. Commit all scripts together"
echo "   $ git commit -m 'Add bioinformatics utility scripts'"
git commit -m "Add bioinformatics utility scripts"

echo ""
echo "5. View history"
echo "   $ git log --oneline"
git log --oneline

echo ""
echo "Key Points:"
echo "  • 'git add .' stages all changes in current directory"
echo "  • Better to group related changes in one commit"
echo "  • Commits should be logical units of work"
echo ""
echo "---"
echo ""

# ===== SOLUTION 3 =====
echo "========================================"
echo "SOLUTION 3: Make and Track Changes"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Edit a script to improve it"
echo "   $ echo '# Count sequences in FASTA file' >> count_fasta.sh"
echo "# Count sequences in FASTA file" >> count_fasta.sh

echo ""
echo "2. View differences before staging"
echo "   $ git diff count_fasta.sh"
git diff count_fasta.sh

echo ""
echo "3. Stage the modified file"
echo "   $ git add count_fasta.sh"
git add count_fasta.sh

echo ""
echo "4. Commit the change"
echo "   $ git commit -m 'Improve count_fasta.sh documentation'"
git commit -m "Improve count_fasta.sh documentation"

echo ""
echo "5. View history (now shows 3 commits)"
echo "   $ git log --oneline"
git log --oneline

echo ""
echo "Key Points:"
echo "  • Use 'git diff' to review changes before committing"
echo "  • Small, focused commits are better than big ones"
echo "  • Each commit should be a single logical change"
echo ""
echo "---"
echo ""

# ===== SOLUTION 4 =====
echo "========================================"
echo "SOLUTION 4: Create a Feature Branch"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Create a new branch"
echo "   $ git checkout -b feature/error-handling"
git checkout -b feature/error-handling

echo ""
echo "2. Verify you're on the new branch"
echo "   $ git branch"
git branch

echo ""
echo "3. Make changes on this branch"
echo "   $ echo 'if [ ! -f \$1 ]; then exit 1; fi' >> calc_gc.sh"
echo "if [ ! -f \$1 ]; then exit 1; fi" >> calc_gc.sh

echo ""
echo "4. Commit the changes"
echo "   $ git add calc_gc.sh"
echo "   $ git commit -m 'Add error handling to calc_gc.sh'"
git add calc_gc.sh
git commit -m "Add error handling to calc_gc.sh"

echo ""
echo "5. Switch back to main"
echo "   $ git checkout main"
git checkout main

echo ""
echo "6. Check file on main (no error handling here)"
echo "   $ tail calc_gc.sh"
echo "   (The error handling line is NOT here)"
tail calc_gc.sh | head -n 3

echo ""
echo "7. Switch to feature branch"
echo "   $ git checkout feature/error-handling"
git checkout feature/error-handling

echo ""
echo "8. Verify changes are here on feature branch"
echo "   $ tail calc_gc.sh"
echo "   (The error handling line IS here)"
tail calc_gc.sh | head -n 3

echo ""
echo "Key Points:"
echo "  • 'git checkout -b name' creates AND switches to branch"
echo "  • Each branch is independent"
echo "  • Main remains unaffected by branch work"
echo "  • Switch branches with 'git checkout name'"
echo ""
echo "---"
echo ""

# ===== SOLUTION 5 =====
echo "========================================"
echo "SOLUTION 5: Merge Branches"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Switch to main branch"
echo "   $ git checkout main"
git checkout main

echo ""
echo "2. Merge the feature branch"
echo "   $ git merge feature/error-handling"
git merge feature/error-handling

echo ""
echo "3. Verify calc_gc.sh now has error handling"
echo "   $ tail calc_gc.sh"
tail calc_gc.sh | head -n 3

echo ""
echo "4. View history (shows feature work merged)"
echo "   $ git log --oneline"
git log --oneline

echo ""
echo "5. Delete the feature branch (no longer needed)"
echo "   $ git branch -d feature/error-handling"
git branch -d feature/error-handling

echo ""
echo "6. Confirm it's deleted"
echo "   $ git branch"
git branch

echo ""
echo "Key Points:"
echo "  • Always merge FROM the feature branch TO main"
echo "  • (git checkout main; git merge feature/name)"
echo "  • Delete branches after merging to keep things clean"
echo ""
echo "---"
echo ""

# ===== SOLUTION 6 =====
echo "========================================"
echo "SOLUTION 6: Multiple Features in Parallel"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Create feature/add-logging branch"
echo "   $ git checkout -b feature/add-logging"
git checkout -b feature/add-logging

echo ""
echo "2. Add logging to filter_fastq.sh"
echo "   $ echo '# TODO: Add logging' >> filter_fastq.sh"
echo "# TODO: Add logging" >> filter_fastq.sh
git add filter_fastq.sh
git commit -m "Add logging to filter_fastq.sh"

echo ""
echo "3. Switch back to main"
echo "   $ git checkout main"
git checkout main

echo ""
echo "4. Create feature/optimize branch"
echo "   $ git checkout -b feature/optimize"
git checkout -b feature/optimize

echo ""
echo "5. Add optimization to filter_fastq.sh"
echo "   $ echo '# TODO: Optimize performance' >> filter_fastq.sh"
echo "# TODO: Optimize performance" >> filter_fastq.sh
git add filter_fastq.sh
git commit -m "Optimize filter_fastq.sh performance"

echo ""
echo "6. Switch back to main"
echo "   $ git checkout main"
git checkout main

echo ""
echo "7. Merge feature/add-logging"
echo "   $ git merge feature/add-logging"
git merge feature/add-logging

echo ""
echo "8. Merge feature/optimize"
echo "   $ git merge feature/optimize"
git merge feature/optimize
echo "   (Might show merge conflict - see below)"

echo ""
echo "9. View final history"
echo "   $ git log --oneline"
git log --oneline

echo ""
echo "Key Points:"
echo "  • You can work on multiple features simultaneously"
echo "  • Each in its own branch"
echo "  • Merge them to main when ready"
echo "  • If they edit the same lines, you get a conflict (merge manually)"
echo ""
echo "---"
echo ""

# ===== SOLUTION 7 =====
echo "========================================"
echo "SOLUTION 7: GitHub Preparation"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Create GitHub account (skip if you have one)"
echo "   Visit: https://github.com and sign up"
echo ""

echo "2. Create new GitHub repository"
echo "   • Go to GitHub"
echo "   • Click '+' → New repository"
echo "   • Name: bioinformatics_project"
echo "   • Add description"
echo "   • Choose Public"
echo "   • Create repository"
echo ""

echo "3. Copy the GitHub HTTPS URL (something like):"
echo "   https://github.com/YOUR_USERNAME/bioinformatics_project.git"
echo ""

echo "4. Add remote to your local repo"
echo "   $ git remote add origin https://github.com/YOUR_USERNAME/bioinformatics_project.git"
git remote add origin https://github.com/demo_user/bioinformatics_project.git

echo ""
echo "5. View remotes"
echo "   $ git remote -v"
git remote -v

echo ""
echo "6. Push to GitHub (first time)"
echo "   $ git push -u origin main"
echo "   (Requires GitHub authentication - will prompt for password/token)"
echo ""

echo "7. Later pushes are simpler"
echo "   $ git push origin main"
echo ""

echo "Key Points:"
echo "  • GitHub is a 'backup' of your code"
echo "  • '-u origin main' sets up tracking for future pushes"
echo "  • Use HTTPS URL (easier) or SSH (more secure)"
echo ""
echo "---"
echo ""

# ===== SOLUTION 8 =====
echo "========================================"
echo "SOLUTION 8: Undo Changes"
echo "========================================"
echo ""
echo "Workflow:"
echo ""

echo "1. Make a bad change"
echo "   $ echo 'THIS IS A MISTAKE' >> README.md"
echo "THIS IS A MISTAKE" >> README.md

echo ""
echo "2. View the mistake"
echo "   $ git diff README.md"
git diff README.md

echo ""
echo "3. Undo the unstaged change"
echo "   $ git checkout README.md"
git checkout README.md

echo ""
echo "4. Verify it's undone"
echo "   $ cat README.md"
cat README.md

echo ""
echo "5. Check status (should be clean)"
echo "   $ git status"
git status

echo ""
echo "Key Points:"
echo "  • 'git checkout FILE' reverts FILE to last commit"
echo "  • Only works for unstaged changes"
echo "  • For staged changes: git reset HEAD FILE"
echo "  • For committed changes: git revert COMMIT or git reset --hard"
echo ""
echo "---"
echo ""

echo "========================================"
echo "SUMMARY: Git Workflow"
echo "========================================"
echo ""
echo "Daily workflow:"
echo "  1. git pull origin main         (get latest changes)"
echo "  2. git checkout -b feature/X    (create feature branch)"
echo "  3. Make changes, edit files"
echo "  4. git add .                    (stage changes)"
echo "  5. git commit -m 'message'      (save snapshot)"
echo "  6. (repeat 3-5 as needed)"
echo "  7. git push origin feature/X    (push branch to GitHub)"
echo "  8. git checkout main            (switch to main)"
echo "  9. git merge feature/X          (bring in feature)"
echo "  10. git push origin main        (push to GitHub)"
echo ""
echo "Key commands:"
echo "  git init                  - Initialize repo"
echo "  git add FILE              - Stage file"
echo "  git commit -m 'msg'       - Save snapshot"
echo "  git log --oneline         - View history"
echo "  git checkout -b BRANCH    - Create & switch branch"
echo "  git merge BRANCH          - Merge branch to current"
echo "  git push origin BRANCH    - Push to GitHub"
echo "  git pull origin BRANCH    - Pull from GitHub"
echo ""

# Clean up
cd ..
echo "Demo completed! Test repo created in: $solutions_dir"
echo ""
echo "Next: Phase 0 Mini-Project 1: FASTA Sequence Analyzer"
echo ""
