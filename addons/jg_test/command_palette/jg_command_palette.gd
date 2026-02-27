#  jg_command_palette.gd -*- mode: gdscript -*-
@tool
class_name jg_command_palette
extends EditorPlugin
"""

"""
var scene = preload("res://addons/jg_test/command_palette/popup.tscn")

func _enter_tree():
	# On entrance to scene, can be called multiple times
	print("Adding command to palette")
	var command_palette = EditorInterface.get_command_palette()
	command_palette.add_command("jg command", "jg", my_command)

func _exit_tree():
	# Upon leaving the scene
	print("removing command to palette")
	var command_palette = EditorInterface.get_command_palette()
	command_palette.remove_command("jg")

func my_command():
	print("jg command")
	var panel = PopupPanel.new()
	var scene = load("res://addons/jg_test/command_palette/popup.tscn")
	panel.add_child(scene.instantiate())
	EditorInterface.popup_dialog_centered(panel)
