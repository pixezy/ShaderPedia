extends ScrollContainer

var is_panning := false
var last_mouse_position := Vector2()
var pan_velocity := Vector2()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_panning = true
				last_mouse_position = event.position
				pan_velocity = Vector2() 
			else:
				is_panning = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			pan_velocity = Vector2()
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:				
				pass
			else:
				pass
				
	elif event is InputEventMouseMotion and is_panning:
		var delta = event.position - last_mouse_position
		pan_velocity = delta  # Set velocity based on current drag movement
		scroll_horizontal -= delta.x
		scroll_vertical -= delta.y
		last_mouse_position = event.position

func _process(delta):
	if not is_panning:

		# pan_velocity = pan_velocity.lerp(Vector2(), 0.01)
		pan_velocity = pan_velocity + (Vector2() - pan_velocity) * delta * delta * 300
		
		# Update scroll position in both directions based on pan_velocity
		scroll_horizontal -= int(pan_velocity.x * 2.0)
		scroll_vertical -= int(pan_velocity.y * 2.0)

		# Stop the movement if velocity is close to zero
		if pan_velocity.length() < 0.1:
			pan_velocity = Vector2()
