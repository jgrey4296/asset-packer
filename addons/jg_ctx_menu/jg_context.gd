#  jg_context.gd -*- mode: gdscript -*-
@tool
class_name jg_context
extends EditorPlugin
"""

context_slot_scene_tree
context_slot_filesystem
context_slot_script_editor
context_slot_filesystem_create
context_slot_script_editor_code
context_slot_scene_tabs
context_slot_2d_editor

"""
var st_slot = EditorContextMenuPlugin.CONTEXT_SLOT_SCENE_TREE
var scene_menu = preload("jg_scene_menu.gd").new()

func _enter_tree():
	print("adding context menu")
	add_context_menu_plugin(st_slot, scene_menu)
	pass

func _exit_tree():
	remove_context_menu_plugin(scene_menu)
	pass
