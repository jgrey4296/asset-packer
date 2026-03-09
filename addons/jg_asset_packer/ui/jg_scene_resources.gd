@tool
extends Control


var start_collapsed = false
var baseDict = {
	"Scenes"	: [],
	"Scripts"	: [],
	"Textures"  : [],
	"Fonts"		: [],
	}
var itemMap = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.list_resources(baseDict)
	pass

func setup_tree(keys:Array) -> void:
	if keys.is_empty():
		jg_utils.msg("Clearing", 0)
		self.visible = false
		$MenuBar/Tree.clear()
		self.itemMap.clear()
		return

	self.visible = true
	var tree = $MenuBar/Tree
	tree.set_column_title(0, "Resource")
	tree.set_column_title(1, "Collect?")
	tree.hide_root = true

	var root
	match tree.get_root():
		var x when is_instance_valid(x):
			jg_utils.msg("Reusing a root", 0)
			root = x
		_:
			jg_utils.msg("Creating a root", 0)
			root = tree.create_item()
			root.set_text(0, "Targeted:")

	jg_utils.msg("Root: %s" % root, 0)
	for cat in keys:
		if cat in self.itemMap:
			continue
		jg_utils.msg("Creating %s in %s" % [cat, root], 0)
		var node = tree.create_item(root)
		node.set_text(0, cat)
		self.itemMap[cat] = node

func list_resources(theDict) -> void:
	""" theDict : [ name : [paths] ] """
	jg_utils.msg("Listing: %s" % theDict, 0)
	self.setup_tree(theDict.keys())
	var tree = $MenuBar/Tree
	for val in theDict:
		var cat = self.itemMap[val]
		cat.set_collapsed_recursive(start_collapsed)
		self.add_entries(tree, cat, theDict[val])

func add_entries(tree, curr, subList) -> void:
	for val in subList:
		var node = tree.create_item(curr)
		node.set_text(0, val)

func collect_entries() -> Array:
	# TODO
	var result  = []
	var tree	= $MenuBar/Tree

	return result

func hide_entries() -> void:
	$MenuBar/Tree.get_root().set_collapsed(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
