extends Control


@onready var mesh := $"../Box_trazado_rayos"
@onready var ob := $OptionButton
var mat : ShaderMaterial

# Cuántos colores manejar
const COLOR_COUNT = 3
var current_index := 0

func _ready() -> void:
	mat = mesh.get_active_material(0) as ShaderMaterial
	
	# Inicializa controles con valores actuales
	$HSlider.value = mat.get_shader_parameter("umbral_densidad")
	$HSlider_paso.value = mat.get_shader_parameter("paso")
	mat.set_shader_parameter("paso", 0.0001)
	print("PASO: ", mat.get_shader_parameter("paso"))
	#$HSlider_paso.value = 0.0100000;
	#mat.set_shader_parameter("paso", 0.0010000)
	
	# Inicializar OptionButton
	for i in COLOR_COUNT:
		ob.add_item("Color %d" % i, i)
	ob.item_selected.connect(self._on_index_changed)
	
	 # Conectar el ColorPicker
	$ColorPicker.color_changed.connect(_on_color_changed)

	# Inicializar picker con el valor del primer color
	var c = Color(0.0, 0.0, 1.0, 0.1) 
	$ColorPicker.color = c
	
	mat.set_shader_parameter("extra_color_0", c)
	c = Color(0.5, 0.0, 0.0, 0.2) 
	mat.set_shader_parameter("extra_color_1", c)
	c = Color(0.8, 1.0, 1.0, 0.2) 
	mat.set_shader_parameter("extra_color_2", c)
	#c = Color(1.0, 1.0, 1.0, 0.2) 
	#mat.set_shader_parameter("extra_color_3", c)

func _process(_delta: float) -> void:
	pass
	
	
func _on_index_changed(idx):
	current_index = idx
	var param = "extra_color_%d" % idx
	var c = mat.get_shader_parameter(param)
	if c == null:
		c = Color(0.5, 0.5, 0.5, 0.05) 
	$ColorPicker.color = c

func _on_color_changed(color):
	var param = "extra_color_%d" % current_index
	mat.set_shader_parameter(param, color)

func _on_h_slider_value_changed(value: float) -> void:
	mat.set_shader_parameter("umbral_densidad", value)


#func _on_h_slider_paso_value_changed(value: float) -> void:
	#mat.set_shader_parameter("paso", value/10.0)
