extends Area3D

@export var pedestal_ID: int

func _on_body_entered(body: Node3D) -> void:
	var box = body as box_moveable
	
	if (box != null) && (box.pedestal_ID == pedestal_ID):
		$HologramMesh.transparency = 0
		$PedestalMaskable/HologramMesh.transparency = 0
		box = null
		body.queue_free()
	pass
