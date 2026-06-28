extends Node3D

@export var offset: Vector3
@export var target: Node3D

func _process(delta: float) -> void:
	self.global_position = target.global_position + offset
	pass
