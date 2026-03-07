#  jg_context.gd -*- mode: gdscript -*-
@tool
class_name jg_context
extends EditorPlugin
"""

"""
var fs_slot		= EditorContextMenuPlugin.CONTEXT_SLOT_FILESYSTEM
var fs_menu		= preload("jg_fs_menu.gd").new()
var st_slot = EditorContextMenuPlugin.CONTEXT_SLOT_SCENE_TREE
var scene_menu = preload("jg_scene_menu.gd").new()

func _enter_tree():
	print("Activating jg_asset_packer")
	add_context_menu_plugin(fs_slot, fs_menu)
	add_context_menu_plugin(st_slot, scene_menu)

func _exit_tree():
	print("DeActivating jg_asset_packer")
	remove_context_menu_plugin(fs_menu)
	remove_context_menu_plugin(scene_menu)