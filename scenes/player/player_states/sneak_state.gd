extends NodeState
#
#@export var character_body_2d : CharacterBody2D
#@export var animated_sprite_2d : AnimatedSprite2D
#
#@export_category("Sneak State")
#@export var run_speed : int = 50
#@export var max_run_speed : int = 75
#
#func on_process(_delta: float):
	#pass
#
#func on_physics_process(_delta: float):
	#var direction : float = GameInputEvents.movement_input()
	#var sneak : bool = GameInputEvents.sneak_input()
#
	#if direction and sneak: 
		#character_body_2d.velocity.x += direction * run_speed
		#character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_run_speed, max_run_speed)
		#animated_sprite_2d.play("sneak")
#
		#if direction != 0 and sneak:
			#animated_sprite_2d.flip_h = false if direction > 0 else true
#
	#character_body_2d.move_and_slide()
#
	##state change
#
	##idle state
	#if direction == 0 and !sneak:
		#state_changed.emit("Idle")
#
	##jump state
	#if GameInputEvents.jump_input():
		#state_changed.emit("Jump")
#
	##attack state
	#if GameInputEvents.attack_input() and sneak:
		#state_changed.emit("AttackSneak")
	#
	##run state
	#if GameInputEvents.movement_input() and !sneak:
		#state_changed.emit("Run")
	#
	#if direction == 0:
		#character_body_2d.velocity.x = 0
#
#func enter():
	#animated_sprite_2d.play("sneak")
	#animated_sprite_2d.stop()
#
#func exit():
	#animated_sprite_2d.stop()
	#
