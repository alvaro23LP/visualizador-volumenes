extends Sprite2D

const VELOCIDAD = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.x = get_viewport().size.x/2
	position.y = get_viewport().size.y/2
	print(get_viewport().size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#position.x += VELOCIDAD
	#position.y += VELOCIDAD
	
	#if position.x >= 1152 || position.y >= 648:
		#queue_free()
	if Input.is_action_pressed("ui_up") and position.y > 50:
		position.y -= VELOCIDAD
	elif Input.is_action_pressed("ui_down") and position.y < get_viewport().size.y - 50:
		position.y += VELOCIDAD
	elif Input.is_action_pressed("ui_left") and position.x > 50:
		position.x -= VELOCIDAD
	elif Input.is_action_pressed("ui_right") and position.x < get_viewport().size.x - 50:
		position.x += VELOCIDAD
		
	_on_viewport_size_changed()


# Mantener el personaje dentro de los límites cuando cambia el tamaño del viewport
func _on_viewport_size_changed():
	var viewport_size = get_viewport().size
	
	if position.x > viewport_size.x - 50:
		position.x = viewport_size.x - 100
	elif position.x < 50:
		position.x = 50

	if position.y > viewport_size.y - 50:
		position.y = viewport_size.y - 100
	elif position.y < 50:
		position.y = 50
