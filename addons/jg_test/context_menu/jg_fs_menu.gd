#  jg_context_memu.gd -*- mode: gdscript -*-
@tool
class_name jg_fs_menu
extends EditorContextMenuPlugin
"""
A FileSystem context menu plugin

"""


func _popup_menu(paths: PackedStringArray):
	print("Popup: " + str(paths))
	add_context_menu_item("Export/Collect", was_clicked)
	pass


func was_clicked(args):
	for arg in args:
		print("Object Targeted: " + str(arg))
		print("dependencies: %s" % ResourceLoader.get_dependencies(arg))
		print("uid: %s" % ResourceUID.path_to_uid(arg))
