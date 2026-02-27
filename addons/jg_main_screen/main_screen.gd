#  main_screen.gd -*- mode: gdscript -*-
@tool
class_name main_screen
extends EditorPlugin
"""

"""

func _enter_tree():
	print("jg main screen enter")
	# On entrance to scene, can be called multiple times
	pass

func _exit_tree():
	# Upon leaving the scene
	pass

func _has_main_screen():
	return true

func _make_visible(visible):
	pass

func _get_plugin_name():
	return "jg main screen"

func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
