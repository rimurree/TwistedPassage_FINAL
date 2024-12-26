extends SpotLight3D

var picked_up = false
var flashlight_ui 
var flashlight_energy
var drain_rate = 0.01

func _ready():
	flashlight_ui = get_node("/root/" + get_tree().current_scene.name + "/Control/flashlight")
	flashlight_energy = get_node("/root/" + get_tree().current_scene.name + "/Control/flashlight/flashlight_slider")
	
func _process(delta):
	if Input.is_action_just_pressed("flashlight") && picked_up == true && flashlight_energy.value > 0:
		visible = !visible
		flashlight_ui.visible = visible
		$on_off.play()
	if visible:
		flashlight_energy.value -= drain_rate * delta
	if flashlight_energy.value == 0 && visible == true:
		visible = false
		flashlight_ui.visible = false
