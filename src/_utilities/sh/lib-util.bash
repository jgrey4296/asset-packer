#!/usr/bin/env bash
# Utilities for polyglot
NOTHING=50
PRINTED_HELP=2

function debug () {
    if [ "${VERBOSE:-0}" -eq 1 ]; then
        echo "$@"
    fi
}

function fail () {
    echo -e "Failed: ${*}"
    exit 1
}

function header () {
    echo -e "|-------------------------\n| * ${*}\n|-------------------------"
}

function subhead () {
    echo -e "---------- ${*}"
}

function tdot () {
    echo -e "... ${*}"
}

function sep () {
    echo "-------------------------"
}

function is-help-flag () {
    # returns 1 if --help or -h is passed in
    case "$1" in
        -h|--help) return 1 ;;
        *) return 0 ;;
    esac
}

