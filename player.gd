extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var tools: Node3D = $Head/Camera3D/Tools
@onready var watchman: Node3D = $Head/Camera3D/Tools/watchman

var watchman_tween_in
var watchman_tween_out
var zoomed_in := false

const SPEED := 1.0
const SENSITIVITY := 0.0025
const BOB_FREQ := 4.0
const BOB_AMP := 0.03
var t_bob := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (head.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	# Head bob
	t_bob += delta * velocity.length()
	camera.transform.origin = _headbob(t_bob, 0.03)
	tools.transform.origin = _headbob(t_bob, 0.002) - Vector3(0.0, 0.357, 0.0)

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		_zoom_in()

func _headbob(time, amp):
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * amp
	pos.x = cos(time * BOB_FREQ / 2) * amp
	return pos

func _zoom_in():
	if !zoomed_in:
		watchman_tween_in = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
		watchman_tween_in.tween_property(watchman, "position", Vector3(0.056, 0.325, -0.175), 0.8)
		zoomed_in = true
	else:
		watchman_tween_out = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		watchman_tween_out.tween_property(watchman, "position", Vector3(0.267, 0.216, -0.536), 0.8)
		zoomed_in = false
	
