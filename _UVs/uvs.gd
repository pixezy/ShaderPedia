extends Node2D

@onready var sprite: Sprite2D = $Display
@onready var h_slider: HSlider = $Control/VBoxContainer/HSlider
@onready var h_slider_2: HSlider = $Control/VBoxContainer/HSlider2
@onready var check_box: CheckBox = $Control/VBoxContainer/CheckBox

func _ready() -> void:

	h_slider.value_changed.connect(x_value_changed)
	h_slider_2.value_changed.connect(y_value_changed)
	check_box.toggled.connect(_on_check_box_toggled)
	set_values()

func set_values()->void:
	sprite.material.set_shader_parameter("x_value", h_slider.value)
	sprite.material.set_shader_parameter("y_value", h_slider_2.value)
	sprite.material.set_shader_parameter("use_channels", check_box.button_pressed) 

func x_value_changed(value):
	sprite.material.set_shader_parameter("x_value", value)
	
func y_value_changed(value):
	sprite.material.set_shader_parameter("y_value", value)
	
func _on_check_box_toggled(button_pressed):
	sprite.material.set_shader_parameter("use_channels", button_pressed)
