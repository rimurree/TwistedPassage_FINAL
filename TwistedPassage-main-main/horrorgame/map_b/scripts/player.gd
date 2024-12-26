extends CharacterBody3D

@onready var _initial_separation_ray_dist = abs($StepUp_F.position.z)
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
var _last_xz_vel : Vector3 = Vector3(0,0,0)
@export var walk_footsteps: Array[AudioStream]
@export var sprint_footsteps: Array[AudioStream]

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		
func _input(event):
	
	#if event.is_action_pressed("exit"):
		#get_tree().quit()
		
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	
	
func _ready():
	rng = RandomNumberGenerator.new()
	# Get mouse input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	CURRENT_SPEED = WALKING_SPEED
	sprintslider = get_node("/root/" + get_tree().current_scene.name + "/interface/sprintslider")

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
			
# go down the stairs
var _was_on_floor_last_frame = false
var _snapped_to_stairs_last_from = false
func _snap_down_to_stairs_check():
	var did_snap = false
	if not is_on_floor() and velocity.y <= 0 and (_was_on_floor_last_frame or _snapped_to_stairs_last_from) and $StairsBelowRayCast3D.is_colliding():
		var body_test_result = PhysicsTestMotionResult3D.new()
		var params = PhysicsTestMotionParameters3D.new()
		var max_step_down = -0.5
		params.from = self.global_transform
		params.motion = Vector3(0, max_step_down, 0)
		if PhysicsServer3D.body_test_motion(self.get_rid(), params, body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
			
	_was_on_floor_last_frame = is_on_floor()
	_snapped_to_stairs_last_from = did_snap
	#
func _rotate_step_up_separation_ray():
	var xz_vel = velocity * Vector3(1,0,1)
	
	if xz_vel.length() < 0.1:
		xz_vel = _last_xz_vel
	else:
		_last_xz_vel = xz_vel
		
	var xz_f_rays_pos = xz_vel.normalized() * _initial_separation_ray_dist
	var target_f_pos = self.global_position + xz_f_rays_pos
	
	$StepUp_F.global_position.x = lerp($StepUp_F.global_position.x, target_f_pos.x, 1)
	$StepUp_F.global_position.z = lerp($StepUp_F.global_position.z, target_f_pos.z, 1)
	
	var xz_l_rays_pos = xz_f_rays_pos.rotated(Vector3(0,1.0,0), deg_to_rad(-50))
	var target_l_pos = self.global_position + xz_l_rays_pos
	
	$StepUp_L.global_position.x = lerp($StepUp_L.global_position.x, target_l_pos.x, 1)
	$StepUp_L.global_position.z = lerp($StepUp_L.global_position.z, target_l_pos.z, 1)
	
	var xz_r_rays_pos = xz_f_rays_pos.rotated(Vector3(0,1.0,0), deg_to_rad(50))
	var target_r_pos = self.global_position + xz_r_rays_pos
	
	$StepUp_R.global_position.x = lerp($StepUp_R.global_position.x, target_r_pos.x, 1)
	$StepUp_R.global_position.z = lerp($StepUp_R.global_position.z, target_r_pos.z, 1)
	
	# To prevent character from running up walls, we do a check for how steep
	# the slope in contact with our separation rays is
	$StepUp_F/RayCast3D.force_raycast_update()
	$StepUp_L/RayCast3D.force_raycast_update()
	$StepUp_R/RayCast3D.force_raycast_update()
	
	var max_slope_ang_dot = Vector3(0,1,0).rotated(Vector3(1.0,0,0), self.floor_max_angle).dot(Vector3(0,1,0))
	var any_too_steep = false
	
	if $StepUp_F/RayCast3D.is_colliding() and $StepUp_F/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	if $StepUp_L/RayCast3D.is_colliding() and $StepUp_L/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	if $StepUp_R/RayCast3D.is_colliding() and $StepUp_R/RayCast3D.get_collision_normal().dot(Vector3(0,1,0)) < max_slope_ang_dot:
		any_too_steep = true
	
	$StepUp_F.disabled = any_too_steep
	$StepUp_L.disabled = any_too_steep
	$StepUp_R.disabled = any_too_steep
	
	
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
		
	_rotate_step_up_separation_ray()
	move_and_slide()
	_snap_down_to_stairs_check()
