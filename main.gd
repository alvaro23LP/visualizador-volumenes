extends Node3D

@onready var cam_orbital := $OrbitalCamera/Camera3D
@onready var cam_fp := $FirstPerson/Camera3D

func _ready():
	cam_fp.current = false
	cam_orbital.current = true

func _input(event):
	if event.is_action_pressed("ui_select"):
		cam_fp.current = !cam_fp.current
		cam_orbital.current = !cam_fp.current
