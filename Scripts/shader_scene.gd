@tool
class_name ShaderScene
extends Node

@export_enum("2D","3D") var type:String:
	set(value): 
		type = value
		notify_property_list_changed()
		
@export var sprite:Sprite2D
@export var model3D:MeshInstance3D
@export var shader_params: Array[ShaderParam]
@export var scene_params: Array[SceneParam]
@export var description: String

func _validate_property(property: Dictionary) -> void:
	if property.name == "sprite" and type != "2D": 
		property.usage = PROPERTY_USAGE_NO_EDITOR
	
	if property.name == "model3D" and type != "3D": 
		property.usage = PROPERTY_USAGE_NO_EDITOR
	
