extends MeshInstance3D

@export var target: Node3D
@export var offset: Vector3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = target.global_position + offset
	global_rotation = target.global_rotation
	pass
