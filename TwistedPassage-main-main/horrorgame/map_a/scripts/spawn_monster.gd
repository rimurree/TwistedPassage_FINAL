extends Area3D
@export var monster: CharacterBody3D

func spawn_monster(body):
	if body == get_node("/root/" + get_tree().current_scene.name + "/game_player"):
		monster.visible = true
