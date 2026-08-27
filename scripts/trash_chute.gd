extends StaticBody3D

@onready var interactable = $Interactable

func _ready():
	interactable.on_interact.connect(handle_interact)
	
func handle_interact(player: Node3D):
	var inventory : Inventory
	for child in player.get_children():
		if child is Inventory:
			inventory = child
			break
	if inventory == null: return
	inventory.empty_inventory()
