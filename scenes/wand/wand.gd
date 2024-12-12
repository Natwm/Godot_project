extends Marker3D

### On Ready ###
@onready var timer = %DisableTimer
@onready var fire_rate_timer = %FireRate_Timer


### EXPORT ###
@export var projectile_scene: PackedScene = null
@export_range(0.1,200,0.5) var fire_rate := 0.2

func _ready():
	set_fire_rate(fire_rate)
	timer.timeout.connect(func():
		$Projectile3D._destroy()
		)
	pass

func _process(delta):
	if(Input.is_action_just_pressed("shoot") and timer.is_stopped() and fire_rate_timer.is_stopped()):
		shoot()

	pass

func shoot():
	#var projectile := projectile_scene.instantiate()
	#owner.add_sibling(projectile)
	#projectile.global_transform = global_transform
	timer.start()
	fire_rate_timer.start()
	$Projectile3D.cast()
	pass

func set_fire_rate(new_fire_rate: float) -> void:
	fire_rate = clamp(new_fire_rate, 0.1, 20.0)
	if timer == null:
		return
	timer.wait_time = 1.0 / fire_rate
	pass
