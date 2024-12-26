extends StaticBody3D

@export var light: Node3D
@export var light_off: StandardMaterial3D
@export var light_on: StandardMaterial3D
@export var toggle = false
var interactable = true

func interact():
	if interactable:
		interactable = false
		$press.play()
		$AnimationPlayer.play("press")
		toggle = !toggle
		if toggle == false:
			light.get_node("MeshInstance3D").material_override == light_off
		if toggle == true:
			light.get_node("MeshInstance3D").material_override == light_on
		light.get_node("OmniLight3D").visible = toggle
		await get_tree().create_timer(0.5, false).timeout
		interactable= true
