extends RayCast3D

var int_text
var last_hit

func _ready():
	# Access the interact text node safely
	int_text = get_node_or_null("/root/" + get_tree().current_scene.name + "/Control/interact_text")
	if not int_text:
		print("Error: interact_text node not found!")
		return

func _process(_delta):
	if not int_text:
		return  # Safety check
	
	if is_colliding():
		var hit = get_collider()
		if hit:
			# Check for interact method
			if hit.has_method("interact"):
				int_text.visible = true
				if Input.is_action_just_pressed("interact"):
					hit.interact()
			else:
				int_text.visible = false
			
			# Check for scare method
			if hit.has_method("scare"):
				if last_hit != hit:
					last_hit = hit
					hit.scare()
			elif last_hit != null && last_hit.has_method("stop_scare"):
				last_hit.stop_scare()
				last_hit = null
		else:
			int_text.visible = false
	else:
		int_text.visible = false
		if last_hit != null && last_hit.has_method("stop_scare"):
			last_hit.stop_scare()
			last_hit = null
