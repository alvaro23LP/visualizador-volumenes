extends CharacterBody3D

@export var speed := 4.0
@export var mouse_sensitivity := 0.003

var rotation_x := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Camera3D.position.y = 1.0

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity
		rotation = Vector3(0, rotation.y, 0)
		rotation_x = clamp(rotation_x - event.relative.y * mouse_sensitivity, deg_to_rad(-89), deg_to_rad(89))
		$Camera3D.rotation.x = rotation_x

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	# añadir subir y bajar
	
	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
