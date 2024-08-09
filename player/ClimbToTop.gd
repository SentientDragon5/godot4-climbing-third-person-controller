extends PlayerState

func enter():
	var direction = Vector3.FORWARD.rotated(Vector3.UP, player.skin.rotation.y).normalized()
	player.anim_tree.set("parameters/ClimbTop/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func process(delta):
	pass

func physics_process(delta):
	print(player.anim_tree.get("parameters/ClimbTop/active"))
	#state_machine.transition_to(parent.get_path())
