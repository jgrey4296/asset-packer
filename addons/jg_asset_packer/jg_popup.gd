#  naming.gd -*- mode: gdscript -*-
@tool
class_name JGPopup
extends ConfirmationDialog
"""

TODO: allow selection of types to copy/exclude
"""

static var default_name		: String	= "MyCollectedAddon"
static var default_debug	: int		= 0
static var default_prefix	: String	= "res://addons/"

signal addon_named(text:String, prefix:String, debug:int)


func _init():
	close_requested.connect(hide)

func _ready() -> void:
	$control/name/value.placeholder_text	= JGPopup.default_name
	$control/prefix/value.placeholder_text  = JGPopup.default_prefix
	$control/debug/value.value				= JGPopup.default_debug
	confirmed.connect(complete)

func complete():
	JGPopup.default_debug	= $control/debug/value.value
	match $control/prefix/value.text:
		"": pass
		var prefix:
			JGPopup.default_prefix  = prefix

	match $control/name/value.text:
		"": pass
		var text:
			JGPopup.default_name = text

	print("Values: %s %s" % [JGPopup.default_prefix.path_join(JGPopup.default_name), JGPopup.default_debug])
	addon_named.emit(
		JGPopup.default_name,
		JGPopup.default_prefix,
		JGPopup.default_debug,
		)

	close_requested.emit()
