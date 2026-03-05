#  naming.gd -*- mode: gdscript -*-
@tool
class_name JGPopup
extends Popup
"""

"""

signal addon_named(text:String)


func _init():
	close_requested.connect(hide)

func _ready() -> void:
	find_child("LineEdit").text_submitted.connect(text_submit)

func text_submit(text):
	addon_named.emit(text)
	close_requested.emit()