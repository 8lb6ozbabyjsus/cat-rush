extends NodeState
#
#var banana_scene = preload("res://scenes/player/weapons/banana/banana.tscn")
#
#@export var character_body_2d : CharacterBody2D
#@export var animated_sprite_2d : AnimatedSprite2D
#@export var banana_cananon : Marker2D
#@export var attack_duration : float = 0.5
#
#var wall_cling_direction : Vector2
#var banana_canannon_position : Vector2
#var last_wall_jump_direction : Vector2 = Vector2.ZERO
#
#func on_process(_delta: float):
	#pass
#
#func on_physics_process(_delta: float):
	#character_body_2d.velocity.y = 0
	#
	#var direction : float = GameInputEvents.movement_input()
#
	#if direction > 0 and wall_cling_direction == Vector2.ZERO:
		#animated_sprite_2d.flip_h = false
		#wall_cling_direction = Vector2.RIGHT
#
	#if direction < 0 and wall_cling_direction == Vector2.ZERO:
		#animated_sprite_2d.flip_h = true
		#wall_cling_direction = Vector2.LEFT
#
	#banana_cananon_position()
	#
	#if GameInputEvents.attack_input():
		#shoot_banana()
	#
	#character_body_2d.move_and_slide()
#
	## Transitioning states
#
	## Jump state
	#if GameInputEvents.jump_input():
		#last_wall_jump_direction = -wall_cling_direction
		#state_changed.emit("Jump")
	#
	## Fall state
	#if GameInputEvents.force_fall_input():
		#state_changed.emit("Fall")
#
#func enter():
	#banana_canannon_position = Vector2(12, -12)
	#banana_canannon_position = banana_cananon.position
		#
	## Set initial wall_cling_direction based on which wall we're on
	#wall_cling_direction = Vector2.RIGHT if character_body_2d.get_wall_normal().x < 0 else Vector2.LEFT
	#animated_sprite_2d.flip_h = wall_cling_direction == Vector2.LEFT
	#
	#animated_sprite_2d.play("cling")
#
#
#func exit():
	#wall_cling_direction = Vector2.ZERO
	#animated_sprite_2d.stop()
#
#func on_attack_timeout():
	#state_changed.emit("AttackWall")
#
#func banana_cananon_position():
	#if animated_sprite_2d.flip_h:
		#banana_cananon.position.x = abs(banana_canannon_position.x)
	#else:
		#banana_cananon.position.x = -abs(banana_canannon_position.x)
#
#func shoot_banana():
	#var direction : float = -1 if wall_cling_direction == Vector2.RIGHT else 1
	#
	#var banana_instance = banana_scene.instantiate() as Node2D
	#banana_instance.direction = direction
	#banana_instance.move_x_direction = true
	#banana_instance.global_position = banana_cananon.global_position
	#get_parent().add_child(banana_instance)
