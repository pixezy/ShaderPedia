extends GridContainer

var pkdScene:PackedScene = preload("res://Scenes/card.tscn")
@export_range(0,200,1) var _spacing:int:
	set(value):
		_spacing = value
		set_spacing()

var item_width = 50

func _ready() -> void:
	var dataio:DataIO = DataIO.new()
	var json_data = dataio.readJSON()

	for module in json_data: 
		var card_instance:Card = pkdScene.instantiate()
		var images_paths:Array[String] = []		
			
		for scene in json_data[module]["scenes"]:
			images_paths.append(scene["image_path"])
	
		card_instance.module_name = module			
		card_instance.module_description = json_data[module]["description"]		
		card_instance.images_paths = images_paths
		add_child(card_instance)	

	get_tree().get_root().size_changed.connect(resize_window)
	set_item_width()
	update_columns()

func set_item_width() -> void:
	# Dummy instance just to get his width
	var temp_instance:Card = pkdScene.instantiate()
	add_child(temp_instance)
	item_width = temp_instance.size.x
	temp_instance.queue_free()	

func resize_window() -> void:
	update_columns()

func update_columns() -> void:
	var size_x:int = get_tree().get_root().size.x
	var total_item_width = item_width + _spacing
	var available_width = size_x + _spacing
	var cols:int = max(1, available_width / total_item_width)
	columns = cols

func set_spacing() -> void:
	add_theme_constant_override("h_separation", _spacing)
	add_theme_constant_override("v_separation", _spacing)
	if is_inside_tree():
		update_columns()
