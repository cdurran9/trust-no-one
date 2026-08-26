extends Control

@export var inventory : Inventory

@onready var test_label = $RichTextLabel

func _ready():
	if inventory != null:
		inventory.inventory_changed.connect(handle_inventory_changed)
	
func handle_inventory_changed(items: Array[ContrabandItem]):
	var names = items.map(func(item: ContrabandItem): return item.name) if items.size() > 0 else "nothing"
	print(names)
	test_label.text = "You are carrying {items}".format({"items": ", ".join(names)})
