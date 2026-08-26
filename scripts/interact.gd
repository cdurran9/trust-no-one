extends Node
class_name Interact

@onready var interaction_raycast = $Camera3D/RayCast3D

var interaction_target : Interactable

func _process(_delta):
	if interaction_raycast.is_colliding():
		handle_interaction()
	else:
		handle_clear_interaction()
	if Input.is_action_just_pressed("interact") and interaction_target != null:
		interaction_target.interact()
		
func handle_interaction():
	var other = interaction_raycast.get_collider()
	if other != null:
		for child in other.get_children():
			if child is Interactable:
				interaction_target = child
				interaction_target.highlight()
				break

func handle_clear_interaction():
	interaction_target = null
