extends Node3D

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D

func _ready():
	cam_fp.current = false
	cam_orbital.current = true

func _input(event):
	if event.is_action_pressed("toggle_camera"):
		cam_fp.current = !cam_fp.current
		cam_orbital.current = !cam_fp.current
		
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
