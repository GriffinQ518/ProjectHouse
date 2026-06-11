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

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()
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
