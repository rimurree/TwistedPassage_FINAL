extends Node

var flashlight  # Reference to the flashlight (SpotLight3D)
#var scare_triggers = []  # List of scare triggers (areas that trigger scares)
#var cutscene_camera : Camera3D  # Reference to the cutscene camera
var max_keys = 8

#func _ready():
	#flashlight = get_node("/root/" + get_tree().current_scene.name + "/Player/head/flashlight")
	
func reset():
	Collectable.items.clear()
	max_keys = 8
	
	 ## Reset flashlight state
	#if flashlight != null:
		#flashlight.picked_up = false
		#flashlight.visible = true  # Or true, based on your desired default state
		#print("Flashlight reset: picked_up =", flashlight.picked_up, "visible =", flashlight.visible)
	#else:
		#print("not null")
	
	print("Game state reset!")
