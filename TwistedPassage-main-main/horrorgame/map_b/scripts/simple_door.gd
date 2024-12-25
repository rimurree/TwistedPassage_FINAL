extends Node3D

var sound_on 
var sound_off 
var is_door_open = false 
var anim_player

func _ready():
	anim_player = find_child("AnimationPlayer")
	sound_on = find_child('open')
	sound_off = find_child('close')
	

func interact():
	if is_door_open:
		anim_player.play("close")
		sound_off.play()
		is_door_open = false
		
	else:
		anim_player.play("open")
		sound_on.play()
		is_door_open = true
		
	
