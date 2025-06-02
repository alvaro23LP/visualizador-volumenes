extends Node

func create_volume_from_folder(folder_path: String) -> ImageTexture3D:
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("No se pudo abrir la carpeta: " + folder_path)
		return null

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

	var width = slices[0].get_width()
	var height = slices[0].get_height() 
	var depth = slices.size()
	var tex3d := ImageTexture3D.new()
	var error = tex3d.create(Image.FORMAT_RGB8, width, height, depth, false, slices)
	if error != OK:
		push_error("Error al crear la textura 3D: " + str(error))
		return null
		
	return tex3d
