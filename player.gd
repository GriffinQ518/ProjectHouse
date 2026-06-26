extends CharacterBody3D

@export var walk_speed: int
@export var run_speed: int
var speed = walk_speed

var is_running = false

var target_velocity = Vector3.ZERO

var mouse_input: bool = false
var mouse_rotation: Vector3
var rotation_input: float
var tilt_input: float
var player_rotation: Vector3
var camera_rotation: Vector3

@export var tilt_lower_limit: = deg_to_rad(-90.0)
@export var tilt_upper_limit: = deg_to_rad(90.0)
@export var camera_controller: Camera3D
@export var mouse_sensitivity: float = 0.5

const RAY_LENGTH = 1000.0
var should_pick_up: bool = false
var should_put_down: bool = false
var event_position: Vector2
var original_parent: Node3D

var pickup: RigidBody3D
var collider: CollisionShape3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
	elif event.is_action_pressed("pick_up"):
		should_pick_up = true
		event_position = event.position
	elif event.is_action_pressed("put_down"):
		should_put_down = true
		event_position = event.position
	pass

func _unhandled_input(event: InputEvent) -> void:
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	if mouse_input:
		rotation_input = -event.relative.x * mouse_sensitivity
		tilt_input = -event.relative.y * mouse_sensitivity
	pass

func update_camera(delta: float) -> void:
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
	mouse_rotation.y += rotation_input * delta
	
	player_rotation = Vector3(0.0, mouse_rotation.y, 0.0)
	camera_rotation = Vector3(mouse_rotation.x, 0.0, 0.0)
	
	camera_controller.transform.basis = Basis.from_euler(camera_rotation)
	camera_controller.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(player_rotation)
	
	rotation_input = 0
	tilt_input = 0
	pass

func _physics_process(delta: float) -> void:
	update_camera(delta)
	
	if should_pick_up:
		var space_state = get_world_3d().direct_space_state
		var from = camera_controller.project_ray_origin(event_position)
		var to = from + camera_controller.project_ray_normal(event_position) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if result:
			pickup = result.collider as RigidBody3D
			if pickup != null:
				pickup.freeze = true
				collider = pickup.get_child(0) as CollisionShape3D
				collider.set_deferred("disabled", true)
				original_parent = pickup.get_parent()
				pickup.reparent($CameraPivot/Camera3D/PickupPivot)
				pickup.position = Vector3(0, 0, 0)
		should_pick_up = false
	
	if should_put_down:
		var space_state = get_world_3d().direct_space_state
		var from = camera_controller.project_ray_origin(event_position)
		var to = from + camera_controller.project_ray_normal(event_position) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.exclude = [self]
		var result = space_state.intersect_ray(query)
		if pickup != null:
			pickup.freeze = false
			collider.set_deferred("disabled", false)
			pickup.reparent(original_parent)
			pickup.global_position = result.position
			pickup = null
		should_put_down = false
	var direction = Vector3.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	if direction != Vector3.ZERO:
		direction = (transform.basis * direction).normalized()
	
	is_running = Input.is_action_pressed("run_toggle")
	
	if is_running:
		speed = run_speed
	else:
		speed = walk_speed
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()
	
	pass
