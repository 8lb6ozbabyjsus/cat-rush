extends NodeState
#
#@export var character_body_2d : CharacterBody2D
#@export var animated_sprite_2d : AnimatedSprite2D
#
#@export_category("Run State")
#@export var run_speed : int = 100
#@export var max_run_speed : int = 150
#
#func on_process(_delta: float):
	#pass
#
#func on_physics_process(_delta: float):
	#var direction : float = GameInputEvents.movement_input()
#
	#if direction: 
		#character_body_2d.velocity.x += direction * run_speed
		#character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_run_speed, max_run_speed)
#
		#if direction != 0:
			#animated_sprite_2d.flip_h = false if direction > 0 else true
#
	#character_body_2d.move_and_slide()
#
	##state change
#
	##idle state
	#if direction == 0:
		#state_changed.emit("Idle")
#
	##jump state
	#if GameInputEvents.jump_input():
		#state_changed.emit("Jump")
#
	##attack state
	#if GameInputEvents.attack_input():
		#state_changed.emit("AttackRun")
#
	##fall state
	#if !character_body_2d.is_on_floor():
		#state_changed.emit("Fall")
#
	##sneak state
	#if GameInputEvents.sneak_input():
		#state_changed.emit("Sneak")
#
#func enter():
	#animated_sprite_2d.play("run")
#
#func exit():
	#animated_sprite_2d.stop()
	#
