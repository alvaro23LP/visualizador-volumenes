extends Node3D

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D

@onready var viewport := $Node3D/backViewport
@onready var mesh_final := $cull_back


func _ready():
	var shader_material := mesh_final.get_active_material(0) as ShaderMaterial
	shader_material.set_shader_parameter("backface_texture", viewport.get_texture())
	var image: Image = viewport.get_texture().get_image()
	image.save_png("user://coordenadas_rgb.png")

	#var mat = mesh_final.get_active_material(0)
	#print(mat)
	#if mat and mat is ShaderMaterial:
		#var texture = viewport.get_texture()
		#mat.set_shader_parameter("prev_pass", texture)
		#mat.set_shader_parameter("screen_size", texture.get_size())
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
