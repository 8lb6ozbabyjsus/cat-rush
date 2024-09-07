extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int

var player : CharacterBody2D

func on_process(_delta: float):
	var direction : int

	if player.global_position.x > character_body_2d.global_position.x:
		animated_sprite_2d.flip_h = false
		direction = 1
	elif player.global_position.x < character_body_2d.global_position.x:
		animated_sprite_2d.flip_h = true
		direction = -1

	animated_sprite_2d.play("attack")
	character_body_2d.velocity.x = direction * speed * _delta
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -speed, speed)
	character_body_2d.move_and_slide()

func on_physics_process(_delta: float):
	pass

func enter():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D

func exit():
	pass
