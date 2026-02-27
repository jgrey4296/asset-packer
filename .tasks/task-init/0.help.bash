#!/usr/bin/env bash
# place in $root/.tasks/task-{name}/0.help.bash
# and chmod +x it.
set -o nounset
set -o pipefail

# shellcheck disable=SC1091
source "$POLY_SRC/lib/lib-util.bash"
# shellcheck disable=SC1091
[[ -e "$POLYGLOT_ROOT/.tasks/task-util.bash" ]] && source "$POLYGLOT_ROOT/.tasks/task-util.bash"

HELP_TEXT="
usage: polyglot task init [args ...] [-h]

Initialises the polyglot workspace.
Including:
- reading the .temp directory
- asdf plugins
- python/uv
- rust toolchain
- dotnet solution
- jvm
- elixir
- documentation generators


positional arguments:
args          :

options:
-h, --help    : show this help message and exit


"

function check-environment () {
    tdot "check" "Checking Environment"
    has_failed=0

    # [[ -z "${BIBLIO_LIB:-}" ]] || { has_failed=$(( has_failed + 1 )); echo -e "!-- No BIBLIO_LIB has been defined" }

    [[ "$has_failed" = 0 ]] || fail "Missing EnvVars"
}

print-help "$HELP_TEXT" 0 "$@"
check-environment
