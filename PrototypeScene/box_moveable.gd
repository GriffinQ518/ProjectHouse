extends RigidBody3D

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_just_pressed("pick_up"):
		print("Clicked")
	pass # Replace with function body.
