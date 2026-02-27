#  left_dock.gd -*- mode: gdscript -*-
@tool
class_name left_dock
extends EditorPlugin
"""

"""

var dock_scene = preload("res://addons/jg_test/left_dock/left_dock.tscn")
var l_dock

func _enter_tree():
	# On entrance to scene, can be called multiple times
	print("adding left dock")
	l_dock = EditorDock.new()
	l_dock.add_child(dock_scene.instantiate())
	l_dock.title = "JG left Dock"
	l_dock.default_slot =  EditorDock.DOCK_SLOT_LEFT_UL
	l_dock.available_layouts = EditorDock.DOCK_LAYOUT_VERTICAL | EditorDock.DOCK_LAYOUT_FLOATING
	add_dock(l_dock)
	pass

func _exit_tree():
	# Upon leaving the scene
	print("removing bottomm dock")
	remove_dock(l_dock)
	l_dock.queue_free()
	pass
