extends Node3D

@export var mesh_to_snap: MeshInstance3D
@export var snap_name: String

@onready var sub_camera := $SubViewport/Node3D/Camera3D
var main_camera_path = "../FirstPerson/Camera3D"
var main_camera : Camera3D = null

func _ready():
	var sub_viewport = $SubViewport
	var mesh = $SubViewport/Node3D/MeshInstance3D
	
	if has_node(main_camera_path):
		main_camera = get_node(main_camera_path)
	else:
		push_warning("No se encontró la cámara principal.")
	
	mesh.mesh = mesh_to_snap
	await  get_tree().create_timer(0.5).timeout
	var img = sub_viewport.get_viewport().get_texture().get_image()
	var image_path = "images/%s.png" % snap_name
	img.save_png(image_path)
	
func _process(_delta):
	if main_camera and sub_camera:
		sub_camera.global_transform = main_camera.global_transform
		#print(sub_camera.global_position)
		#print("main: %s" % main_camera.global_position)	
