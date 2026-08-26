extends Node

var mat : Material
var highlight_width := 0

@export var contraband : ContrabandItem

@onready var interactable: Interactable = $Interactable
@onready var mesh = $MeshInstance3D

func _ready():
	interactable.on_interact.connect(handle_interact)
	interactable.is_highlighted.connect(show_highlight)
	mat = mesh.get_surface_override_material(0)
	
func _process(_delta):
	mat.next_pass.set("shader_parameter/outline_width", highlight_width)
	if highlight_width == 0: return
	highlight_width = 0
	
func show_highlight():
	highlight_width = 10

func handle_interact(player: Node3D):
	var inventory : Inventory
	for child in player.get_children():
		if child is Inventory:
			inventory = child
			break
	if inventory == null: return
	print("Picking up {item}".format({"item": contraband.name}))
	var added = inventory.add_item(contraband)
	if not added: return
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_DISABLED
