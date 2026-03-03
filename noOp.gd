#  noOp.gd -*- mode: gdscript -*-
class_name noOp
extends MainLoop
"""

"""

func _init():
	pass

func _process(delta):
	var script = load("noOp.gd")
	var exts = ResourceSaver.get_recognized_extensions(script)
	print("exts: %s" % exts)

	return true

func _finalize():
	print("finializing")