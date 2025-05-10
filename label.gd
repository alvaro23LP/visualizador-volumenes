extends Label

var vida:int = 10
var daño = 1
var NOMBRE:String = "Alvaro"
var enemigo = "Asesino"
var baul = ["casco", "armadura", "otro"]
var esta_vivo = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = NOMBRE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
