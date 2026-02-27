<!--  workspace.md -*- mode: gfm-mode -*-  -->
<!--
Summary:

Tags:

-->

# The Polyglot Workspace

Certain languages include the concept of a workspace, multiple modules being strongly linked,
but in a flat structure rather than a tree.

## [Rust](https://doc.rust-lang.org/cargo/reference/workspaces.html)
Cargo's root `Cargo.toml` defines the workspace, and sub-packages can use the workspace's definitions.

Members are globbed, and patterns can be excluded.

## [Python](https://docs.astral.sh/uv/concepts/projects/workspaces/)
UV's workspaces are inspired by rust/cargo. They operate similarly.
The workspace is defined in the root `pyproject.toml`,
in the `[tool.uv.sources]` and `[tool.uv.workspace]` tables.

Again, members can be globbed and excluded. However, the sources need to be manually added.

## [Elixir](https://hexdocs.pm/mix/1.19.3/Mix.Project.html#module-umbrella-projects)
Elixir's Mix tool has the concept of 'umbrella projects', which are workspaces.

The project is configured in the root `mix.exs`.
However, sub-packages need to set certain path to point to the root:

```elixir
# ...
def project do
    [
        # ...
        build_path: "../../.temp/elixir/build",
        config_path: "../../config.exs",
        deps_path: "../../deps",
        lockfile: "../../mix.lock",
    ]
```

## Dotnet
Dotnet structures itself with a `.sln` file in the root,
which has references to the sub-packages.
The Sub-packages are configured by their own `.csproj` and `.fsproj` files.

Primarily, when a new sub-package is created, add it to the sln with `dotnet sln add`.
Or, `polyglot update` will do that.