extends PlayerState

@export var move_speed: float = 10
@export var acceleration: float = 50
@export var cam_follow_speed: float = 8
@export var raycastLength: float = 0.5

func physics_process(delta):
	# call physics_process method of the the super class (State) which in turn calls the physics_process
	# method of the parent state (the super class is not the same as the parent state)
	super.physics_process(delta)
	
	if player.is_on_wall():
		var avg_norm = player.wall_normal()
		var right : Vector3 = avg_norm.cross(Vector3.UP).normalized()
		var up : Vector3 = avg_norm.cross(right).normalized()
		var input = player.controls._move_vec
		var motion : Vector3 = up * input.y - right * input.x;
		motion *= move_speed
		motion -= avg_norm * 0.01
		player.horizontal_velocity = motion
		player.y_velocity = motion.y
		
		#player.skin.rotation = 
	else:
		# if not, they're most likely falling of a ledge, so transition into the InAir/Falling state
		state_machine.transition_to("InAir/Falling")
