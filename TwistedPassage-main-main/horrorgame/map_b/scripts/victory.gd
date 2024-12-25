extends Area3D

@export var scene_name: String

func enters_trigger(body):
	if body.name == 'Player':
		get_tree().change_scene_to_file("res://map_b/Walls/scenes/victory.tscn")
