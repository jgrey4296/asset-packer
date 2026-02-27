#  down_dock.gd -*- mode: gdscript -*-
@tool
class_name down_dock
extends EditorPlugin
"""

"""

var dock_scene = preload("res://addons/jg_test/down_dock/down_dock.tscn")
var d_dock

func _enter_tree():
	# On entrance to scene, can be called multiple times
	print("adding bottom dock")
	d_dock = EditorDock.new()
	d_dock.add_child(dock_scene.instantiate())
	d_dock.title = "JG down Dock"
	d_dock.default_slot =  EditorDock.DOCK_SLOT_BOTTOM
	add_dock(d_dock)
	pass

func _exit_tree():
	# Upon leaving the scene
	print("removing bottom dock")
	remove_dock(d_dock)
	d_dock.queue_free()
	pass
