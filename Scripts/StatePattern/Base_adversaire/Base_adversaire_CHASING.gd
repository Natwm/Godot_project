extends State

func update(_delta: float) -> void:
	var direction : Vector3 
	direction = owner.target.position - owner.position
	
	#if(owner.position.distance_to(owner.target.position) < owner.min_distance_to_ATTACK):
		#owner.state_manager.transition_to("ATTACK")
		#return
#
	#if(owner.position.distance_to(owner.target.position) > owner.max_distance_to_player):
		#owner.state_manager.transition_to("IDLE")
		#return
		#pass
	#
	#var desired_ground_velocity :Vector3 = owner.max_speed * direction
		#
	#var steering_vector :Vector3 = desired_ground_velocity - owner.velocity
	#steering_vector.y = 0.0
	#
	#var steering_amount: float = min(owner.steering_factor * _delta, 1.0)
	#owner.velocity += owner.GRAVITY * _delta
	#owner.velocity += steering_vector * steering_amount
	#owner.move_and_slide()
	
	owner.base_skelleton_ass_skin.look_at(owner.target.position)
	pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	print("Chasing")
	owner.base_skelleton_ass_skin.play_run_animation()
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	pass

