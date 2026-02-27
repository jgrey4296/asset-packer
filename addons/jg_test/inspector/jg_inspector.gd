#  jg_inspector.gd -*- mode: gdscript -*-
@tool
class_name jg_inspector
extends EditorPlugin
"""
https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html
"""

var plugin = preload("res://addons/jg_test/inspector/jg_inspector_plugin.gd").new()

func _enter_tree():
	print("adding inspector plugin")
	add_inspector_plugin(plugin)
	pass

func _exit_tree():
	remove_inspector_plugin(plugin)
	pass
