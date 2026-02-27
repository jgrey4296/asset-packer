<!--  versioning.md -*- mode: gfm-mode -*-  -->
<!--
Summary:

Tags:
-->

# Versioning
Using [Version Manager](https://github.com/annie444/version).
Updates *specific* files version numbers.

`VERSION.toml` configures the files to modify when
the `version` command is run.

Top Level files are included by default in the config.
Sub-packages in `src` are added as needed.

## Default Files

- towncrier.toml
- pyproject.toml
- Cargo.toml
- mix.exs

## Sub-package files

- pyproject.toml
- Cargo.toml
- mix.exs
- build.gradle.kts
- list package roots


### Lisp
Define the version using `(defconst {package}-version "{version}")`,
and modify in `VERSION.toml` as necessary.

## Dotnet
Define the version in `.csproj` and `.fsproj` files with:
```xml
<PropertyGroup>
    <Version>0.1.1</Version>
</PropertyGroup>
```

### Elixir
Sub-package `mix.exs` files have a `version: {version}` entry
similar to the workspace `mix.exs`.