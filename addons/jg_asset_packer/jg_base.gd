#  jg_base.gd -*- mode: gdscript-ts -*-
@tool
class_name JG_Base_Menu
extends EditorContextMenuPlugin
"""

"""

const export_relative	= false
const cache_mode		= ResourceLoader.CACHE_MODE_IGNORE_DEEP
const export_target		= "test_export"
const exclusions		= ["Node","Process","Thread Group","Physics Interpolation", "owner", "multiplayer"]
const skip_dirs			= "addons"
const INDENT_STR		= "->"
const mod_name			= "%s-coll"
var save_flags			= ResourceSaver.FLAG_NONE
var mute				= 3
var allow_overwrite		= false
var indent				= []
var handled				= []

#  utils --------------------------------------------------

func as_target(x, relative:=false):
	match x.get_extension():
		_ when relative:
			return "./%s" % x.get_file()
		"gd":
			var base = x.get_basename()
			return "res://%s/%s.gd" % [export_target, base.get_file()]
		_:
			return "res://%s/%s" % [export_target, x.get_file()]

func ensure_export_dir():
	DirAccess.open("res://").make_dir(export_target)

func pack_scene(arg:Node) -> PackedScene:
	msg("---- Packing Scene: %s" % arg)
	if arg == null:
		return null
	var scene = to_scene(arg)
	return scene

func to_scene(node:Node) -> PackedScene:
	if node == null:
		return null
	var scene = PackedScene.new()
	match scene.pack(node):
		OK: pass
		var err: push_error("failed to pack scene")

	return scene

func claim_children(node):
	var ignore = []
	msg("Claim root: %s" % node)
	for child in node.find_children("*"):
		match child.scene_file_path:
			"", null when child.owner not in ignore:
				msg("Claiming: %s : %s : %s" % [child, child.scene_file_path, child.owner])
				child.owner = node
			"", null:
				pass
			_:
				msg("ignoring: %s" % child)
				ignore.append(child)
				child.owner = node

func reset_owners(args):
	for arg in args:
		if arg.get_parent() == null:
			claim_children(arg)
		else:
			claim_children(arg.get_parent())

func msg(msg:="", level:=0):
	if level < mute:
		return
	print("%s : %s" % ["".join(self.indent), msg])

#  report --------------------------------------------------

func report_handled():
	print("\n-- Handled (%s): " % len(handled))
	for x in handled:
		print("- %s (%s)" % [x, type_string(typeof(x))])

	print()

func report_deps(args, header:=true): # str -> None
	for arg in args:
		var deps = ResourceLoader.get_dependencies(arg)
		var uid  = ResourceUID.path_to_uid(arg)
		if len(deps) == 0: continue
		if header: print("---- (%s) deps of %s [%s]:" % [len(deps), arg, uid])
		for x in deps:
			print("- %s" % x)
			if "::::" in x: report_deps([x.split("::::")[1]], false)

		if header: print("----\n")

func report_change(args):
	for arg in args:
		var target			= as_target(arg)
		var orig			= ResourceUID.path_to_uid(arg)
		var copied			= ResourceUID.path_to_uid(target)
		var orig_deps		= ResourceLoader.get_dependencies(arg)
		var copied_deps		= ResourceLoader.get_dependencies(target)
		assert(len(orig_deps) == len(copied_deps), "Deps differ")

		print("---- Change: %s -> %s" % [orig, copied])
		for i in range(len(orig_deps)):
			var left = orig_deps[i]
			var right = copied_deps[i]
			if left == right:
				print("==. %s == %s" % [left, right])
			else:
				print("||. %s || %s" % [left, right])

		# compare_trees(arg)

		print("---- Change: %s -> %s, %s -> %s" % [orig, copied, arg, target])

func compare_trees(arg):
	var target		= as_target(arg)
	var orig_ids	= []
	var copied_ids  = []
	var shared		= []

	for x in ResourceLoader.load(arg).instantiate().find_children("*"):
		orig_ids.append(x.get_instance_id())

	for x in ResourceLoader.load(target).instantiate().find_children("*"):
		copied_ids.append(x.get_instance_id())

	for i in range(len(orig_ids)):
		if orig_ids[i] in copied_ids:
			shared.append(orig_ids[i])

	if shared.is_empty():
		print("No shared ids")
		return

	print("Shared Ids:")
	for x in shared:
		print("- %s" % x)

func inspect_props(args):
	print("---- Props of: %s [%s]" % [args[0], args[0].get_instance_id()])
	for x in args[0].get_property_list():
		match x.name:
			"texture":
				print("- %s" % x)
				print("- %s" % args[0].get(x.name))
			"script":
				print("- %s" % x)
				print("- %s" % args[0].get(x.name))
			var name when name.get_extension() == "gd":
				print("- %s" % x)
				print("- %s" % args[0].get(x.name))

#  predicates --------------------------------------------------

func allow_prop(prop): # maybe[dict] -> bool
	match prop:
		null:
			return false
		{"name": var name, ..} when name.get_extension() == "gd":
			return false
		{"name": var name, ..} when name in exclusions:
			return false
		{"name": var name, "class_name": var cls, ..} when cls == &"":
			return false
		_:
			return true

func allow_resource(obj): # maybe[obj] -> bool
	match obj:
		null:
			return false
		_ when not is_instance_valid(obj):
			return false
		_ when not obj.has_method("is_class"):
			return false
		_ when not obj.is_class("Resource"):
			return false
		_ when obj.get_path() == "":   return false
		_ when obj.get_path() == null: return false
		_ when obj.get_path().contains(skip_dirs):
			msg("- skipping addon: %s" % obj.get_path(), 4)
			return false
		_:
			return true

