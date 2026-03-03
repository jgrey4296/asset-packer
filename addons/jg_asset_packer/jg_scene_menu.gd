#  jg_scene_menu.gd -*- mode: gdscript -*-
class_name jg_scene_menu
extends JG_Base_Menu
"""

"""

func _popup_menu(paths: PackedStringArray):
	add_context_menu_item("Inspect Props", inspect_props)
	add_context_menu_item("Export", do_export)

func do_export(args):
	print("---- Exporting Nodes: %s" % args)
	ensure_export_dir()
	var target				= as_target("pre_%s.tscn" % args[0].name)
	var scene				= pack_scene(args[0])
	scene.resource_path		= target
	save_resource(scene, scene.resource_path)
	assert(FileAccess.file_exists(target), "Scene doesnt exist: %s" % scene.resource_path)
	report_deps([ target ])
	copy_resource(target)
	report_handled()
	report_change([target])