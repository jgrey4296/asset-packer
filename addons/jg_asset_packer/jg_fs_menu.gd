#  jg_context_memu.gd -*- mode: gdscript -*-
@tool
class_name jg_fs_menu
extends JG_Base_Menu
"""
A FileSystem context menu plugin

"""


func _popup_menu(paths: PackedStringArray):
	add_context_menu_item("Export", do_export)
	add_context_menu_item("Collect", do_collect)
	add_context_menu_item("Describe Dependencies", do_describe)

func do_export(args):
	msg("---- Exporting : %s" % args, 4)
	indent		= []
	handled		= []
	save_flags  = ResourceSaver.FLAG_NONE
	report_deps(args)
	ensure_export_dir()
	for x in args:
		copy_resource(x)

	report_handled()
	report_change(args)

func do_collect(args):
	msg("---- Collecting : %s" % args, 4)
	indent		= []
	handled		= []
	save_flags = ResourceSaver.FLAG_BUNDLE_RESOURCES
	ensure_export_dir()
	for x in args:
		copy_resource(x)

func do_describe(args):
	report_deps(args)
