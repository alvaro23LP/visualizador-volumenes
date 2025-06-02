extends Node3D

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D
@onready var cam_viewport1 := $SubViewport/Camera3D
@onready var cam_viewport2 := $SubViewport2/Camera3D
@onready var viewport1 := $SubViewport
@onready var viewport2 := $SubViewport2
@onready var mesh := $Box_trazado_rayos

func _ready():
	cam_fp.current = false
	cam_orbital.current = true
	cam_viewport1.global_transform = cam_orbital.global_transform
	cam_viewport2.global_transform = cam_orbital.global_transform
	
	await get_tree().process_frame
	var mat = mesh.get_active_material(0)
	if viewport1.get_texture():
		mat.set_shader_parameter("viewport_texture", viewport1.get_texture())
		
	if viewport2.get_texture():
		mat.set_shader_parameter("viewport_texture2", viewport2.get_texture())
		
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.02
	noise.fractal_octaves = 6
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.1
	

	var tex3d = NoiseTexture3D.new()
	tex3d.noise = noise
	tex3d.width = 128
	tex3d.height = 128
	tex3d.depth = 128

	mat.set_shader_parameter("volume_noise", tex3d)

var time := 0.0
func _process(delta):
	var mat = mesh.get_active_material(0)
	if viewport1.get_texture():
		mat.set_shader_parameter("viewport_texture", viewport1.get_texture())
	if viewport2.get_texture():
		mat.set_shader_parameter("viewport_texture2", viewport2.get_texture())

	var bounds = mesh.get_aabb()
	mat.set_shader_parameter("volume_min", bounds.position)
	mat.set_shader_parameter("volume_size", bounds.size)

	time += delta/2
	var offset = Vector3(sin(time*0.3), cos(time * 0.2), sin(time * 0.1))
	mat.set_shader_parameter("noise_offset", offset)


	if cam_fp.current:
		cam_viewport1.global_transform = cam_fp.global_transform
		cam_viewport2.global_transform = cam_fp.global_transform
	else:
		cam_viewport1.global_transform = cam_orbital.global_transform
		cam_viewport2.global_transform = cam_orbital.global_transform

func _input(event):
	if event.is_action_pressed("toggle_camera"):
		cam_fp.current = !cam_fp.current
		cam_orbital.current = !cam_fp.current

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
