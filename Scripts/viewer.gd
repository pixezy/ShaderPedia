class_name Viewer
extends Control

@onready var left: Button = $Left
@onready var right: Button = $Right
@onready var loader: Panel = $Loader
@onready var box_controls: VBoxContainer = %BoxControls
@onready var home: Button = $Home
@onready var code: Button = %Code
@onready var innerWindow: Window = %Window
@onready var text_edit: TextEdit = %TextEdit

var module_name: String = "001_Step"

var index: int = 0
var json_data: Variant
var current_scene: Node
var shader_scene: ShaderScene
var shader_params: Array[ShaderParam]
var scene_params: Array[SceneParam]

func _ready() -> void:
	json_data = DataIO.new().readJSON()
	_load_scene()
	left.pressed.connect(_on_left_pressed)
	right.pressed.connect(_on_right_pressed)
	home.pressed.connect(_on_home_pressed)
	code.pressed.connect(_on_code_pressed)
	innerWindow.close_requested.connect(_on_closewindow_pressed)
	

func _load_scene() -> void:
	# Clear current scene
	if is_instance_valid(current_scene):
		loader.remove_child(current_scene)
		current_scene.queue_free()

	# Load new scene
	var scene_path = json_data[module_name]["scenes"][index]["path"]
	current_scene = load(scene_path).instantiate()
	loader.add_child(current_scene)

	# Setup ShaderScene
	shader_scene = current_scene.get_node("ShaderScene")
	_load_code_TextEdit()
	if shader_scene:
		shader_params = shader_scene.shader_params
		scene_params = shader_scene.scene_params
		_load_controls()
	else:
		shader_params = []
		scene_params = []
		push_warning("ShaderScene not found in: " + scene_path)

func _load_controls() -> void:
	# Remove previous controls
	for child in box_controls.get_children():
		box_controls.remove_child(child)
		child.queue_free()

	# Create controls for shader_params and scene_params
	for shader_param in shader_params:
		var control = _create_shader_control(shader_param)
		var label = _create_label(shader_param)
		box_controls.add_child(label)
		box_controls.add_child(control)

	for scene_param in scene_params:
		var control = _create_scene_control(scene_param)	
		box_controls.add_child(control)

func _create_label(param: ShaderParam) -> Label:
	var label = Label.new()
	label.add_theme_color_override("font_color", Color.BLACK)
	label.text = param.label
	return label

func _create_shader_control(param: ShaderParam) -> Control:
	var control:Control
	match param.control:
		ShaderParam.control_type.SLIDER:
			control = HSlider.new()
			control.min_value = 0.0
			control.max_value = 1.0
			control.step = 0.01
			control.value = get_shader_param(param)
			control.value_changed.connect(set_shader_param.bind(param))
			# set_shader_param(control.value, param)
		ShaderParam.control_type.CHECKBOX:
			control = CheckBox.new()
			control.button_pressed = get_shader_param(param)
			control.toggled.connect(set_shader_param.bind(param))	
			# set_shader_param(control.button_pressed, param)
	return control

func _create_scene_control(param: SceneParam) -> Control:
	match param.control:
		SceneParam.control_type.SLIDER:
			return HSlider.new()
		SceneParam.control_type.CHECKBOX:
			return CheckBox.new()
	return null

func get_shader_param(param: ShaderParam) -> float:
	if shader_scene.type == "2D":	
		if shader_scene.sprite:
			return shader_scene.sprite.material.get_shader_parameter(param.shader_var)
	elif shader_scene.type == "3D":	
		return shader_scene.model3D.material_override.get_shader_parameter(param.shader_var)	
	return 0

func set_shader_param(value,param: ShaderParam) -> void:
	if shader_scene.type == "2D":
		if shader_scene.sprite:
			shader_scene.sprite.material.set_shader_parameter(param.shader_var, value)
	elif shader_scene.type == "3D":
		shader_scene.model3D.material_override.set_shader_parameter(param.shader_var, value)

func _on_home_pressed() -> void: 
	var window = get_tree().get_root()	
	window.get_child(0).queue_free()
	var main = load("res://Scenes/main.tscn").instantiate()
	window.add_child(main)

func _on_code_pressed() -> void: 
	innerWindow.visible = true
	

func _on_left_pressed() -> void:
	index = (index - 1) % json_data[module_name]["scenes"].size()
	_load_scene()

func _on_right_pressed() -> void:
	index = (index + 1) % json_data[module_name]["scenes"].size()
	_load_scene()

func _on_closewindow_pressed() -> void:
	innerWindow.visible = false

func _load_code_TextEdit() -> void:
	var shader_code: String
	if shader_scene.type == "2D":
		if shader_scene.sprite:
			shader_code = shader_scene.sprite.material.shader.code
	elif shader_scene.type == "3D":
		shader_code = shader_scene.model3D.material_override.shader.code
	text_edit.text = shader_code
	
