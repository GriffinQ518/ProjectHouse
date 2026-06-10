extends CharacterBody3D

@export var walk_speed: int
@export var run_speed: int
var speed = walk_speed

var is_running = false

var target_velocity = Vector3.ZERO

func _unhandled_input(event: InputEvent) -> void:
	pass

func _update_camera(delta) -> void:
	pass

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	print(direction)
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	is_running = Input.is_action_pressed("run_toggle")
	
	if is_running:
		speed = run_speed
	else:
		speed = walk_speed
	
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()
