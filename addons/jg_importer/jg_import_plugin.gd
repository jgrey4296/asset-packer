#  jg_import_plugin.gd -*- mode: gdscript -*-
@tool
class_name jg_import_plugin
extends EditorImportPlugin
"""

"""

func _get_importer_name():
    return "gdpkg"

func _get_visible_name():
    return "gdpkg"

func _get_recognized_extensions():
    return ["gdpkg"]

func _get_save_extension():
    return "gdpk"

func _get_resource_type():
    return "PackedScene"
