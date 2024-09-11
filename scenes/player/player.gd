extends CharacterBody2D

var banana = preload("res://scenes/player/weapons/banana/banana.tscn")
var player_death_effect = preload("res://scenes/player/player_death_effect/player_death_effect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var banana_cananon : Marker2D = $Banana_Cananon
@onready var hit_animation_player = $HitAnimationPlayer

var is_dead = false

# Constants for player movement and physics
@export var gravity : int = 1000
@export var speed : int = 150
@export var slow_down_speed : int = 2000
@export var max_h_speed : int = 150
@export var max_h_sneak_speed : int = 75
@export var sneak_speed : float = 50
@export var jump_speed : int = -325
@export var jump_h_speed : int = 165
@export var max_jump_h_speed : int = 165
@export var landing_slow_down_speed : int = 500
@export var jump_count : int = 1

# Enum for player states
enum state {idle, run, jump, sneak, drop, attack}

# Variable to keep track of current state
var current_state : state
var banana_position
var current_jump_count : int = 0

# Variables for idle animation management
var idle_counter = 0 # Track how many times idle animation played
var is_blinking = false # Flag to check if idle_blink is playing

# Variable for character sprite
var player_sprite : Sprite2D

func _ready():
	# Initialize player state to idle
	current_state = state.idle
	banana_position = banana_cananon.position

func _physics_process(delta : float):
	# Add this check at the beginning of the function
	if is_dead:
		if Input.is_action_just_pressed("jump"):
			respawn()
		return
	
	# Handle player actions and state changes
	player_falling(delta)
	player_idle(delta)
	player_sneak(delta)
	player_run(delta)
	player_jump(delta)
	player_drop(delta)
	player_attack_direction()
	player_attack(delta)
	# Move the player based on calculated velocity
	move_and_slide()

	# Handle player animations
	player_animation()
	
	# Reset state to idle if on floor and not moving
	if is_on_floor() and velocity.x == 0 and current_state != state.sneak:
		current_state = state.idle
	
	# print(str(current_state))

func player_falling(delta : float):
	# Apply gravity if player is not on the floor
	if !is_on_floor():
		velocity.y += gravity * delta
		
func player_idle(_delta : float):
	# Check if player should be idle (on the floor and not moving horizontally)
	# Prevent resetting to idle if blink animation is playing
	if is_on_floor() and velocity.x == 0 and !is_blinking:
		current_state = state.idle

func player_run(_delta : float):
	# Prevent running logic if not on the floor or sneaking
	if !is_on_floor() or current_state == state.sneak:
		return
	
	var direction = input_movement() # Call the function with ()
	
	if direction:
		# Set velocity based on input direction and speed
		velocity.x += direction * speed * _delta
		velocity.x = clamp(velocity.x, -max_h_speed, max_h_speed)
		current_state = state.run
		animated_sprite_2d.flip_h = direction < 0 # Flip sprite based on direction
	else:
		# Gradually reduce speed to zero when no input is detected
		velocity.x = move_toward(velocity.x, 0, slow_down_speed	 * _delta)

func player_sneak(_delta : float):
	# Handle sneak input and movement
	var direction = input_movement() # Call the function with ()
	
	if is_on_floor() and Input.is_action_pressed("sneak"):
		current_state = state.sneak
		if direction:
			# Move with reduced speed when sneaking
			velocity.x += direction * sneak_speed * _delta
			velocity.x = clamp(velocity.x, -max_h_sneak_speed, max_h_sneak_speed)
			animated_sprite_2d.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, sneak_speed)
	elif current_state == state.sneak:
		# Continue sneaking movement until velocity reaches zero
		velocity.x = move_toward(velocity.x, 0, sneak_speed)
		if velocity.x == 0:
			# Reset to idle when not moving
			current_state = state.idle

func player_jump(delta : float):
	var jump_pressed : bool = Input.is_action_just_pressed("jump")
	# Handle jump input and logic
	if is_on_floor() and jump_pressed:
		current_jump_count = 0
		velocity.y = jump_speed
		current_jump_count += 1
		current_state = state.jump

	if !is_on_floor() and jump_pressed and current_jump_count < jump_count:
		velocity.y = jump_speed
		current_jump_count += 1
		current_state = state.jump

	# Allow horizontal movement in mid-air when jumping
	if !is_on_floor() and current_state == state.jump:
		var direction = input_movement() 
		velocity.x += direction * jump_h_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_h_speed, max_jump_h_speed)

	# Reduce sliding after landing
	if is_on_floor() and current_state == state.jump:
		velocity.x = move_toward(velocity.x, 0, landing_slow_down_speed * delta)

func player_drop(_delta : float):
	# Handle dropping through one-way collision
	if Input.is_action_pressed("sneak") and Input.is_action_just_pressed("attack") and is_on_floor():
		# Temporarily disable collision with one-way platforms
		current_state = state.drop
		position.y += 1 # Small force to drop through the platform

func player_attack(_delta : float):
	var direction = input_movement()

	if direction != 0 and Input.is_action_just_pressed("attack"):
		var banana_instance = banana.instantiate() as Node2D
		banana_instance.direction = direction
		banana_instance.global_position = banana_cananon.global_position
		get_parent().add_child(banana_instance)
		current_state = state.attack
		animated_sprite_2d.flip_h = direction < 0

func player_attack_direction():
	var direction = input_movement()
	
	if direction > 0:
		banana_cananon.position.x = banana_position.x
	elif direction < 0:
		banana_cananon.position.x = -banana_position.x


func player_animation():
	# Control player animations based on the current state
	if current_state == state.idle:
		if is_blinking:
			# Check if idle_blink animation has finished
			if animated_sprite_2d.animation == "idle_blink" and animated_sprite_2d.frame == animated_sprite_2d.sprite_frames.get_frame_count("idle_blink") - 1:
				is_blinking = false
				idle_counter = 0 # Reset counter after blink animation
			return
		elif idle_counter >= 600:
			# Play idle_blink animation after a certain period
			animated_sprite_2d.play("idle_blink")
			is_blinking = true
		else:
			animated_sprite_2d.play("idle")
			idle_counter += 1
	elif current_state == state.run and animated_sprite_2d.animation != "swipe":
		animated_sprite_2d.play("run")
		idle_counter = 0
	elif current_state == state.jump:
		animated_sprite_2d.play("jump")
		idle_counter = 0
	elif current_state == state.sneak:
		animated_sprite_2d.play("sneak")
		idle_counter = 0
	elif current_state == state.drop:
		animated_sprite_2d.play("drop")
		idle_counter = 0
	elif current_state == state.attack:
		animated_sprite_2d.play("swipe")
		idle_counter = 0

func input_movement() -> float:
	# Function to get player input for movement
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction


func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy") and !is_dead:
		print("Hurt: ", body.damage_amount)
		hit_animation_player.play("hit")
		HealthManager.take_damage(body.damage_amount)
		if HealthManager.current_health <= 0:
			player_death()

func player_death():
	is_dead = true
	# Instantiate the death effect
	var player_death_instance = player_death_effect.instantiate() as Node2D
	player_death_instance.global_position = global_position
	get_parent().add_child(player_death_instance)
	
	# Hide the player sprite
	animated_sprite_2d.visible = false
	

func respawn():
	is_dead = false
	current_state = state.idle
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("idle")
	# Reset health
	HealthManager.heal(HealthManager.max_health)
