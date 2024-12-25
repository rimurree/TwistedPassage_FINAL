extends Control
@export var bg_music : AudioStreamPlayer
func _ready():
	bg_music.play()

func level1():
	$PressSound.play()  # Play press sound
	bg_music.stop()
	get_tree().change_scene_to_file("res://map_a/scene/main_menu.tscn")
	
func level2():
	$PressSound.play()  # Play press sound
	bg_music.stop()
	get_tree().change_scene_to_file("res://map_b/Walls/TestLevel/TestLevel.tscn")
	
func _on_button_hovered():
	$HoverSound.play()  # Play hover sound
	
func _on_quit_button_pressed():
	$PressSound.play()  # Play press sound
	get_tree().quit()
