extends Control

@export var inventory : Inventory

@onready var test_label = $RichTextLabel
@onready var visibility = $PanelContainer/Visibility
const eye_closed = preload("uid://cuvehkkt1hk47")
const eye_open = preload("uid://cj5v0i4rv643p")

func _ready():
	PlayerObserver.player_observation_changed.connect(change_visibility_icon)
	visibility.texture = eye_open if PlayerObserver.observing_player.size() > 0 else eye_closed
	if inventory != null:
		inventory.inventory_changed.connect(handle_inventory_changed)
	
func handle_inventory_changed(items: Array[ContrabandItem]):
	var names = ", ".join(items.map(func(item: ContrabandItem): return item.name)) if items.size() > 0 else "nothing"
	print(names)
	test_label.text = "You are carrying {items}".format({"items": names})

func toggle_crouch(is_crouched: bool):
	visibility.visible = true if is_crouched else false
	pass
	
func change_visibility_icon(is_now_observed: bool):
	visibility.texture = eye_open if is_now_observed else eye_closed
