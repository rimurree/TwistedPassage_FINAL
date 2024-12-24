extends MeshInstance3D

@export var is_open = false

var anim_player
var open_sound: AudioStreamPlayer
var close_sound: AudioStreamPlayer

func _ready() -> void:
	var parent = self.get_parent()
	anim_player = parent.find_child('AnimationPlayer')
	open_sound = parent.find_child('LockerOpen') as AudioStreamPlayer
	close_sound = parent.find_child('LockerClose') as AudioStreamPlayer
	
func interact():
	if is_open:
		anim_player.play("close")  # Play close animation (affects door and handle)
		is_open = false
		close_sound.play()
	else:
		anim_player.play("open")  # Play open animation (affects door and handle)
		is_open = true
		open_sound.play()
