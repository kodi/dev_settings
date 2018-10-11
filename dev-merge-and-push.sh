#!/usr/bin/env bash

# Assuming you have a master and dev branch, and that you make new
# release branches named as the version they correspond to, e.g. 1.0.3
# Usage: ./release.sh 1.0.3

TARGET='develop'

red='\e[21;31m%s\e[0m\n'
green='\e[21;32m%s\e[0m\n'
yellow='\e[21;33m%s\e[0m\n'
blue='\e[21;34m%s\e[0m\n'
magenta='\e[21;35m%s\e[0m\n'
cyan='\e[21;36m%s\e[0m\n'

# Get version argument and verify
version=$1
if [ -z "$version" ]; then
  echo "Please specify a version"
  exit
fi

# Output
printf "$green"  "------------------------------------"
printf "$yellow" "------------------------------------"
printf "$yellow" "🏁 Start - Merging branch to dev: $version"
printf "$green"  "------------------------------------"

# Get current branch and checkout if needed
branch=$(git symbolic-ref --short -q HEAD)
if [ "$branch" != "$version" ]; then
  git checkout $version
fi

# Ensure working directory in version branch clean
git update-index -q --refresh
if ! git diff-index --quiet HEAD --; then
  echo "😓 Working directory not clean, please commit your changes first"
  exit
fi


# Checkout develop branch and merge version branch into develop
printf "$blue" "Checkout $TARGET "
printf "$green" "------------------------------------"

git checkout $TARGET

printf "$blue" "Merge $version -> $TARGET 🤞"
printf "$green" "------------------------------------"
git merge $version --no-ff --no-edit

# Run version script, creating a version tag, and push commit and tags to remote
# npm version $version
printf "$blue" "🚨 Push to $TARGET 🚚 "
printf "$green" "------------------------------------"
git push
git push --tags

# Checkout dev branch and merge master into dev (to ensure we have the version)
#git checkout dev
#git merge master --no-ff --no-edit
#git push

# Delete version branch locally and on remote
#git branch -D $version
#git push origin --delete $version

# Success
printf "$green" "------------------------------------"
printf "$yellow" "Branch: $version to develop - complete ✅"

# Success & return
printf "$green" "------------------------------------"
printf "$yellow" "Return to branch: $version - The End!"
git checkout $version
printf "$red" "------------------------------------"
echo          "       Thank you, come again 💖     "
printf "$red" "------------------------------------"
