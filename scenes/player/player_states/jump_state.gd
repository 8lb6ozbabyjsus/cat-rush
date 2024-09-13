extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Jump Settings")
@export var jump_speed : int = -300
@export var jump_horizontal_velocity : int = 125
@export var max_jump_horizontal_velocity : int = 150
@export var max_jump_count : int = 1
@export var landing_slow_down_speed : int = 10000
@export var jump_gravity : int = 800

var current_jump_count : int = 0

# currently not used
func on_process(_delta: float):
	pass

# Handles the physics calculations for the jump state
func on_physics_process(delta: float):
	# Apply gravity to the character
	character_body_2d.velocity.y += jump_gravity * delta

	# Allow horizontal movement in mid-air
	var direction : float = GameInputEvents.movement_input()
	character_body_2d.velocity.x += direction * jump_horizontal_velocity * delta
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_jump_horizontal_velocity, max_jump_horizontal_velocity)

	# Move the character based on the calculated velocity
	character_body_2d.move_and_slide()

	# Handle additional jumps (double jump)
	if GameInputEvents.jump_input() and current_jump_count < max_jump_count:
		character_body_2d.velocity.y = jump_speed
		current_jump_count += 1

	# Check for state changes
	if character_body_2d.is_on_floor():
		# Slow down horizontal movement when landing
		if abs(character_body_2d.velocity.x) > 0.3:
			character_body_2d.velocity.x = move_toward(character_body_2d.velocity.x, 0, landing_slow_down_speed * delta)
		# Change to Land state
		state_changed.emit("Land")
		character_body_2d.velocity.x = 0
	elif character_body_2d.velocity.y > 0:
			# Change to Fall state if moving downwards
			state_changed.emit("Fall")

# Called when entering the Jump state
func enter():
	# Play the jump animation
	animated_sprite_2d.play("jump")
	
	# Set up initial jump parameters
	if character_body_2d.is_on_floor():
		current_jump_count = 1
		character_body_2d.velocity.y = jump_speed
	else:
		current_jump_count = max_jump_count - 1
	
	# Check for double jump powerup
	if InventoryManager.has_item("double_jump"):
		max_jump_count = 2
	else:
		max_jump_count = 1

# Called when exiting the Jump state
func exit():
	# Stop the jump animation
	animated_sprite_2d.stop()
