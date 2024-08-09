extends PlayerState

@export var anim_transition_speed : float = 0.1
var anim_dir : Vector2 = Vector2.ZERO

func enter():
	# set the current animation root state to climbing
	player.anim_tree.set("parameters/RootState/transition_request", "climbing")

func process(delta):
	# handle transitions
	if !player.is_on_wall():
		state_machine.transition_to("InAir/Falling")
	elif player.controls.is_jumping():
		state_machine.transition_to("InAir/Jumping")
	elif player.has_movement() && player.controls.is_sprinting():
		state_machine.transition_to("Climbing/WallRun")
	elif player.has_movement():
		state_machine.transition_to("Climbing/WallClimb")
	else:
		state_machine.transition_to("Climbing/Stopped")

func physics_process(delta):
	# for 2d blendspaces pass a Vector2
	#if player.on_wall && player.by_wall_top:
	#	state_machine.transition_to("Climbing/ClimbToTop")
	if player.controls.is_sprinting() && player.has_movement():
		player.anim_tree.set("parameters/RootState/transition_request", "on-ground")
		player.anim_tree.set("parameters/OnGround/blend_position",  1.4) # sprinting anim
	else:
		player.anim_tree.set("parameters/RootState/transition_request", "climbing")
		anim_dir = lerp(anim_dir, player.controls._move_vec, anim_transition_speed * delta)
		player.anim_tree.set("parameters/Climbing/blend_position",  anim_dir)

func exit():
	# return the skin to facing directly up
	player.skin.transform.basis = Basis.from_euler(Vector3(0,player.skin.transform.basis.get_euler().y,0))
