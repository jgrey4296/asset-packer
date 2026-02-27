#!/usr/bin/env bash
# 10.git.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

pctx "git" "initialising git lfs"
git lfs install
