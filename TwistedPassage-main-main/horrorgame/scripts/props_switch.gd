extends MeshInstance3D

@export var switch_on = false

var anim_player: AnimationPlayer
var world: WorldEnvironment
var switch_sound: AudioStreamPlayer
var timer_active = false  # Ensures the timer won't trigger multiple times

func _ready() -> void:
	anim_player = self.get_parent().find_child('AnimationPlayer')
	world = get_node('/root/World/WorldEnvironment') as WorldEnvironment
	switch_sound = self.get_parent().find_child('LightSwitch')


func interact() -> void:
	if not switch_on:
		# Turn the lights ON
		switch_on = true
		anim_player.play('on')
		world.get_environment().background_mode = Environment.BGMode.BG_SKY
		switch_sound.play()
		
		# Notify listeners about the state change
		Emitter.emit("switch_state_changed", switch_on)
		
		# Start a timer to turn off the lights after 10 seconds
		if not timer_active:  # Prevent multiple timers from stacking
			timer_active = true
			await get_tree().create_timer(10.0).timeout
			_turn_off_light()
	else:
		# Turn the lights OFF manually
		_turn_off_light()
		
	Emitter.emit("switch_state_changed", switch_on)


func _turn_off_light() -> void:
	switch_on = false
	timer_active = false
	anim_player.play('off')
	world.get_environment().background_mode = Environment.BGMode.BG_COLOR
	world.get_environment().background_color = 0x000000
	switch_sound.play()
