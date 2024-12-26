extends CharacterBody3D

var ORIGINAL_SPEED
var SPEED = 3.0
var sprint_drain_amount = 0.2
var sprint_refresh_speed = 0.4
var SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
var sprintslider 
var movable = false
var rng
@export var walk_footsteps: Array[AudioStream]
@export var sprint_footsteps: Array[AudioStream]

func _ready():
	rng = RandomNumberGenerator.new()
	ORIGINAL_SPEED = SPEED
	sprintslider = get_node("/root/" + get_tree().current_scene.name + "/Control/sprintslider")
	
func _process(delta):
	if movable == true:
		if SPEED == SPRINT_SPEED:
			sprintslider.value = sprintslider.value - sprint_drain_amount * delta
			if sprintslider.value == sprintslider.min_value:
				SPEED = ORIGINAL_SPEED
				
		if SPEED != SPRINT_SPEED:
			if sprintslider.value < sprintslider.max_value:
				sprintslider.value = sprintslider.value + sprint_refresh_speed * delta
			if sprintslider.value == sprintslider.max_value:
				sprintslider.visible = false
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if movable == true:
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "forward", "backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if !$footstep_sound.playing:
				if SPEED != SPRINT_SPEED:
					var num = rng.randi_range(0, walk_footsteps.size() - 1)
					$footstep_sound.stream = walk_footsteps[num]
				if SPEED == SPRINT_SPEED:
					var num = rng.randi_range(0, sprint_footsteps.size() - 1)
					$footstep_sound.stream = sprint_footsteps[num]
				$footstep_sound.play()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			
			if Input.is_action_just_pressed("sprint"):
				sprintslider.visible = true
				SPEED = SPRINT_SPEED
				
			if Input.is_action_just_released("sprint"):
				SPEED = ORIGINAL_SPEED
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
