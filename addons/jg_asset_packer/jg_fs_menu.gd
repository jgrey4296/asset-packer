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
	msg("---- Egporting : %s" % args, 4)
	targets		= args
	var popup	= load("res://addons/jg_asset_packer/jg_popup.tscn").instantiate()
	popup.addon_named.connect(export_addon)
	EditorInterface.popup_dialog_centered(popup)

func do_bundle(args):
	msg("---- Bundling : %s" % args, 4)
	targets		= args
	var popup	= load("res://addons/jg_asset_packer/jg_popup.tscn").instantiate()
	popup.addon_named.connect(bundle_addon)
	EditorInterface.popup_dialog_centered(popup)


func do_describe(args):
	report_deps(args)

func export_addon(text):
	var as_res = "addons/%s" % text
	print("Target Addon Name: res://%s" % as_res)
	print("Targets: %s" % targets)
	export_target	= text
	indent			= []
	handled			= []
	save_flags		= ResourceSaver.FLAG_NONE
	report_deps(targets)
	ensure_export_dir()
	for x in targets:
		copy_resource(x)

	report_handled()
	report_change(targets)

func bundle_addon(text):
	var as_res = "addons/%s" % text
	print("Target Addon Name: res://%s" % as_res)
	print("Targets: %s" % targets)
	export_target	= text
	indent			= []
	handled			= []
	save_flags		= ResourceSaver.FLAG_BUNDLE_RESOURCES
	ensure_export_dir()
	for x in targets:
		copy_resource(x)
