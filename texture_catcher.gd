extends Node3D



@export var mesh_to_snap: MeshInstance3D
@export var snap_name: String

func _ready():
	var sub_viewport = $SubViewport
	var mesh = $SubViewport/Node3D/MeshInstance3D
	
	mesh.mesh = mesh_to_snap
	await  get_tree().create_timer(0.5).timeout
	var img = sub_viewport.get_viewport().get_texture().get_image()
	var image_path = "images/%s.png" % snap_name
	img.save_png(image_path)
	
