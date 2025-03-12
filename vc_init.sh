#!/bin/bash

#chmod +x vc_init.sh

# Check if enough arguments are passed
if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <dvc_files>... <commit_message> <repo>"
    exit 1
fi

# Extract commit message and repo from the last arguments
commit_message="${@: -2:1}"  # Second last argument
repo="${@: -1}"              # Last argument

# Extract DVC files (all arguments except last two)
dvc_files=("${@:1:$#-2}")

# Count previous commits to generate the commit number
commit_count=$(git rev-list --count HEAD 2>/dev/null || echo 0)
commit_number=$((commit_count + 1))

# Format commit message
formatted_commit_message="commit $commit_number : $commit_message"

git init
dvc init
echo "initiated git and dvc"
dvc status
dvc add "${dvc_files[@]}"
dvc status
git status
git add .
git status
git commit -m "$formatted_commit_message"
git status
git remote add github git@github.com:NIHAAL084/$repo.git
git remote add dagshub https://dagshub.com/NIHAAL084/$repo.git
git remote set-url dagshub https://NIHAAL084:55972321c71261635f2105a2fd903a342684bebb@dagshub.com/NIHAAL084/$repo.git
dvc remote add dagshub https://dagshub.com/NIHAAL084/$repo.dvc
dvc remote default dagshub
dvc remote modify dagshub auth basic
dvc remote modify dagshub user NIHAAL084
dvc remote modify dagshub password c2a65caba88c2f6889200d1bac27ce5c21f15a12
git push github main
git push dagshub main
dvc push
echo "files committed and pushed successfully."