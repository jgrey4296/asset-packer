#  tool_menu.gd -*- mode: gdscript -*-
@tool
class_name tool_menu
extends EditorPlugin
"""

"""

func _enter_tree():
	print("adding tool menu")
	# On entrance to scene, can be called multiple times
	self.add_tool_menu_item("jg test", self.tool_menu_called)
	pass

func _exit_tree():
	# Upon leaving the scene
	self.remove_tool_menu_item("jg_test")
	pass

func tool_menu_called():
	print("The tool menu was called blah")
