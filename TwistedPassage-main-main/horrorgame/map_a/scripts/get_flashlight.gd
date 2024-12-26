extends StaticBody3D

var torch

func _ready():
	torch = get_node("/root/" + get_tree().current_scene.name + "/game_player/head/torch")
	
func interact():
	get_node("/root/" + get_tree().current_scene.name + "/sounds/object_pickup").play()
	torch.picked_up = true
	queue_free()
