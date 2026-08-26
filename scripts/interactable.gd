extends Node
class_name Interactable

signal on_interact
signal is_highlighted

@export var interact_text := "Interact"
@export var interact_text_node : Label3D

func _ready():
	if interact_text_node != null:
		interact_text_node.text = interact_text

func interact():
	on_interact.emit()

func highlight():
	is_highlighted.emit()
