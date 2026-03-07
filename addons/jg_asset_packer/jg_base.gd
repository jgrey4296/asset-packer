#  jg_base.gd -*- mode: gdscript-ts -*-
@tool
class_name JG_Base_Menu
extends EditorContextMenuPlugin
"""

"""

const export_relative	= false
const cache_mode		= ResourceLoader.CACHE_MODE_IGNORE_DEEP
const exclusions		= ["Node", "Process", "Thread Group", "Physics Interpolation",  "owner",  "multiplayer"]
const skip_dirs			= "addons"
const mod_name			= "%s-coll"
var allow_overwrite		= true
var save_flags			= ResourceSaver.FLAG_NONE
var handled				= []

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
		if header: jg_utils.header("(%s) deps of %s [%s]:" % [len(deps), arg, uid], 3)
		for x in deps:
			print("- %s" % x)
			if "::::" in x: report_deps([x.split("::::")[1]], false)

		if header: jg_utils.msg("----\n", 3)

func report_change(args):
	for arg in args:
		var target			= jg_utils.as_target(arg)
		var orig			= ResourceUID.path_to_uid(arg)
		var copied			= ResourceUID.path_to_uid(target)
		var orig_deps		= ResourceLoader.get_dependencies(arg)
		var copied_deps		= ResourceLoader.get_dependencies(target)
		assert(len(orig_deps) == len(copied_deps), "Deps differ: %s / %s" % [orig_deps, copied_deps])

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
	var target		= jg_utils.as_target(arg)
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
	jg_utils.debug = 0
	jg_utils.header("Props of: %s [%s]" % [args[0], args[0].get_instance_id()], 4)

	var target			= args[0]
	var props			= get_copy_props(target)
	var max				= len(props)
	jg_utils.imsg("Prop Count: %s" % max)
	enter_copy(target)
	for i in range(max):
		var x = props[i]
		match target.get(x.name):
			var val when x.name == "script":
				jg_utils.imsg("Script ... %s" % val, 1)
				for prop in val.get_script_property_list():
					jg_utils.imsg("- %s" % prop, 1)
			0, null, "":
				jg_utils.imsg("Null   ... %s" % x.name, 0)
			var val when target.property_can_revert(x.name):
				jg_utils.imsg("Revert ... %s : %s : %s" % [x.name, val, type_string(typeof(val))], 1)
			var val:
				jg_utils.imsg("Else   ... %s : %s" % [x.name, target.get(x.name)], 1)
	jg_utils.header("----", 4)
	enter_copy(target)

#  predicates --------------------------------------------------

func get_script_props(obj) -> Array:
	if obj.get("script") == null:
		return []

	return Array(obj
		.get("script").get_script_property_list()
		.map(func(val): return val.name)

		)

func get_copy_props(obj) -> Array:
	""" Get props that need to be copied

	Includes any props that point to:
	- resources,
	- scripts,
	- exported script props
	"""
	if obj == null: return []

	var properties  = obj.get_property_list()
	var sprops		= get_script_props(obj)
	var allowed		= properties.filter(func(elem): return allow_prop(elem, sprops))
	# print("Properties: %s" % [properties.map(func(elem): return elem.name)])
	# print("Script Properties :%s" % [sprops])
	# print("Allowed :%s" % [allowed.map(func(elem): return elem.name)])

	return allowed

func allow_prop(prop, script_props:=[]): # maybe[dict] -> bool
	match prop:
		null:
			return false
		{"name": var name, ..} when prop.name in script_props:
			return true
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
			jg_utils.imsg("skipping addon: %s" % obj.get_path(), 4)
			return false
		_:
			return true

#  enter/exit --------------------------------------------------

func enter_copy(obj) -> bool:
	if obj in handled:
		return false

	jg_utils.msg()
	jg_utils.msg("->")
	handled.append(obj)
	jg_utils.indent()
	return true

func exit_copy():
	jg_utils.msg("<-")
	jg_utils.deindent()

#  core saving fn --------------------------------------------------

