extends Control

@export var background_music : AudioStreamPlayer # Reference to the AudioStreamPlayer
func _ready():
	background_music.play()
	
	# Initialize the scene (hide buttons, set active state, etc.)
	$menu.visible = false
	$restart.visible = false
	
	# Start coroutine to delay button appearance
	_delay_button_appearance()

	# Connect signals for the buttons
	#$menu.connect("pressed", Callable(self, "_on_main_menu_pressed"))
	#$menu.connect("mouse_entered", Callable(self, "_on_button_hovered"))
	#$restart.connect("pressed", Callable(self, "_on_restart_pressed"))
	#$restart.connect("mouse_entered", Callable(self, "_on_button_hovered"))

func _process(delta: float) -> void:
	if self.is_visible():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
# Called when the main menu button is pressed
func _on_main_menu_pressed():
	$PressSound.play()  # Play press sound
	background_music.stop()  # Stop the background music
	GameManager.reset() #resets the keys collected
	get_tree().change_scene_to_file("res://main/main_menu.tscn")

# Called when the restart button is pressed
func _on_restart_pressed():
	$PressSound.play()  # Play press sound
	background_music.stop()  # Stop the background music
	# Call the reset method to clear the collected items and reset the game state
	GameManager.reset() #resets the keys collected
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Lock mouse again
	get_tree().change_scene_to_file("res://map_b/Walls/TestLevel/TestLevel.tscn")
	
# Called when a button is hovered
func _on_button_hovered():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show the mouse
	$HoverSound.play()  # Play hover sound
	
# Coroutine to delay button appearance
func _delay_button_appearance():
	await get_tree().create_timer(2.0).timeout  # Wait for 2 seconds
	# Show buttons after the timer
	$menu.visible = true
	$restart.visible = true
