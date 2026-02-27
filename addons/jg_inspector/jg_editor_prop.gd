#  jg_editor_prop.gd -*- mode: gdscript -*-
@tool
class_name jg_editor_prop
extends EditorProperty
"""
https://docs.godotengine.org/en/stable/tutorials/plugins/editor/inspector_plugins.html#adding-an-interface-to-edit-properties

_init : sets up nodes structure
_update_property : handle changes from the outside
emit_changed to inform the inspector the prop has changed

"""

var prop_control	= preload("res://addons/jg_test/inspector/jg_inspector.tscn")
var current_value	= 0
var updating		= false
var control

func _init():
	print("initialising jg editor prop")
	label = "blah"
	control = prop_control.instantiate()
	draw_label = true
	draw_background = true
	anchor_bottom = 1.0
	anchor_right = 1.0
	grow_horizontal = 1
	grow_vertical = 1
	use_folding = true
	add_child(control)
	# add_focusable(control)
	# refresh_control_text()
	# control.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	print("button pressed")
	# if (updating):
	# 	return

	# refresh_control_text()
	# emit_changed(get_edited_property(), current_value)

func _update_property():
	print("property updated")
	# var new_value = get_edited_object()[get_edited_property()]
	# if (new_value == current_value):
	# 	return

	# updating = true
	# current_value = new_value
	# refresh_control_text()
	# updating = false

func refresh_control_text():
	# $control/HBoxContainer/Label.text = "value"
	pass
