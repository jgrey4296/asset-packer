#  jg_utils.gd -*- mode: gdscript -*-
@tool
class_name jg_utils
"""

"""

static var export_prefix	: String	= "res://addons/"
static var export_target	: String	= "MyCollectedAddon"
static var debug			: int		= 0
const INDENT_STR						= "  "
static var indent_amt : int				= 0

#  misc --------------------------------------------------

static func as_target(x, relative:=false):
	var prefix = jg_utils.export_prefix
	var target = jg_utils.export_target
	match x.get_extension():
		_ when relative:
			return "./%s" % x.get_file()
		"gd":
			var base = "%s.gd" % x.get_basename().get_file()
			return prefix.path_join(target).path_join(base)
		_:
			return prefix.path_join(target).path_join(x.get_file())

static func ensure_export_dir() -> bool:
	if DirAccess.open(jg_utils.export_prefix).dir_exists(jg_utils.export_target):
		assert(false, "target already exists: %s" % jg_utils.export_prefix.path_join(jg_utils.export_target))
		return false


	msg("- Making export dir: %s/%s" % [export_prefix, export_target])
	DirAccess.open(export_prefix).make_dir(export_target)
	return true

#  scene modification --------------------------------------------------

static func pack_scene(arg:Node) -> PackedScene:
	msg("---- Packing Scene: %s" % arg)
	if arg == null:
		return null
	var scene = to_scene(arg)
	return scene

static func to_scene(node:Node) -> PackedScene:
	if node == null:
		return null
	var scene = PackedScene.new()
	match scene.pack(node):
		OK: pass
		var err: push_error("failed to pack scene")

	return scene

static func claim_children(node):
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

static func reset_owners(args):
	for arg in args:
		if arg.get_parent() == null:
			claim_children(arg)
		else:
			claim_children(arg.get_parent())

#  logging --------------------------------------------------

static func indent():
	jg_utils.indent_amt += 1

static func deindent():
	jg_utils.indent_amt -= 1
	if jg_utils.indent_amt < 0:
		jg_utils.indent_amt = 0

static func msg(msg:="", level:=0):
	if level <= debug:
		return
	print("%s" % msg)

static func imsg(msg, level:=0):
	""" msg, with indentation """
	msg("%s : %s" % [INDENT_STR.repeat(jg_utils.indent_amt), str(msg)], level)

static func header(msg, level:=0):
	var line = "-".repeat(level)
	imsg("%s %s %s" % [line, str(msg), line], level)
