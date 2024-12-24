extends CharacterBody3D

var SPEED = 0 # Initially set to 0 to stop movement
var jumpscareTime = 3
@onready var player
#var m_holder = preload("res://Walls/scenes/Models/monster/monster.tscn")
#var monster_anim
#var monster
@onready var monster = $monster  # Access the child instance of `monster.tscn`
@onready var monster_anim # Access the AnimationPlayer inside the monster
var caught = false
var distance: float
var player_distance: float
@export var scene_name: String
@export var destinations: Array[Node3D]
var rng
var current_destination
var chasing = false
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var able_to_pick = false
@export var walk_footsteps: Array[AudioStream]
@export var sprint_footsteps: Array[AudioStream]
var chase_timer = 0.0
@onready var switch_node = get_node('/root/World/NavigationRegion3D/Props/Props_Switch')
var initialPosition : Vector3

func _ready():
	rng = RandomNumberGenerator.new()
	player = get_node('/root/' + get_tree().current_scene.name + '/Player')
	var random_destination = rng.randi_range(0, destinations.size() - 1)
	current_destination = destinations[random_destination]
	#monster = m_holder.instantiate()
	monster_anim = monster.get_node("AnimationPlayer")
	# Create and configure the timer
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 40.0
	Emitter.add_listener('switch_state_changed',  Callable(self, '_on_switch_state_changed')) # this is for the switch
	print(Emitter.listeners)
	timer.connect('timeout', Callable(self, '_on_wait_timer_timeout'))
	add_child(timer)
	timer.start()
	self.visible = false
	
func _on_wait_timer_timeout():
	SPEED = 2.5 # Enable movement after the timer expires
	self.visible = true
	
func _on_switch_state_changed(state: bool):
	if state:  # If the switch is ON (switch_on = true)
		self.visible = false  # Hide the monster
		global_transform.origin = initialPosition  # Move to initial position
		$NavigationAgent3D.target_position = global_transform.origin  # Stop navigation
		$NavigationAgent3D.set_velocity(Vector3.ZERO)  # Ensure no residual movement
		SPEED = 0  # Stop the monster

	else:  # If the switch is OFF (switch_on = false)
		self.visible = true  # Show the monster
		SPEED = 2.5  # Allow the monster to move again
	
func pick_new_destination():
	if chasing == false && able_to_pick == false && distance <= 1:
		able_to_pick = true
		SPEED = 0
		var wait_time = rng.randf_range(2.0, 8.0)
		await get_tree().create_timer(wait_time, false).timeout
		if distance <= 1 && chasing == false:
			print(chasing)
			var random_destination = rng.randi_range(0, destinations.size() - 1)
			print(str(random_destination))
			SPEED = 2.5
			current_destination = destinations[random_destination]
		able_to_pick = false
	
func _process(delta):
	if SPEED == 0 or not self.visible:
		$footsteps.stop()
		if monster_anim:
			monster_anim.play("Idle")  # Play idle animation when stationary
		return  # Skip processing while waiting or invisible
		
	if chasing == true && !$chase_sound.playing && !$breathing_fast.playing: # changes
		$chase_sound.play()
		$breathing_fast.play() # changes
	if chasing == false && $chase_sound.playing && !$breathing_fast.playing: # changes
		$chase_sound.stop()
		$breathing_fast.stop() # changes
	if chasing  == false && SPEED > 0:
		if !$footsteps.playing:
			var num = rng.randi_range(0, walk_footsteps.size() - 1)
			$footsteps.stream = walk_footsteps[num]
			$footsteps.play()
		distance = current_destination.global_transform.origin.distance_to(global_transform.origin)
		update_target_location(current_destination.global_transform.origin)
	if chasing == true:
		if player_distance > 15:
			if chase_timer < 5.0:
				chase_timer += 1 * delta
			else:
				chase_timer = 0.0
				chasing = false
				SPEED = 2.5
		if player_distance <=15:
			chase_timer = 0.0
		if SPEED > 0:
			if !$footsteps.playing:
				var num = rng.randi_range(0, sprint_footsteps.size() - 1)
				$footsteps.stream = sprint_footsteps[num]
				$footsteps.play()
			update_target_location(player.global_transform.origin)
	player_distance = player.global_transform.origin.distance_to(global_transform.origin)	
	
	if monster_anim and SPEED > 0:
		monster_anim.play("Walk")  # Play walk animation when moving normally
	
func _physics_process(delta):
	if initialPosition == Vector3.ZERO:
		initialPosition = global_transform.origin
		
	if SPEED == 0 or not self.visible:
		$footsteps.stop()
		return # Skip physics processing while waiting or invisible
		
	if visible:
		if not is_on_floor():
			velocity.y -= gravity  * delta 
		var current_location = global_transform.origin
		var next_location = $NavigationAgent3D.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * SPEED
		$NavigationAgent3D.set_velocity(new_velocity)
		var look_dir = atan2(-velocity.x, -velocity.z)
		rotation.y = look_dir
		if chasing == true:
			distance = player.global_transform.origin.distance_to(global_transform.origin)
			if player_distance <= 1 && caught == false:
				player.visible = false
				if !$jumpscare2.playing:
					$jumpscare2.play()
				SPEED = 0
				caught = true
				if monster_anim && caught: #changes
					monster_anim.play("Attack") 
				$jumpscare.current = true
				await get_tree().create_timer(jumpscareTime, false).timeout
				get_tree().change_scene_to_file("res://scene/" + scene_name + ".tscn")
				
func update_target_location(target_location):
	$NavigationAgent3D.target_position = target_location
	
func on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25 ) 
	move_and_slide()
	
