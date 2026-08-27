extends CharacterBody3D
class_name Player

var mouse_captured := false
var mouse_input : Vector2
var input_dir : Vector2
var crouching := false

@export var reverse_y := true
@export var reverse_x := true
@export var speed := 5.0
@export var interact_range := 3.0
@export var crouch_height := 1.3
@export var normal_height := 1.72

@onready var camera_3d = $Head/Camera3D
@onready var head = $Head
@onready var interact_raycast = $Head/Camera3D/RayCast3D
@onready var inventory = $Inventory
@onready var hud = $HUD

func _ready():
	capture_mouse()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		release_mouse() if mouse_captured else capture_mouse()
	if Input.is_action_just_pressed("crouch"):
		toggle_crouch()
	
func _physics_process(delta):
	rotate_head()
	input_dir = Input.get_vector("left", "right", "forward", "back")
	var dir_2d = input_dir.rotated(-head.rotation.y)
	var dir_3d = Vector3(dir_2d.x, 0, dir_2d.y)
	var weight = calculate_weight()
	var actual_speed = speed - weight
	velocity.x = dir_3d.x * actual_speed
	velocity.z = dir_3d.z * actual_speed
	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_input = event.screen_relative
	
func rotate_head():
	if not mouse_captured: return
	head.rotation_degrees.y += mouse_input.x * (-1 if reverse_x else 1)
	head.rotation_degrees.x += mouse_input.y * (-1 if reverse_y else 1)
	
	mouse_input = Vector2.ZERO
	head.rotation_degrees.x = clamp(head.rotation_degrees.x, -90, 90)
	
func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mouse_captured = true
	
func release_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	mouse_captured = false
	
func calculate_weight() -> float:
	if inventory.carrying.size() == 0: return 0
	return inventory.carrying.reduce(func(accum, item: ContrabandItem):
		return accum + 2 if item.heavy else accum + 1
	, 0)
	
func toggle_crouch():
	var crouch_tween := create_tween()
	crouching = not crouching
	var new_height := crouch_height if crouching else normal_height
	crouch_tween.tween_property(head, "position", Vector3(0, new_height, 0), 0.2)
	hud.toggle_crouch(crouching)
