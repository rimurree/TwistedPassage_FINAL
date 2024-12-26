extends RayCast3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding():
		var hit  = get_collider()
		if hit.name == "game_player" && !get_parent().chasing:
			get_parent().chasing = true
			get_parent().SPEED = 5.5
			
			 
 
