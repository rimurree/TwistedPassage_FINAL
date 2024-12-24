extends CharacterBody3D


@export var WALKING_SPEED : float = 3.0
@export var SPRINTING_SPEED : float = 5.0
@export var JUMP_VELOCITY : float = 3
@export var MOUSE_SENSITIVITY : float = 0.05
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)

@onready var head := $head

var CURRENT_SPEED
var sprint_drain_amount = 0.3
var sprint_refresh_speed = 0.4
var sprintslider 
var rng
@export var walk_footsteps: Array[AudioStream]
@export var sprint_footsteps: Array[AudioStream]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		
func _input(event):
	
	if event.is_action_pressed("exit"):
		get_tree().quit()
		
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	
	
func _ready():
	rng = RandomNumberGenerator.new()
	# Get mouse input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	CURRENT_SPEED = WALKING_SPEED
	sprintslider = get_node("/root/" + get_tree().current_scene.name + "/UI/sprintslider")

func _process(delta):
	if CURRENT_SPEED == SPRINTING_SPEED:
		sprintslider.value = sprintslider.value - sprint_drain_amount * delta
		if sprintslider.value == sprintslider.min_value:
			CURRENT_SPEED = WALKING_SPEED
				
	if CURRENT_SPEED != SPRINTING_SPEED:
		if sprintslider.value < sprintslider.max_value:
			sprintslider.value = sprintslider.value + sprint_refresh_speed * delta
		if sprintslider.value == sprintslider.max_value:
			sprintslider.visible = false
	
func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		if !$footstep_sound.playing:
				if WALKING_SPEED != SPRINTING_SPEED:
					var num = rng.randi_range(0, walk_footsteps.size() - 1)
					$footstep_sound.stream = walk_footsteps[num]
				if WALKING_SPEED == SPRINTING_SPEED:
					var num = rng.randi_range(0, sprint_footsteps.size() - 1)
					$footstep_sound.stream = sprint_footsteps[num]
				$footstep_sound.play()
		velocity.x = direction.x * CURRENT_SPEED 
		velocity.z = direction.z * CURRENT_SPEED
			
				
		if Input.is_action_just_pressed("sprint"):
			sprintslider.visible = true
			CURRENT_SPEED = SPRINTING_SPEED
				
		if Input.is_action_just_released("sprint"):
			CURRENT_SPEED = WALKING_SPEED
				
	else:
		velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)
		velocity.z = move_toward(velocity.z, 0, CURRENT_SPEED)

	move_and_slide()
