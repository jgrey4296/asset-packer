#!/usr/bin/env bash
# 3.install.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

# shellcheck disable=SC1091
source "$POLY_SRC/lib/lib-util.bash"
# shellcheck disable=SC1091
[[ -e "$POLYGLOT_ROOT/.tasks/task-util.bash" ]] && source "$POLYGLOT_ROOT/.tasks/task-util.bash"

function init-workspace () {
  local IFS=";"
  local type="$1"
  local vals="$2"
  local POLY_CTX
  POLY_CTX=$(pushctx "${type}s")
  for key in $vals
  do
    POLYGLOT_SUPRESS_HEADER=1 polyglot add "$type" "$key"
  done
}

POLY_CTX=$(pushctx "defaults")
pctx "Installing defaults"
init-workspace "lang" "$POLYGLOT_DEFAULT_LANGS"
echo ""
init-workspace "tool" "$POLYGLOT_DEFAULT_TOOLS"
echo ""
init-workspace "task" "$POLYGLOT_DEFAULT_TASKS"
