#  jg_context_memu.gd -*- mode: gdscript -*-
@tool
class_name jg_fs_menu
extends JG_Base_Menu
"""
A FileSystem context menu plugin

"""

var targets = []

func _popup_menu(paths: PackedStringArray):
	add_context_menu_item("Export as Addon", do_export)
	add_context_menu_item("Bundle Addon", do_bundle)
	add_context_menu_item("Describe Dependencies", do_describe)

func do_export(args):
	jg_utils.header("Exporting: %s" % args, 4)
	targets		= args
	var popup	= load("res://addons/jg_asset_packer/jg_popup.tscn").instantiate()
	popup.addon_named.connect(export_addon)
	EditorInterface.popup_dialog_centered(popup)

func do_bundle(args):
	jg_utils.header("Bundling : %s" % args, 4)
	targets		= args
	var popup	= load("res://addons/jg_asset_packer/jg_popup.tscn").instantiate()
	popup.addon_named.connect(bundle_addon)
	EditorInterface.popup_dialog_centered(popup)

func do_describe(args):
	report_deps(args)

func export_addon(name, prefix:="res://addons/", debug:=0):
	jg_utils.debug			= debug
	jg_utils.export_prefix  = prefix
	jg_utils.export_target  = name
	handled					= []
	save_flags				= ResourceSaver.FLAG_NONE
	var as_path				= prefix.path_join(name)

	jg_utils.msg("Target Addon Name: %s" % as_path, 3)
	jg_utils.msg("Targets: %s" % targets, 3)

	report_deps(targets)
	jg_utils.ensure_export_dir()
	for x in targets:
		copy_resource(x)

	report_handled()
	report_change(targets)
	EditorInterface.get_resource_filesystem().scan()

func bundle_addon(name, prefix:="res://addons/", debug:=0):
	jg_utils.debug			= debug
	jg_utils.export_prefix  = prefix
	jg_utils.export_target  = name
	handled					= []
	save_flags				= ResourceSaver.FLAG_BUNDLE_RESOURCES
	var as_res				= prefix.path_join(name)

	jg_utils.msg("Target Addon Name: %s" % as_res, 3)
	jg_utils.msg("Targets: %s" % targets, 3)
	jg_utils.ensure_export_dir()
	for x in targets:
		copy_resource(x)

	EditorInterface.get_resource_filesystem().scan()
