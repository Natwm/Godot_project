extends Node3D

## Controls how much the dummy material's emission is blended with the original material. It turns the model red.
var _tween_damage: Tween = null

@onready var animation_player = %AnimationPlayer
@export var animation_damage : String
@export var animation_duration: float = 0.15

func _ready():
	animation_player.play("Idle_B")


func play_hit_animation() -> void:
	if _tween_damage != null:
		_tween_damage.kill()
	
	#_tween_damage = create_tween()
	play_damage_animation()
	pass


func play_damage_animation():
	var tween = create_tween()
	var rotate = randi_range(0,1)
	if(rotate == 0):
		tween.tween_property(self,"rotation:y",rotation.y + -0.5,0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE).from_current()
		tween.tween_property(self,"rotation:y",rotation.y + 0.3,0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).from_current()
		tween.tween_property(self,"rotation:y",0,0.15)
	else :
		tween.tween_property(self,"rotation:y",rotation.y + 0.5,0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE).from_current()
		tween.tween_property(self,"rotation:y",rotation.y + -0.3,0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).from_current()
		tween.tween_property(self,"rotation:y",0,0.15)
	pass

func _return_to_initial_rotation():
	var tween = create_tween()
	tween.tween_property(self, "rotation:y", rotation.y + 0.5, animation_duration).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func play_death_animation() -> void:
	animation_player.play("Death_A")
	await (animation_player.animation_finished)
	owner.queue_free()
	pass


func play_run_animation () -> void:
	animation_player.play("Running_A")
	pass

func play_idle_animation () -> void:
	animation_player.play("Idle")
	pass
