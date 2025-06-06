extends NodeState

var banana_scene = preload("res://scenes/player/weapons/banana/banana.tscn")

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var banana_cananon : Marker2D
@export var attack_duration : float = 0.5

var banana_canannon_position : Vector2
var can_shoot : bool = true

func on_process(_delta: float):
	pass


func on_physics_process(_delta: float):
	
	banana_cananon_position()
	
	if GameInputEvents.attack_input() and can_shoot:
		shoot_banana()
		can_shoot = false
		get_tree().create_timer(attack_duration).timeout.connect(reset_shoot_cooldown)
	
	# Transitioning states
	
	
func enter():
	banana_canannon_position = Vector2(20, -2)
	banana_canannon_position = banana_cananon.position
	get_tree().create_timer(attack_duration).timeout.connect(on_attack_timeout)
	animated_sprite_2d.play("attack_sneak")
	can_shoot = true

func exit():
	animated_sprite_2d.stop()

func on_attack_timeout():
	state_changed.emit("Sneak")

func banana_cananon_position():
	if animated_sprite_2d.flip_h:
		banana_cananon.position.x = -abs(banana_canannon_position.x)
	else:
		banana_cananon.position.x = abs(banana_canannon_position.x)

func shoot_banana():
	var direction : float = -1 if animated_sprite_2d.flip_h else 1
	
	var banana_instance = banana_scene.instantiate() as Node2D
	banana_instance.direction = direction
	banana_instance.move_x_direction = true
	banana_instance.global_position = banana_cananon.global_position
	get_parent().add_child(banana_instance)

func reset_shoot_cooldown():
	can_shoot = true
