#!/bin/bash

# Remove -S flag from commit command for global config so VSCode/git never attempts to sign with GPG
git config --global commit.gpgsign false
git config --global tag.gpgsign false
git config --unset --global gpg.program
git config --unset --global commit.gpgsign
git config --unset --global tag.gpgsign

git config --local commit.gpgsign false
git config --local tag.gpgsign false
git config --unset --local gpg.program
git config --unset --local commit.gpgsign
git config --unset --local tag.gpgsign

# Advise user to use commit without -S
echo "To commit without signing, use: git commit --allow-empty-message --file -"

echo "===== FINAL GIT CONFIG (GLOBAL) ====="
git config --global --list
echo ""
echo "===== FINAL GIT CONFIG (LOCAL) ====="
git config --list
