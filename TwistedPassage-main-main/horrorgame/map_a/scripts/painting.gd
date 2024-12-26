extends StaticBody3D

@export var painting_mat: StandardMaterial3D
@export var scary_painting: StandardMaterial3D
@export var stare_time : float
@export var scare_time : float
@export var only_once: bool
var looking = false
var done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance3D2.material_override = painting_mat
	
func scare():
	if looking == false && done == false:
		looking = true
		if only_once == true: 
			done = true
		await get_tree().create_timer(stare_time, false).timeout
		if looking == true:
			$jumpscare.play()
			$MeshInstance3D2.material_override = scary_painting
			await get_tree().create_timer(scare_time, false).timeout
			$jumpscare.stop()
			$MeshInstance3D2.material_override = painting_mat
		
func stop_scare():
	looking == false
