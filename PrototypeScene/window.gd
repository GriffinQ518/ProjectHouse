extends Node3D

var mask: MeshInstance3D
var stencil: StandardMaterial3D
@export var transparency: float
@export var color: Color
@export var stencil_channel: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mask = $Mask as MeshInstance3D
	stencil = mask.get_active_material(0)
	
	mask.transparency = transparency
	
	stencil.albedo_color = color
	stencil.stencil_reference = stencil_channel
	pass
