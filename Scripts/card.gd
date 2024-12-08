class_name Card
extends NinePatchRect
var module_name:String
var module_description:String
var images_paths:Array[String]

@onready var title: Label = $Title
@onready var description: Label = $Description
@onready var display: ColorRect = %Display
@onready var button: Button = $Button

var index:int = 0
var shader_material: ShaderMaterial
var tween: Tween

func _ready() -> void:
	#This can be a dummy card, just for set the dimensions of the grid
	if images_paths.size() == 0: 
		return
	title.text = module_name	
	description.text = module_description

	shader_material = ShaderMaterial.new()
	shader_material.shader = load("res://Shaders/_Main/transition.gdshader")
	display.material = shader_material

	_load_textures()
	_start_transition()
	button.pressed.connect(load_viewer)

func _load_textures() -> void:
	var texture_a = _load_texture(images_paths[index])
	var texture_b = _load_texture(images_paths[(index + 1) % images_paths.size()])
	shader_material.set_shader_parameter("tex_a", texture_a)
	shader_material.set_shader_parameter("tex_b", texture_b)

func _load_texture(path: String)->ImageTexture:
	var _texture := load(path)
	return _texture

func load_viewer() -> void:
	var window = get_tree().get_root()
	window.get_child(0).queue_free()
	var viewer = load("res://Scenes/viewer.tscn").instantiate()
	viewer.module_name = module_name
	window.add_child(viewer)
	
	
func _start_transition() -> void:	
	shader_material.set_shader_parameter("value", 0.0)
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(shader_material,"shader_parameter/value",1.0,2.5)
	tween.finished.connect(_on_transition_complete)

func _on_transition_complete() -> void:
	index = (index + 1) % images_paths.size()
	_load_textures()
	_start_transition()
