extends SpotLight3D

var picked_up = false

func _process(_delta):
	if Input.is_action_just_pressed("spotlight") && picked_up == true:
		visible = !visible
		$on_off.play()
