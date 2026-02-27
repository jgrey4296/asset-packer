#  jg_import.gd -*- mode: gdscript -*-
@tool
class_name jg_import
extends EditorPlugin
"""
https://docs.godotengine.org/en/stable/tutorials/plugins/editor/import_plugins.html
"""

var import_plugin = jg_import_plugin.new()

func _enter_tree():
    print("Adding import plugin")
    add_import_plugin(import_plugin)
    pass

func _exit_tree():
    remove_import_plugin(import_plugin)
    pass
