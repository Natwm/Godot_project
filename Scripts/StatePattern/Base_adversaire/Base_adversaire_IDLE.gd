extends State



func update(_delta: float) -> void:
	pass


# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	print("IDLE")
	owner.base_skelleton_ass_skin.play_idle_animation()
	owner.player_detection_area.monitorable = true
	owner.player_detection_area.monitoring = true
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	owner.player_detection_area.monitorable = false
	owner.player_detection_area.monitoring = false
	pass

