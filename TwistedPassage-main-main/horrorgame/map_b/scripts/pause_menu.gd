extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if get_tree().paused == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func resume():
	get_tree().paused = false
	$PressSound.play()
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func back_to_menu():
	get_tree().paused = false
	$PressSound.play()
	get_tree().change_scene_to_file("res://main/main_menu.tscn")
	
func _on_button_hovered():
	$HoverSound.play()  # Play hover sound

func quit_game():
	$PressSound.play()
	get_tree().quit()
