extends NodeState
#
#@export var character_body_2d : CharacterBody2D
#@export var animated_sprite_2d : AnimatedSprite2D
#
#@export var slide_friction : float = 0.9  # Adjust this value to control slide speed
#@export var min_slide_speed : float = 10  # Minimum speed to continue sliding
#
#func on_process(_delta: float):
	#if not animated_sprite_2d.is_playing():
		#if abs(character_body_2d.velocity.x) < min_slide_speed:
			#state_changed.emit("Idle")
		#else:
			#state_changed.emit("Run")
#
#func on_physics_process(_delta: float):
	#var direction : float = GameInputEvents.movement_input()
	#
	## Apply sliding friction
	#character_body_2d.velocity.x *= slide_friction
	#
	## Allow player input to override sliding
	#if direction:
		#character_body_2d.velocity.x = direction * 100  # Adjust this value as needed
		#state_changed.emit("Run")
	#
	#character_body_2d.move_and_slide()
#
#func enter():
	#animated_sprite_2d.play("land")
#
#func exit():
	#animated_sprite_2d.stop()
