## repo-layout.md -*- mode: gfm-mode -*-

# Repo Layout

## {Root}. 
The root of the workspace.
Where config files go. 

# {Root}/.temp
Where temporary and generated files live.
.temp can be deleted and rebuilt from source and dependencies.

## {Root}/.tasks
Where polyglot tasks are installed, along with with pre-commit hooks, custom gradle tasks, etc.

## {Root}/src
All source code lives here.
Primary languages (dotnet, elixir, python, rust, kotlin, godot) are directly here. 

## {Root}/{project name}
The primary python module that typically stitches everything together.

## {Root}/src/_{book, changes, docfx, epub, sphinx, tex}
Documentation sources.

## {Root}/src/_ai_and_logic
For utility languges like clingo, ceptre, instal, prolog, rego, soar and z3.

## {Root}/src/_music
Utility langages for making sound. eg: csound, supercollider, faust.

## {Root}/src/_utilities
Utility code like octave calculations, symbolic math manipulations,
statemachine and uml diagram generators.

## {Root}/src/__tests
Integration tests between workspace modules.

## {Root}/src/__notes
Reference notes for the use languages/tools used in the workspace.
