extends Control

@export var background_music : AudioStreamPlayer # Reference to the AudioStreamPlayer

func _ready():
	background_music.play()
	# Initialize the scene (hide buttons, set active state, etc.)
	$Button.visible = false
	# Start coroutine to delay button appearance
	_delay_button_appearance()
	
func _process(delta: float) -> void:
	if self.is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func to_menu():
	$press.play()
	background_music.stop()  # Stop the background music
	# Call the reset method to clear the collected items and reset the game state
	GameManager.reset() #resets the keys collected
	get_tree().change_scene_to_file("res://main/main_screen.tscn")
	

func _on_button_hovered():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show the mouse
	$Hover.play()  # Play hover sound

func _delay_button_appearance():
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds
	# Show buttons after the timer
	$Button.visible = true
