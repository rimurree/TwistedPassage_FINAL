extends Area3D

@export var scene_name: String

func enter_victory(body):
	if body.name == "game_player":
		get_tree().change_scene_to_file("res://map_a/scene/" + scene_name+ ".tscn")
