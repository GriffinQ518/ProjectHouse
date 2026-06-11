extends Area3D

@export var offset: Vector3

func _on_body_entered(body: Node3D) -> void:
	body.global_position += offset
	pass
