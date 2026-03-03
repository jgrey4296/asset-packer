#  basic.gd -*- mode: gdscript -*-
class_name basic
extends SceneTree
"""
godot --no-header --headless --editor -s ./basic.gd
"""

var targets = ["res://example/example.tscn"]
var fs_menu

func _initialize():
	print("---- started")
	self.fs_menu = jg_fs_menu.new()
	self.fs_menu.allow_overwrite = false

func _process(delta):
	self.fs_menu.do_export(self.targets)
	return true

func _finalize():
	print("--- finished\n\n\n")