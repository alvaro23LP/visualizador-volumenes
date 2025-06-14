extends Node3D

@export var rotation_speed := 0.01
@export var zoom_speed := 1.0
@export var min_distance := 2.0
@export var max_distance := 20.0

var distance := 8.0
var orbital_rotation := Vector2.ZERO

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		orbital_rotation.x -= event.relative.y * rotation_speed
		orbital_rotation.y -= event.relative.x * rotation_speed

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		distance = max(min_distance, distance - zoom_speed)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		distance = min(max_distance, distance + zoom_speed)

func _process(_delta):
	orbital_rotation.x = clamp(orbital_rotation.x, deg_to_rad(-89), deg_to_rad(89))
	var rot = Basis(Vector3.UP, orbital_rotation.y) * Basis(Vector3.RIGHT, orbital_rotation.x)
	var pos = rot * Vector3(0, 0, distance)
	$Camera3D.global_position = pos
	$Camera3D.look_at(Vector3.ZERO)
