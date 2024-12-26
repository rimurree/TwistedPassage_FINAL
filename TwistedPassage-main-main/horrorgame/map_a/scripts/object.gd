extends StaticBody3D

var object_counter

func _ready():
	object_counter = get_tree().current_scene.get_node("Control/object_counter")

func interact():
	get_parent().num_of_objects += 1
	get_tree().current_scene.get_node("sounds/pickup_obj").play()
	object_counter.text = str(get_parent().num_of_objects) + "/8"
	if get_parent().num_of_objects >= 8:
		get_tree().current_scene.get_node("door/AnimationPlayer").play("open")
	queue_free()
