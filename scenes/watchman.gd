extends Node3D
@onready var camera: Camera3D = $SubViewport2/Camera3D
@onready var head_2: Node3D = $head2

const SENSITIVITY = 0.008
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head_2.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
