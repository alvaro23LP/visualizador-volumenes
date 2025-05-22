extends Node3D

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D
@onready var cam_viewport1 := $SubViewport/Camera3D
@onready var viewport1 := $SubViewport
@onready var mesh := $Box_delanteras

func _ready():
	cam_fp.current = false
	cam_orbital.current = true
	cam_viewport1.global_transform = cam_orbital.global_transform

func _process(_delta):
	if viewport1.get_texture():
		mesh.get_active_material(0).set_shader_parameter("viewport_texture", viewport1.get_texture())
	
	if cam_fp.current:
		cam_viewport1.global_transform = cam_fp.global_transform
	else:
		cam_viewport1.global_transform = cam_orbital.global_transform

func _input(event):
	if event.is_action_pressed("toggle_camera"):
		cam_fp.current = !cam_fp.current
		cam_orbital.current = !cam_fp.current

	if cam_fp.current:
		cam_viewport1.global_transform = cam_fp.global_transform
	else:
		cam_viewport1.global_transform = cam_orbital.global_transform
		
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
