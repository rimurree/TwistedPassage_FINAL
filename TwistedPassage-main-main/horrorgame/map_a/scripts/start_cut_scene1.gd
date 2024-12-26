extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$cutscene_AnimationPlayer.play("start_cutscene")
	$Camera3D.current = true
	await get_tree().create_timer(7.0, false).timeout
	get_node("/root/" + get_tree().current_scene.name + "/game_player").movable = true
	get_node("/root/" + get_tree().current_scene.name + "/game_player/head/Camera3D").current = true
	get_node("/root/" + get_tree().current_scene.name + "/game_player/head").movable = true

	$Camera3D.current = false
	queue_free()
