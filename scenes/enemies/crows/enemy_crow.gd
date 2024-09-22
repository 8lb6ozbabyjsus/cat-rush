extends CharacterBody2D



@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer

@export var patrol_points : Node

@export var speed = 1500
@export var wait_time : int = 2
# @export var health_manager : Node
@export var damage_amount : int = 1
@export var health : int = 1
@onready var starting_health = health

enum state {idle, move}
var current_state = state.idle
var direction : Vector2 = Vector2.LEFT
var number_of_points : int = 0
var point_positions : Array[Vector2] = []
var current_point : Vector2
var current_point_position : int = 0
var can_move : bool = false

const gravity = 0

@onready var enemy_death_animation = preload("res://scenes/enemies/enemy_death_animation.tscn")

func _ready():
	# Initialize patrol points and positions
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else: 
		print("No Patrol Points")
		
	timer.wait_time = wait_time
	
	# Set initial state to idle and disable movement
	current_state = state.idle
	can_move = false
	
	# Correctly connect the timer's timeout signal to the function, ensuring no duplicates
	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start() # Start the timer for the initial idle state
	
func _physics_process(delta : float):
	# Apply gravity and handle enemy behavior based on the current state
	enemy_gravity(delta)
	if current_state == state.idle:
		enemy_idle(delta)
	elif current_state == state.move:
		enemy_move(delta)
		
	enemy_animation()
	
	
	# Move the enemy based on calculated velocity
	move_and_slide()
	
	#print("State:", state.keys()[current_state])

func enemy_gravity(delta : float):
	# Apply gravity if the enemy is not on the floor
	velocity.y += gravity * delta
	
func enemy_idle(delta : float):
	# Handle idle state, where enemy stops moving and waits
	if !can_move:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
	else:
		# If movement is allowed, change state to move
		current_state = state.move

func enemy_move(delta : float):
	# Handle movement state when the enemy is allowed to move
	if !can_move:
		return
	
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = state.move
	else: 
		# If the enemy reaches the current point, switch to idle
		current_point_position += 1
		if current_point_position >= number_of_points:
			current_point_position = 0
		
		current_point = point_positions[current_point_position]
		
		# Determine the direction of movement to the next point
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		# Stop movement and start the timer for idle state
		can_move = false
		current_state = state.idle
		timer.start()
	
	# Flip the sprite based on direction
	animated_sprite_2d.flip_h = direction.x < 0

func enemy_animation():
	# Control player animations based on the current state
	if current_state == state.idle and !can_move:
		animated_sprite_2d.play("idle")
	elif current_state == state.move and can_move:
		animated_sprite_2d.play("move")

func _on_timer_timeout():
	# Allow movement after the timer finishes
	can_move = true
	current_state = state.move

func _on_hurtbox_area_entered(area : Area2D):
	print("hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		health -= area.get_parent().get_damage_amount()
		print("health: ", health)
		if health <= 0:
			enemy_death()
			ScoreManager.add_enemies_killed(starting_health)

func enemy_death():
	var enemy_death_animation_instance = enemy_death_animation.instantiate() as Node2D
	enemy_death_animation_instance.global_position = global_position
	get_parent().add_child(enemy_death_animation_instance)
	queue_free()
