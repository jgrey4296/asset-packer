## repo-layout.md -*- mode: gfm-mode -*-

# Repo Layout of jg_asset_packer

The main code lives in `addons/jg_asset_packer`.
As a godot editor plugin, in has a `plugin.cfg` to activate it.

The main logic lives in the `context_menus` classes,
with `ui` providing the popup ui to customize the export.

An example is provided in `basic_example`, which when exported will flatten
the resources in the `code`, `fonts` and `images` directories.

The `VERSION.toml` file is used with [version manager](https://crates.io/crates/version-manager).

`.tasks` provide scripts for various chores.
`screenshots` provide screenshots of the editor plugin in use.