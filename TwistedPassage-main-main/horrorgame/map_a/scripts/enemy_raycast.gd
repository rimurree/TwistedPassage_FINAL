extends RayCast3D


func _process(delta):
	if is_colliding():
		var hit = get_collider()
		if hit.has_method("enemy_interact"):
			hit.enemy_interact()
	
