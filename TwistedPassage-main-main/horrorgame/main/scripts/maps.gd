extends Control

@export var bg_music : AudioStreamPlayer
func _ready():
	bg_music.play()

func level1():
	$press.play()
	bg_music.stop()
	get_tree().change_scene_to_file("res://map_a/scene/level.tscn")
	
func level2():
	$press.play()
	bg_music.stop()
	get_tree().change_scene_to_file("res://map_b/Walls/TestLevel/TestLevel.tscn")
	
func go_back():
	$press.play()
	bg_music.stop()
	get_tree().change_scene_to_file("res://main/main_menu.tscn")

func _on_button_hovered():
	$Hover.play()  # Play hover sound