#  enter/exit --------------------------------------------------

func enter_copy(obj) -> bool:
	# self.mute = 3
	if obj in handled:
		return false

	msg()
	msg("->")
	handled.append(obj)
	indent.append(INDENT_STR)
	return true

func exit_copy():
	msg("<-")
	indent.pop_back()

#  core saving fn --------------------------------------------------

func save_resource(res, new_path): # resource, str -> resource
	if FileAccess.file_exists(new_path) and not self.allow_overwrite:
		msg("Resource already exists: %s" % new_path)
		return res

	assert(res.resource_path, "Resource has no path: %s" % res)
	const msg_level		= 3
	var res_path	= res.resource_path
	var init_uid	= ResourceUID.path_to_uid(res_path)
	res				= res.duplicate()
	var target_ext  = new_path.get_extension()
	var exts		= Array(ResourceSaver.get_recognized_extensions(res))
	msg("Available Extensions for saving: %s" % ", ".join(exts), 1)

	match target_ext in exts:
		_ when target_ext == "gd":
			msg("- saving gdscript: %s (%s) -> %s " % [res_path, ResourceUID.path_to_uid(res_path), new_path], msg_level)
			assert(ResourceSaver.save(res, new_path, self.save_flags) == OK, "Saving Script Failed: %s" % res)

		true: # save using the resource saver
			msg("- saving with resource saver: %s (%s) -> %s " % [res_path, ResourceUID.path_to_uid(res_path), new_path], msg_level)
			assert(ResourceSaver.save(res, new_path, self.save_flags) == OK, "Saving Resource Failed: %s" % res)
			assert(FileAccess.file_exists(new_path), "New File doesn't exist: %s" % new_path)

		false: # save using file access
			msg("- saving using file access: %s (%s) -> %s " % [res_path, ResourceUID.path_to_uid(res_path), new_path], msg_level)
			var data = FileAccess.get_file_as_bytes(res_path)
			assert(len(data) > 0)
			var file = FileAccess.open(new_path, FileAccess.WRITE)
			assert(file != null, "Opening File to write failed: %s" % res)
			assert(file.store_buffer(data), "Writing to File Failed: %s" % res)
			file.close()


	assert(FileAccess.file_exists(new_path), "New File doesn't exist: %s" % new_path)
	ResourceSaver.set_uid(new_path, ResourceUID.create_id_for_path(new_path))
	# EditorInterface.get_resource_filesystem().reimport_files([ new_path ])
	# var reloaded = load(new_path)
	res.take_over_path(new_path)
	res.resource_path = as_target(new_path, export_relative)

	var new_uid = ResourceUID.path_to_uid(new_path)
	assert(init_uid != new_uid, "UID didn't change: %s" % new_path)
	# assert(new_uid != new_path, "UID wasn't: %s" % new_path)

	return res

#  main logic --------------------------------------------------

func copy_resource(arg): # str -> maybe[resource]
	assert(typeof(arg) == TYPE_STRING, arg)
	if not enter_copy(arg):
		return arg

	var result = null
	# save based on available extensions
	match arg.get_extension():
		"tscn","scn":
			result = copy_scene(arg)
		_ when self.save_flags == ResourceSaver.FLAG_BUNDLE_RESOURCES:
			print("Skipping on collect: %s" % arg)
			exit_copy()
			return arg
		"tres", "res":
			result = copy_godot_format(arg)
		"gd":
			result = copy_gdscript(arg)
		_:
			result = copy_file(arg)

	exit_copy()
	msg()
	return result

func copy_scene(arg): # str -> resource
	msg("-- Copying Scene: %s : %s" % [arg, type_string(typeof(arg))])
	var target		= as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	var inst		= res.instantiate()
	inst.name		= mod_name % inst.name

	var marker		= Node.new()
	marker.name		= "JGCollectMarker"
	msg("- Added Marker to: %s" % inst, 4)
	inst.add_child(marker)
	marker.owner = inst

	handle_props(inst)
	handle_children(inst)
	var repacked = pack_scene(inst)
	inst.free()
	repacked.resource_path = target
	var result = save_resource(repacked, target)
	return result

func copy_godot_format(arg): # str -> resource
	msg("-- Copying godot resource: %s" % arg)
	var target		= as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	msg("- Loaded GD Format: %s" % res, 4)
	handle_props(res)
	return save_resource(res, target)

func copy_gdscript(arg): # str -> resource:
	msg("-- Copying gdscript: %s" % arg)
	var target		= as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	return save_resource(res, target)

func copy_file(arg): # str -> resource
	msg("-- Copying file: %s" % arg, 4)
	var target		= as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	msg("- Loaded File: %s" % res, 4)
	return save_resource(res, target)

func handle_children(arg): # node -> none
	var children = arg.find_children("*", "", false)
	for child in children:
		msg("- child: %s" % child)
		handle_props(child)
		match child.scene_file_path:
			null, "":
				handle_children(child)
			var path:
				copy_resource(path)
				var target	= as_target(path)
				child.scene_file_path = target

func handle_props(arg): # obj -> none
	var props = arg.get_property_list()
	for prop in props:
		if not allow_prop(prop):
			continue

		match arg.get(prop.name):
			var val when allow_resource(val):
				msg("- prop: %s" % prop.name, 2)
				match copy_resource(val.get_path()):
					null: pass
					var result:
						msg("Setting prop: %s -> %s -> %s" % [arg, prop.name, result], 2)
						arg.set(prop.name, result)
			_:
				pass
