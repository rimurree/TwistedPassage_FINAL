extends MeshInstance3D

@export var is_complete_keys = false
@export var is_open = false
@onready var lock_text 
@onready var bg
@onready var int_text = get_node('/root/World/UI/interact_text')
var anim_player
var lock_sound: AudioStreamPlayer3D
var open_sound: AudioStreamPlayer3D


func _ready():
	anim_player = self.get_parent().find_child('AnimationPlayer')
	lock_text = get_tree().current_scene.get_node("locked/lock")
	lock_sound = get_parent().find_child('lock') as AudioStreamPlayer3D
	open_sound = get_parent().find_child('open') as AudioStreamPlayer3D
	bg = get_tree().current_scene.get_node("locked/bg")
	# Debugging: Check if nodes are found
	Emitter.add_listener('complete_keys', Callable(self, 'complete_keys'))
	Emitter.add_listener('not_interacting', Callable(self, 'not_interacting'))
	lock_text.visible = false  
	#bg.visible = false  

func not_interacting(v):
	lock_text.visible = false
	bg.visible = false
		
func complete_keys():
	is_complete_keys = true

func interact(): 
	display_text()
	
func display_text():
	if Input.is_action_just_pressed("interact"):
		if is_complete_keys:
			open_sound.play()
			anim_player.play("open")
			is_open = true
		else:
			lock_sound.play()
			lock_text.visible = true
			bg.visible = true
			int_text.visible = false
