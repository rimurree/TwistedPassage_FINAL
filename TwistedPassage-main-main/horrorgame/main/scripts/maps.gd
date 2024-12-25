extends Control

@export var bg_music : AudioStreamPlayer
func _ready():
	bg_music.play()

func level1():
	bg_music.stop()
	get_tree().change_scene_to_file("res://map_a/scene/main_menu.tscn")
	
func level2():
	bg_music.stop()
	get_tree().change_scene_to_file("res://map_b/Walls/TestLevel/TestLevel.tscn")
	
func go_back():
	bg_music.stop()
	get_tree().change_scene_to_file("res://main/main_menu.tscn")
