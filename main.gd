extends Node3D

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D
@onready var mesh_final := $cull_front
@onready var texture := ($textureCatcher/SubViewport as SubViewport).get_texture()

func _ready():
	var mat = mesh_final.get_active_material(0)
	#print(mat)
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("prev_pass", texture)
		mat.set_shader_parameter("screen_size", texture.get_size())
	#else:
		#push_error("El material no es un ShaderMaterial en mesh_final.")
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
