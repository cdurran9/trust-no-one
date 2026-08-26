class_name Interactable extends Node3D

signal on_interact(player: Node3D)
signal is_highlighted

var text_visible := false

@export var interact_text := "Interact"

@onready var interact_text_node : Label3D = $InteractText

func _ready():
	if interact_text_node != null:
		interact_text_node.text = interact_text
		
func _process(_delta):
	interact_text_node.visible = text_visible
	text_visible = false

func interact(player: Node3D):
	on_interact.emit(player)

func highlight():
	text_visible = true
	is_highlighted.emit()
