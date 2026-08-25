extends Node

@onready var interactable: Interactable = $Interactable

func _ready():
	interactable.on_interact.connect(handle_interact)

func handle_interact():
	print("I'm the parent, I'll handle this interaction")
