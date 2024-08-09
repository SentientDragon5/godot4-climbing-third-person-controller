extends PlayerState

@export var move_speed: float = 5
@export var acceleration: float = 50
@export var normal_smoothing_speed: float = 2.5

var avg_norm: Vector3 = Vector3.ZERO

func enter():
	avg_norm = player.wall_normal()

func physics_process(delta):
	super.physics_process(delta)
	
	if player.is_on_floor():
		if player.controls._move_vec.y > 0.5:
			state_machine.transition_to("OnGround")
	if player.is_on_wall():
		avg_norm = lerp(avg_norm, player.wall_normal(), normal_smoothing_speed * delta)
		var right : Vector3 = avg_norm.cross(Vector3.UP).normalized()
		var up : Vector3 = avg_norm.cross(right).normalized()
		var input = player.controls._move_vec
		var motion : Vector3 = up * input.y - right * input.x;
		motion *= move_speed
		motion -= avg_norm * 0.01 # wall cling
		player.horizontal_velocity = motion
		player.y_velocity = motion.y
		
		player.skin.transform.basis = Basis.looking_at(-avg_norm, Vector3.UP)
	elif player.is_on_floor():
		state_machine.transition_to("OnGround")
	else:
		# if not, they're most likely falling of a ledge, so transition into the InAir/Falling state
		state_machine.transition_to("InAir/Falling")

