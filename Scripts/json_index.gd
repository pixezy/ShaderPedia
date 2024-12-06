@tool
extends Node
@export_tool_button("Process Modules", "File") var pm = _process_modules

var id_counter: int = 0
var viewport: SubViewport

func _ready() -> void:
	pass

func _process_modules() -> void:
	id_counter = 0
	generate_json()
	generate_card_images()
	print("Data and images generation finished.")

func generate_json():
	var index = {}	
	_scan_directory("res://Modules", index)		
	var data_io = DataIO.new()
	data_io.writeJSON(index)

func create_viewport() -> void:
	viewport = SubViewport.new()
	viewport.size = Vector2(500, 500)
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	add_child(viewport)

func remove_viewport() -> void:
	remove_child(viewport)
	viewport.queue_free()

func _scan_directory(path: String, index: Dictionary) -> void:
	var directory = DirAccess.open(path)
	if not directory:
		return

	directory.list_dir_begin()
	var file_name = directory.get_next()

	while file_name != "":
		if directory.current_is_dir() and file_name != "." and file_name != "..":
			_scan_directory(path + "/" + file_name, index)
		elif not directory.current_is_dir():
			var module_name = path.get_file().get_basename()
			
			if not index.has(module_name):
				index[module_name] = {
					"description": "",
					"scenes": []
				}

			if file_name.contains("desc"):
				index[module_name]["description"] = DataIO.read_file(path + "/" + file_name).strip_edges()

			elif file_name.ends_with(".tscn"):
				var scene_data = {}
				var full_path = path + "/" + file_name
				var path_image = "res://GeneratedImages/%s.png" % id_counter
				
				scene_data["id"] = id_counter
				scene_data["path"] = full_path
				scene_data["image_path"] = path_image
				
				id_counter += 1
				index[module_name]["scenes"].append(scene_data)
		file_name = directory.get_next()
	directory.list_dir_end()

func generate_card_images() -> void:
	create_viewport()
	var data_io = DataIO.new()
	var json_data = data_io.readJSON()

	for module_name in json_data:
		for scene_data in json_data[module_name]["scenes"]:
			var scene = load(scene_data["path"]).instantiate()
			viewport.add_child(scene)
			await RenderingServer.frame_post_draw
			var image = viewport.get_texture().get_image()
			image.save_png(scene_data["image_path"])
			scene.queue_free()

	remove_viewport()
