extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if get_tree().paused == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func resume_game():
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func back_to_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main/main_menu.tscn")

func quit():
	get_tree().quit()
