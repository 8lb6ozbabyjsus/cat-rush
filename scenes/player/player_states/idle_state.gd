extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Physics Friction")
@export var slow_down_speed : int = 1100

var idle_timer : float = 0
var is_special_idle : bool = false

func on_process(delta: float):
	if is_special_idle:
		if not animated_sprite_2d.is_playing():
			animated_sprite_2d.play("idle")
			is_special_idle = false
			idle_timer = 0
	else:
		idle_timer += delta
		if idle_timer >= 10:
			idle_timer = 0
			is_special_idle = true
			if randf() < 0.5:
				animated_sprite_2d.play("idle_sit")
			else:
				animated_sprite_2d.play("idle_blink")

func on_physics_process(delta: float):
	character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, slow_down_speed * delta)

	character_body_2d.move_and_slide()


	#state change #
 
	#fall state
	if !character_body_2d.is_on_floor():
		state_changed.emit("Fall")

	#run state
	var direction : float = GameInputEvents.movement_input()

	if character_body_2d.is_on_floor() and direction:
		state_changed.emit("Run")

	# jump state
	if GameInputEvents.jump_input():
		state_changed.emit("Jump")

	#attack stand state
	if GameInputEvents.attack_input():
		state_changed.emit("AttackStand")
	
	#attack up state
	if GameInputEvents.attack_up_input():
		state_changed.emit("AttackUp")

	#sneak state
	if GameInputEvents.sneak_input():
		state_changed.emit("Sneak")

	#attack sneak state
	if GameInputEvents.sneak_attack_input():
		state_changed.emit("AttackSneak")
	
	# #attack run state
	# if GameInputEvents.attack_input():
	#     state_changed.emit("AttackRun")

func enter():
	animated_sprite_2d.play("idle")
	idle_timer = 0
	is_special_idle = false
	get_parent().get_node("Jump").current_jump_count = 0  # Reset jump count

func exit():
	animated_sprite_2d.stop()
	idle_timer = 0
	is_special_idle = false
