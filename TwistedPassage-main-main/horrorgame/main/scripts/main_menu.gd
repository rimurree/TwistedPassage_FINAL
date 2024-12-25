extends Control

@export var bg_music : AudioStreamPlayer

func play():
	bg_music.stop()
	$press.play()
	get_tree().change_scene_to_file("res://main/maps.tscn")

func _on_button_hovered():
	$hover.play()  # Play hover sound
	
func quit():
	$press.play()
	get_tree().quit()
