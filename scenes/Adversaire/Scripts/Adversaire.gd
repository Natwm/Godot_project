class_name base_Adversaire
extends dummy3D

### CONST ###
const GRAVITY : Vector3 = 40 * Vector3.DOWN

### EXPORT VARIABLE ###
@export var _state : = Enum_State.States.IDLE
@export_category("Health")
@export var base_heath : int = 20


@export_category("Statistics")
@export_range(0.0,12.0,0.1) var max_speed : float = 6
@export_range(0.0,12.0,0.1) var steering_factor : float = 20
@export_range(1.5,12.0,0.1) var attack_speed : float = 20
@export var max_distance_to_player : float = 20
@export var min_distance_to_ATTACK : float = 20

### On Ready ###
@onready var player_detection_area = $player_detection_area
@onready var state_manager : StateMachine = $StateManager
@onready var hit_box_3d = $HitBox3D
@onready var base_skelleton_ass_skin = $Base_Skelleton_ass_skin

### VARIABLE ###
var target : CharacterBody3D

func _ready():
	health_manager.health = base_heath
	hurt_box_3d.took_hit.connect(_on_hurt_box_took_hit)
	health_manager.Character_is_dead.connect(base_skelleton_ass_skin.play_death_animation)
	pass

func _process(delta):
	#if(target != null):
		#deplacement_character(delta)
		#move_and_slide()
		#pass
	pass

func _on_hurt_box_took_hit(hitbox : HitBox3D) -> void:
	base_skelleton_ass_skin.play_hit_animation()
	health_manager.take_damage()
	pass

func deplacement_character(delta:float)-> void :
	var direction : Vector3 
	direction = target.position - position
	
	var desired_ground_velocity := max_speed * direction
		
	var steering_vector := desired_ground_velocity - velocity
	steering_vector.y = 0.0
	
	var steering_amount: float = min(steering_factor * delta, 1.0)
	velocity += GRAVITY * delta
	velocity += steering_vector * steering_amount
	pass

### States Pattern ###
func change_state(new_state: int) -> void:
	var previous_state := _state
	_state = new_state

	# Initialize the new state.
	match _state:
		Enum_State.States.IDLE :
			pass
		Enum_State.States.PATROL :
			pass
		Enum_State.States.CHASING :
			pass
		Enum_State.States.ATTACK :
			pass
		Enum_State.States.DEATH :
			pass

	# Clean up the previous state.
	match previous_state:
		Enum_State.States.IDLE :
			pass
		Enum_State.States.PATROL :
			pass
		Enum_State.States.CHASING :
			pass
		Enum_State.States.ATTACK :
			pass
		Enum_State.States.DEATH :
			pass

### Signals Connexion ###
func _on_player_detection_area_area_entered(area):
	if(area.owner is PlayerCharacter):
		target = area.owner
		state_manager.transition_to("CHASING")
	pass # Replace with function body.

func _on_player_detection_area_area_exited(area):
	if(area.owner is PlayerCharacter):
		state_manager.transition_to("IDLE")
		target = null
	pass # Replace with function body.
