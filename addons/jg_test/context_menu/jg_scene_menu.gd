#  jg_context_memu.gd -*- mode: gdscript -*-
@tool
class_name jg_scene_menu
extends EditorContextMenuPlugin
"""
A SceneTree context menu plugin

"""

# List Children
# list resources
# select save point
# build save dir
# copy into save dir
# make resources local, then save into save dir.

func _popup_menu(paths: PackedStringArray):
	print("Making Export dir for: " + str(paths))
	add_context_menu_item("Export/Collect", do_export)
	add_context_menu_item("reset_owners", reset_owners)

func reset_owners(args):
	print("-- resetting owners")
	for arg in args:
		print("Owner: %s" % arg.owner)
		if "texture" in arg:
			print("Resource: %s" % arg.texture)
		own_children(arg.get_parent())

func do_export(args):
	print("--------- Exporting: %s" % args[0])
	var dir = DirAccess.open("res://")
	dir.make_dir("jg_test_export")
	reset_owners(args)
	var arg = args[0]
	var scene = to_scene(arg)
	describe_scene(scene)
	var obj = scene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	print("-- Instanced: %s" % obj)
	handle_obj(obj)
	var scene2 = to_scene(obj)
	save_scene(scene2, "%s.tscn" % arg.name)
	# scene.print_tree()
	reset_owners(args)
	# TODO zip the export into a .gdpkg, with an import plugin
	# TODO add external scenes to test export
	print("-------- finished")

func to_scene(node):
	print("-- Packing: %s" % node)
	var scene = PackedScene.new()
	own_children(node)
	match scene.pack(node):
		OK:
			return scene
		var err:
			push_error("failed to pack scene")

func save_scene(scene, path):
	if scene == null:
		return
	print("-- Saving to: %s" % path)
	match ResourceSaver.save(scene, "res://jg_test_export/%s" % path):
		OK:
			pass
		var err:
			push_error("failed to write")
	print("Saved to: %s" % path)

func own_children(node):
	for child in node.find_children("*"):
		child.owner = node

func handle_obj(obj):
	print("- handling: %s" % obj)
	# should these build a list of ([resource, [users]]) to not duplicate resources?
	for val in obj.get_property_list():
		handle_resource(obj, val)
	for child in obj.find_children("*"):
		handle_obj(child)

func handle_resource(arg, val):
	if val.class_name == &"":
		return
	if arg[val.name] == null:
		return
	if not arg[val.name].is_class("Resource"):
		return

	var res = arg[val.name]
	match res.get_path():
		"": return
		null: return
		_: pass

	# TODO: if path is in addons, don't copy? or copy but notate
	# TODO: write to subdirs. {name}/resources/, {name}/scripts/*.gs and {name}/*.tscn

	var rep = res.duplicate()
	arg[val.name] = rep

	print("---- Resource: %s" % val.name)
	var id = ResourceSaver.get_resource_id_for_path(res.get_path())
	print("id: %s" % id)
	var target = "res://jg_test_export/%s" % res.get_path().get_file()
	print("node: %s" % arg)
	print("Source: %s" % res.get_path())
	print("Target: %s" % target)
	# TODO: if target exists, don't copy, just take over path.
	var source = FileAccess.get_file_as_bytes(res.get_path())
	match FileAccess.open(target, FileAccess.WRITE):
		null: pass
		var x when source != null and x != null:
			x.store_buffer(source)
			rep.take_over_path(target)

	print("%s" % res)
	print("replacement: %s" % rep)

func describe_scene(scene):
	print("Describing: %s" % scene)
	var state = scene.get_state()
