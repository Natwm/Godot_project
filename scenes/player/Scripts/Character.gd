extends CharacterBody3D
class_name PlayerCharacter

### CONST ###
signal player_is_dead()

### CONST ###

const GRAVITY : Vector3 = 40 * Vector3.DOWN

### EXPORT VARIABLE ###
@export_range(3.0,12.0,0.1) var max_speed : float = 6
@export_range(3.0,12.0,0.1) var max_speed_dash : float = 6
@export_range(3.0,12.0,0.1) var steering_factor : float = 20
@onready var timer = $dash_Timer
@onready var label_3d = $Label3D


### On Ready ###
@onready var gobot_skin_3d = %GobotSkin3D
@onready var camera_3d = %Camera3D
@onready var hurt_box_3d :HurtBox3D= %HurtBox3D
@onready var health_manager = %Health_Manager

### VAR ###
var _world_plane := Plane(Vector3.UP)
var is_dashing : bool = false
var dash_direction : Vector3 = Vector3.ZERO

func _ready():
	hurt_box_3d.took_hit.connect(player_get_damage)
	timer.timeout.connect(func () :
			hurt_box_3d.monitorable = true
			hurt_box_3d.monitoring = true
			is_dashing = false
			dash_direction = Vector3.ZERO
			)
	health_manager.Character_is_damaged.connect(func(value): $Label3D.text = str(value) )
	health_manager.Character_is_dead.connect(death_sequence)
	$Label3D.text = str(health_manager.health)
	pass

func _physics_process(delta):
	if(gobot_skin_3d == null):
		return
		
	_world_plane.d = global_position.y
	deplacement_character(delta)
	rotation_character_with_mouse()
	move_and_slide()
	
	if(Input.is_action_just_pressed("Dash")):
		if(hurt_box_3d.monitorable) :
			hurt_box_3d.monitorable = false
			hurt_box_3d.monitoring = false
			is_dashing = true
			timer.start()
		else :
			hurt_box_3d.monitorable = true
			hurt_box_3d.monitoring = true
			is_dashing = false
			
		
	pass



func deplacement_character(delta:float)-> void :
	var input_direction  = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction : Vector3 
	if(dash_direction == Vector3.ZERO):
		direction  = Vector3(input_direction.x,0.0, input_direction.y)
	else :
		direction = dash_direction
		
	if(input_direction != Vector2.ZERO):
		var target_angle := Vector3.FORWARD.angle_to(direction)
		if(direction.x != 0.0) :
			target_angle *= -sign(direction.x)
		gobot_skin_3d.hips_rotation = target_angle - gobot_skin_3d.rotation.y
	
	var desired_ground_velocity : Vector3
	if(not is_dashing):
		desired_ground_velocity = max_speed * direction
	else :
		desired_ground_velocity = max_speed_dash * direction
		dash_direction = direction
		
	var steering_vector := desired_ground_velocity - velocity
	steering_vector.y = 0.0
	
	var steering_amount: float = min(steering_factor * delta, 1.0)
	velocity += GRAVITY * delta
	velocity += steering_vector * steering_amount
	play_animation(direction)
	pass

func rotation_character_with_mouse () -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var mouse_ray = camera_3d.project_ray_normal(mouse_position)
	var world_mouse_posisition = _world_plane.intersects_ray(camera_3d.global_position,mouse_ray)
	
	if( world_mouse_posisition != null and gobot_skin_3d != null):
		gobot_skin_3d.look_at(world_mouse_posisition)
	pass

func play_animation(direction : Vector3) -> void:
	if gobot_skin_3d == null:
		return
		
	if(is_on_floor() and not direction.is_zero_approx()):
		gobot_skin_3d.run()
		pass
	else :
		gobot_skin_3d.idle()
		pass 
	
	if (not is_on_floor()) :
		gobot_skin_3d.fall()
		pass
	pass

func player_get_damage(hit:HitBox3D):
	health_manager.take_damage()
	gobot_skin_3d.hurt()
	pass

func death_sequence():
	gobot_skin_3d.death()
	hurt_box_3d.monitorable = false
	hurt_box_3d.monitoring = false
	$GobotSkin3D/wand.queue_free()
	player_is_dead.emit()
	pass
