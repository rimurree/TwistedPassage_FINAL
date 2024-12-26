extends Control

@export var background_music : AudioStreamPlayer # Reference to the AudioStreamPlayer

func _ready():
	background_music.play()
	# Initialize the scene (hide buttons, set active state, etc.)
	$bck.visible = false
	$restart.visible = false
	
	# Start coroutine to delay button appearance
	_delay_button()

func _process(delta: float) -> void:
	if self.is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
# Called when the main menu button is pressed
func _on_menu_pressed():
	$Heartbeat.play()  # Play press sound
	background_music.stop()  # Stop the background music
	get_tree().change_scene_to_file("res://main/main_menu.tscn")

# Called when the restart button is pressed
func _on_pressed_restart_():
	$Heartbeat.play()  # Play press sound
	background_music.stop()  # Stop the background music
	# Call the reset method to clear the collected items and reset the game state
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock mouse again
	get_tree().change_scene_to_file("res://map_a/scene/level.tscn")
	
# Called when a button is hovered
func _on_hovered_button_():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show the mouse
	$Hover.play()  # Play hover sound
	
# Coroutine to delay button appearance
func _delay_button():
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds
	# Show buttons after the timer
	$bck.visible = true
	$restart.visible = true
