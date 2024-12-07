class_name ShaderParam
extends Resource
enum control_type {SLIDER,CHECKBOX}

@export var label:String
@export var control: control_type
@export var shader_var: String
@export var min_val:float = 0.0 
@export var max_val:float = 1.0 
