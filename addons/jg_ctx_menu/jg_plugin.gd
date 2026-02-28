#  jg_plugin.gd -*- mode: gdscript -*-
@tool
extends EditorPlugin
"""

EditorEinterface

add_autoload_singleton
add_context_menu_plugin
add_dock
add_export_platform
add_export_plugin
add_import_plugin
add_inspector_plugin
add_node_3d_gizmo_plugin
add_resource_conversion_lugin
add_scene_format_importer_plugin
add_scene_post_import_plugin
add_tool_menu_item
add_tool_submenu_item

"""

const PLUGIN_NAME = "jg_test"

const COMPONENTS = [
	"/command_palette",
	"/context_menu",
	# "/down_dock",
	# "/importer",
	# "/inspector",
	# "/left_dock",
	# "/main_screen",
	# "/node",
	# "/tool_menu",
	# "/singleton",
	]

func _enable_plugin():
	if not Engine.is_editor_hint():
		return

	print("Starting jg plugin")
	for name in COMPONENTS:
		print("- %s" % name)
		EditorInterface.set_plugin_enabled(PLUGIN_NAME + name, true)

func _disable_plugin():
	print("Removing jg plugin")
	for name in COMPONENTS:
		print("- %s" % name)
		EditorInterface.set_plugin_enabled(PLUGIN_NAME + name, false)
