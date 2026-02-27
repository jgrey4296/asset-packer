#  jg_inspector_plugin.gd -*- mode: gdscript -*-
@tool
class_name jg_inspector_plugin
extends EditorInspectorPlugin
"""

"""

var prop = preload("res://addons/jg_test/inspector/jg_editor_prop.gd")
var prop_scene = preload("res://addons/jg_test/inspector/jg_inspector.tscn")
# add_custom_control
# add_property_editor
# add_property_editor_for_multiple_properties

func _can_handle(object):
	print("Can Handle: %s" % object)
	return true

func _parse_begin(object):
	if "name" in object:
		print("Begin object: %s" % object.name)
	print("prop: %s" % prop)
	# add_custom_control(prop_scene.instantiate())
	add_property_editor("name", prop.new())
	pass

func _parse_category(object, category):
	# print("Category: %s" % category)
	pass

func _parse_group(object, group):
	# print("Group: %s" % group)
	pass

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# print("Parsing property: %s" % name)
	return false

func _parse_end(object):
	pass
