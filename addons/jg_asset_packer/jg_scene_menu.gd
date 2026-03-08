#  jg_scene_menu.gd -*- mode: gdscript -*-
@tool
class_name jg_scene_menu
extends JG_Base_Menu
"""

"""

var targets = []

func _popup_menu(paths: PackedStringArray):
	add_context_menu_item("Inspect Props", inspect_props)
	add_context_menu_item("Export", do_export)
	add_context_menu_item("Test", do_test)

func do_export(args):
	jg_utils.header("Exporting Nodes: %s" % args, 5)
	targets = args
	var popup	= load("res://addons/jg_asset_packer/jg_popup.tscn").instantiate()
	popup.addon_named.connect(export_addon)
	EditorInterface.popup_dialog_centered(popup)

func export_addon(name, prefix, debug:=0):
	jg_utils.debug			= debug
	jg_utils.indent_amt     = 0
	jg_utils.export_prefix  = prefix
	jg_utils.export_target  = name

	handled					= []
	save_flags				= ResourceSaver.FLAG_NONE
	allow_overwrite			= true
	var as_path				= prefix.path_join(name)

	# Create a temp scene
	var target				= jg_utils.as_target("%s.tscn" % targets[0].name)
	var scene				= jg_utils.pack_scene(targets[0])
	scene.resource_path		= target

	jg_utils.msg("Target Addon Name: %s" % as_path, 3)
	jg_utils.msg("Targets: %s" % targets, 3)

	if not jg_utils.ensure_export_dir(): return
	save_resource(scene, scene.resource_path)
	assert(FileAccess.file_exists(target), "Scene doesnt exist: %s" % scene.resource_path)

	report_deps([ target ])
	copy_resource(target)
	report_handled()
	report_change([target])
	EditorInterface.get_resource_filesystem().scan()

func do_test(args):
	print("Target: %s" % args)
	var propname = "theList"
	# obj_copy_props(args[0])

	match [1, 2]:
		[var first, var second]:
			print("first: %s" % first)
			print("second: %s" % second)
		_:
			pass