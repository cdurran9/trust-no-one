extends CharacterBody3D

var potential_target: Node3D
var target: Node3D
var fov_degrees := 90.0
var eye_height := 0.38

@export var sight_range := 3.0

@onready var vision_range = $VisionRange
@onready var vision_collision = $VisionRange/CollisionShape3D

func _ready():
	vision_range.body_entered.connect(_on_sight_area_body_entered)
	vision_collision.shape.set("radius", sight_range)
	
func _physics_process(_delta):
	var can_see = can_see_target()
	if can_see and target == null:
		PlayerObserver.add_observer(self)
		target = potential_target
	elif not can_see and target != null:
		PlayerObserver.remove_observer(self)
		target = null

func _on_sight_area_body_entered(body: Node3D) -> void:
	if body is Player:
		potential_target = body

func can_see_target() -> bool:
	if not potential_target:
		return false

	var to_target := potential_target.global_position - global_position
	var distance := to_target.length()
	if distance > sight_range:
		return false

	var forward := -global_transform.basis.z
	var angle_to_target := forward.angle_to(to_target.normalized())
	if angle_to_target > deg_to_rad(fov_degrees / 2.0):
		return false

	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3.UP * eye_height,
		potential_target.global_position + Vector3.UP * 0.5
	)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)

	return result.is_empty() or result.collider == potential_target