func save_resource(res, new_path): # resource, str -> resource
	if FileAccess.file_exists(new_path) and not self.allow_overwrite:
		jg_utils.imsg("Resource already exists: %s" % new_path, 10)
		return res

	assert(res.resource_path, "Resource has no path: %s" % res)
	const msg_level		= 3
	var res_path	= res.resource_path
	var init_uid	= ResourceUID.path_to_uid(res_path)
	res				= res.duplicate()
	var target_ext  = new_path.get_extension()
	var exts		= Array(ResourceSaver.get_recognized_extensions(res))
	jg_utils.imsg("Available Extensions for saving: %s" % ", ".join(exts), 1)

	match target_ext in exts:
		_ when target_ext == "gd":
			jg_utils.imsg("saving gdscript: %s (%s) -> %s " % [res_path, ResourceUID.path_to_uid(res_path), new_path], msg_level)
			assert(ResourceSaver.save(res, new_path, self.save_flags) == OK, "Saving Script Failed: %s" % res)

		true: # save using the resource saver
			jg_utils.imsg("saving with resource saver: %s (%s) -> %s " % [res_path, ResourceUID.path_to_uid(res_path), new_path], msg_level)
			assert(ResourceSaver.save(res, new_path, self.save_flags) == OK, "Saving Resource Failed: %s" % res)
			assert(FileAccess.file_exists(new_path), "New File doesn't exist: %s" % new_path)

		false: # save using file access
			jg_utils.imsg("saving using file access: %s (%s) -> %s " % [res_path, ResourceUID.path_to_uid(res_path), new_path], msg_level)
			var data = FileAccess.get_file_as_bytes(res_path)
			assert(len(data) > 0, "No data was read: %s" % res_path)
			var file = FileAccess.open(new_path, FileAccess.WRITE)
			assert(file != null, "Opening Target File to write failed: %s" % new_path)
			assert(file.store_buffer(data), "Writing to File Failed: %s" % new_path)
			file.close()


	assert(FileAccess.file_exists(new_path), "New File doesn't exist: %s" % new_path)
	ResourceSaver.set_uid(new_path, ResourceUID.create_id_for_path(new_path))
	# EditorInterface.get_resource_filesystem().reimport_files([ new_path ])
	# var reloaded = load(new_path)
	res.take_over_path(new_path)
	res.resource_path = jg_utils.as_target(new_path, export_relative)

	var new_uid = ResourceUID.path_to_uid(new_path)
	assert(init_uid != new_uid, "UID didn't change: %s" % new_path)
	# assert(new_uid != new_path, "UID wasn't: %s" % new_path)

	return res

#  main logic --------------------------------------------------

func copy_resource(arg): # str -> maybe[resource]
	assert(typeof(arg) == TYPE_STRING, "Resource is not a string: %s" % arg)
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
	jg_utils.msg()
	return result

func copy_scene(arg): # str -> resource
	jg_utils.header("Copying Scene: %s : %s" % [arg.to_upper(), type_string(typeof(arg))], 4)
	var target		= jg_utils.as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	var inst		= res.instantiate()
	inst.name		= mod_name % inst.name

	var marker		= Node.new()
	marker.name		= "JGCollectMarker"

	handle_props(inst)
	handle_children(inst)

	jg_utils.imsg("Added Marker to: %s" % inst, 4)
	inst.add_child(marker)
	marker.owner = inst

	var repacked = jg_utils.pack_scene(inst)
	# inst.free()
	repacked.resource_path = target
	var prev = self.allow_overwrite


	var result = save_resource(repacked, target)
	return result

func copy_godot_format(arg): # str -> resource
	jg_utils.header("Copying godot resource: %s" % arg.to_upper(), 3)
	var target		= jg_utils.as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	jg_utils.imsg("- Loaded GD Format: %s" % res, 2)
	handle_props(res)
	return save_resource(res, target)

func copy_gdscript(arg): # str -> resource:
	jg_utils.header("Copying gdscript: %s" % arg.to_upper(), 3)
	var target			= jg_utils.as_target(arg)
	var res				= ResourceLoader.load(arg, "", cache_mode)
	return save_resource(res, target)

func copy_file(arg): # str -> resource
	jg_utils.header("Copying file: %s" % arg.to_upper(), 3)
	var target		= jg_utils.as_target(arg)
	var res			= ResourceLoader.load(arg, "", cache_mode)
	jg_utils.imsg("Loaded File: %s" % res, 2)
	return save_resource(res, target)

func handle_children(arg): # node -> none
	var children = arg.find_children("*", "", false)
	for child in children:
		jg_utils.header("Child: %s" % child.name.to_upper(), 2)
		handle_props(child)
		match child.scene_file_path:
			null, "":
				enter_copy(child)
				handle_children(child)
				exit_copy()
			var path:
				copy_resource(path)
				var target	= jg_utils.as_target(path)
				child.scene_file_path = target

func handle_props(obj): # obj -> none
	if is_instance_of(obj, Node) and obj.name == "NodeWithArray":
		print("List Val: %s" % [obj.get("theList")])

	var val		= null
	var sprops = get_script_props(obj)
	for prop in get_copy_props(obj):
		match prop.name:
			"script":
				val = obj.get_script()
			var name:
				val = obj.get(name)

		match val:
			null: pass
			_ when allow_resource(val):
				jg_utils.imsg("prop: %s" % prop.name.to_upper(), 2)
				match copy_resource(val.get_path()):
					null: pass
					var result when prop.name == "script":
						jg_utils.imsg("Setting prop: %s -> %s -> %s" % [obj, prop.name.to_upper(), result], 2)
						obj.set_script(result)
					var result:
						jg_utils.imsg("Setting prop: %s -> %s -> %s" % [obj, prop.name.to_upper(), result], 2)
						obj.set(prop.name, result)
			_ when prop.name in sprops:
				jg_utils.imsg("A script prop: %s -> %s (%s)" % [prop.name, val, is_instance_valid(val)], 2)
				obj.set(prop.name, val)
