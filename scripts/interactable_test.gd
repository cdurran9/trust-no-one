extends Node

var mat : Material
var highlight_width := 0

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

func handle_interact():
	print("I'm the parent, I'll handle this interaction")
