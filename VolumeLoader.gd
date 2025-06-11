extends Node

func create_volume_from_folder(folder_path: String) -> ImageTexture3D:
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("No se pudo abrir la carpeta: " + folder_path)
		return null

	# 1. Carga los slices originales
	var slices := []
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.to_lower().ends_with(".png"):
			var file_path = folder_path.path_join(file_name)
			var texture := load(file_path) as Texture2D
			if texture:
				var img := texture.get_image()
				if img:
					img.convert(Image.FORMAT_RGB8)
					slices.append(img)
		file_name = dir.get_next()
	dir.list_dir_end()

	if slices.size() == 0:
		push_error("No se encontraron imágenes válidas en: " + folder_path)
		return null

	# 2. Calcula dimensiones y padding
	var w = slices[0].get_width()
	var h = slices[0].get_height()
	var d = slices.size()
	var target = max(w, h)
	
	# Si el número de slices es menor al target, añadimos blank arriba/abajo
	if d < target:
		var to_pad = target - d
		var pad_top = to_pad / 2
		var pad_bot = to_pad - pad_top

		# Crea una imagen vacía (negra) del mismo tamaño
		var blank = Image.create(w, h, false, Image.FORMAT_RGB8)

		# Inserta al principio
		for i in range(pad_top):
			slices.insert(0, blank.duplicate())
		# Inserta al final
		for i in range(pad_bot):
			slices.append(blank.duplicate())

		d = slices.size() 
	
	# 3. Crea la textura 3D
	var tex3d := ImageTexture3D.new()
	var error = tex3d.create(Image.FORMAT_RGB8, w, h, d, false, slices)
	if error != OK:
		push_error("Error al crear la textura 3D: " + str(error))
		return null
		
	return tex3d
