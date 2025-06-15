extends Node3D

var deltas := []
const MAX_DELTAS := 2000
const FILE_PATH := "res://deltas.txt"

func _save_all():
	var file = FileAccess.open(FILE_PATH, FileAccess.ModeFlags.WRITE)
	if file:
		for d in deltas:
			file.store_line(str(d))
		file.close()
		print("FIN")
	else:
		push_error("Error al guardar todos los deltas.")

func calcular_media(_deltas: Array) -> float:
	if _deltas.is_empty():
		return 0.0  # Evita división por cero
	var suma := 0.0
	for d in _deltas:
		suma += d
	return suma / _deltas.size()


var VolumeLoader = preload("res://VolumeLoader.gd")

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D
@onready var cam_viewport1 := $SubViewport/Camera3D
@onready var cam_viewport2 := $SubViewport2/Camera3D
@onready var viewport1 := $SubViewport
@onready var viewport2 := $SubViewport2
@onready var mesh := $Box_trazado_rayos

var noise: FastNoiseLite
var tex3d: NoiseTexture3D

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
		
	var loader = VolumeLoader.new()
	var volume_tex = loader.create_volume_from_folder("res://slices/")
	mat.set_shader_parameter("textura3D", volume_tex)
	#mat.set_shader_parameter("tex_size", volume_tex.get_width())
	
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.026
	noise.fractal_octaves = 6
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.1
	
	tex3d = NoiseTexture3D.new()
	tex3d.noise = noise
	tex3d.width = 128
	tex3d.height = 128
	tex3d.depth = 128
	tex3d.seamless = true 


	mat.set_shader_parameter("volume_noise", tex3d)
		

func _on_h_slider_2_value_changed(value: float) -> void:
	noise.frequency = value
	print(value)
	tex3d.noise = noise
	
func _on_h_slider_3_value_changed(value: float) -> void:
	noise.fractal_octaves = int(value)
	tex3d.noise = noise
	
func _on_h_slider_4_value_changed(value: float) -> void:
	noise.fractal_lacunarity = value
	tex3d.noise = noise




	
var time := 0.0
var noise_speed := Vector3(1.5, -2.0, 1.2)  # Velocidad por eje

func _process(_delta):
	var mat = mesh.get_active_material(0)
	if viewport1.get_texture():
		mat.set_shader_parameter("viewport_texture", viewport1.get_texture())
	if viewport2.get_texture():
		mat.set_shader_parameter("viewport_texture2", viewport2.get_texture())

	var bounds = mesh.get_aabb()
	mat.set_shader_parameter("volume_min", bounds.position)
	mat.set_shader_parameter("volume_size", bounds.size)

	mat.set_shader_parameter("volume_noise", tex3d)
	
	#time += _delta
	##noise.offset = noise_speed * time
	#var fps_scale := Engine.get_frames_per_second() / 60.0
	#noise.offset = Vector3(
		#time * 6.0 * fps_scale,
		#time * 8.0 * fps_scale,
		#time * 10.0 * fps_scale
	#)
	##var offset = Vector3(sin(time*0.3), cos(time * 0.2), sin(time * 0.1))
	##noise.offset = Vector3(0.0, 0.0, time)
	#tex3d.noise= noise
	
	time += _delta/2
	var offset = (noise_speed/2.0) * time
#		var offset = noise_speed * time * 3.0  # Escala para más movimiento
	mat.set_shader_parameter("noise_offset", offset)
	
	#print("noise fre: ", noise.frequency)
	#print("noise fracta lacu: ", noise.fractal_lacunarity)
	#print("noise octaves: ", noise.fractal_octaves)
	#mat.set_shader_parameter("noise_offset", offset)

	if cam_fp.current:
		cam_viewport1.global_transform = cam_fp.global_transform
		cam_viewport2.global_transform = cam_fp.global_transform
	else:
		cam_viewport1.global_transform = cam_orbital.global_transform
		cam_viewport2.global_transform = cam_orbital.global_transform
		
	### DELTA A TXT
	if deltas.size() < MAX_DELTAS:
		deltas.append(_delta)
		if deltas.size() == MAX_DELTAS:
			print(calcular_media(deltas))

func _input(event):
	if event.is_action_pressed("toggle_camera"):
		cam_fp.current = !cam_fp.current
		cam_orbital.current = !cam_fp.current

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
