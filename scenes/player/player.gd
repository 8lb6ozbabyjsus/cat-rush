extends CharacterBody2D

#SCENES
var banana_scene = preload("res://scenes/player/weapons/banana/banana.tscn")
var player_death_effect = preload("res://scenes/player/player_death_effect/player_death_effect.tscn")

#NODES
@onready var attackCooldownNode = $Timers/attackCooldown
@onready var animation_tree = $AnimationTree
@onready var playback = animation_tree["parameters/playback"]

#VARIABLES
var banana_canannon_position : Vector2
var can_shoot : bool = true

var is_dead = false

#ATTACK
@export_category("Attack Settings")
@onready var sprite_2d = $Sprite2D
@onready var banana_cananon : Marker2D = $BananaCananon
@export var attack_duration : float = 0.5

#MOVEMENT
@export_category("Run State")
@export var run_speed : int = 50
@export var max_run_speed : int = 110

#SNEAK
var sneak_max_value: float = 1
@export var sneak_value_factor: float = 0.5
@onready var sneak_value: float = sneak_max_value

#FRICTION
@export_category("Physics Friction")
@export var slow_down_speed : int = 800

#JUMP SETTINGS
@export_category("Jump Settings")
@export var jump_speed : float = -300
@export var jump_horizontal_velocity : int = 125
@export var max_jump_horizontal_velocity : int = 150
@export var max_jump_count : int = 2
@export var landing_slow_down_speed : int = 10000
@export var jump_gravity : float = 800
@export var coyote_time : float = 0.2

var current_jump_count : int = 0
var coyote_jump : bool = false
var base_max_jump_count : int = 1
var is_jumping = false

#CLING SETTINGS
var is_clinging_to_wall = false

func _ready():
	reset()
	pass

func reset() -> void:
	attackCooldownNode.wait_time = attack_duration
	animation_tree.active = true
	pass

func _input(event):
	shoot()
	jump()
	pass


func _physics_process(delta):
	movement(delta)
	gravity(delta)
	land()
	sneak()
	cling()
	
	move_and_slide()
	pass

func movement(delta):
	if is_clinging_to_wall: return
	
	var direction: float = GameInputEvents.movement_input()

	if direction:
		velocity.x += direction * run_speed
		velocity.x = clamp(velocity.x, -max_run_speed, max_run_speed)
		sprite_2d.flip_h = false if direction > 0 else true
	
	velocity.x = move_toward(velocity.x * sneak_value, 0, slow_down_speed * delta)
	
	#RUN ANIMATION
	animation_tree["parameters/move/blend_position"] = direction
	pass

func sneak()-> void:
	if is_clinging_to_wall: return
	
	if GameInputEvents.sneak_input():
		sneak_value = sneak_value_factor
	else:
		sneak_value = sneak_max_value
	
	animation_tree["parameters/move/1/blend_position"] = sneak_value
	animation_tree["parameters/move/2/blend_position"] = sneak_value

	pass

func cling() -> void:
	if GameInputEvents.wall_cling_input() and is_on_wall() and !is_on_floor():
		is_clinging_to_wall = !is_clinging_to_wall
		animation_tree["parameters/conditions/is_clinging"] = is_clinging_to_wall
		animation_tree["parameters/conditions/is_not_clinging"] = !is_clinging_to_wall
		current_jump_count = 0
	
	if is_clinging_to_wall:
		velocity.y = 0
		velocity.x = 0
	pass

func shoot() -> void:
	if GameInputEvents.attack_input() and can_shoot:
		shoot_banana()
		can_shoot = false
		attackCooldownNode.start()
		animation_tree["parameters/conditions/is_attacking"] = true
		await get_tree().create_timer(0.1).timeout
		animation_tree["parameters/conditions/is_attacking"] = false
	pass

func land() -> void:
	if is_on_floor() and is_jumping: 
		current_jump_count = 0
		is_jumping = false
		animation_tree["parameters/conditions/is_jumping"] = false
		animation_tree["parameters/conditions/is_falling"] = false
		animation_tree["parameters/conditions/is_landing"] = true

	pass

func gravity(delta) -> void:
	
	#JUMP ANIMATION
	if velocity.y > 0:
		animation_tree["parameters/conditions/is_falling"] = true
		animation_tree["parameters/conditions/is_jumping"] = false
		animation_tree["parameters/conditions/is_landing"] = false
	elif velocity.y < 0 && !is_on_floor():
		animation_tree["parameters/conditions/is_falling"] = false
		animation_tree["parameters/conditions/is_jumping"] = true
		animation_tree["parameters/conditions/is_landing"] = false
		pass
	
	
	if is_clinging_to_wall: return
	velocity.y += jump_gravity * delta
	pass

func jump() -> void:
	if is_clinging_to_wall: return
	
	if GameInputEvents.jump_input() and current_jump_count < max_jump_count:
		animation_tree["parameters/conditions/is_jumping"] = true
		animation_tree["parameters/conditions/is_landing"] = false
		animation_tree["parameters/conditions/is_falling"] = false
		
		await get_tree().create_timer(0.2).timeout
		velocity.y = jump_speed
		current_jump_count += 1
		coyote_jump = false
		
#		FIXED DOUBLE JUMP BUG ON GROUND
		await get_tree().create_timer(0.1).timeout
		is_jumping = true

	if coyote_jump:
		velocity.y = jump_speed
		current_jump_count += 1
		coyote_jump = false
	
	pass

func shoot_banana() -> void:
	var direction : float = -1 if sprite_2d.flip_h else 1
	var banana_instance = banana_scene.instantiate() as Node2D
	banana_instance.direction = direction if !is_clinging_to_wall else -direction
	banana_instance.move_x_direction = true
	
	var flip = sprite_2d.flip_h
	banana_cananon.position.x = -abs(banana_canannon_position.x) if flip else abs(banana_canannon_position.x)
	
	banana_instance.global_position = banana_cananon.global_position
	get_parent().add_child(banana_instance)
	pass


func player_death() -> void:
	is_dead = true
	# Instantiate the death effect
	var player_death_instance = player_death_effect.instantiate() as Node2D
	player_death_instance.global_position = global_position
	get_parent().add_child(player_death_instance)
	
	# Hide the player sprite
	sprite_2d.visible = false

func respawn() -> void:
	is_dead = false
	sprite_2d.visible = true
	# Reset health
	HealthManager.heal(HealthManager.max_health)	

func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy") and !is_dead:
		
		playback.travel("hurt")
		HealthManager.take_damage(body.damage_amount)
		if HealthManager.current_health <= 0:
			player_death()


func _on_hurtbox_area_entered(area: Area2D):
	if area.is_in_group("Enemy") and !is_dead:
		var damage_amount = area.get_parent().damage_amount
		
		playback.travel("hurt")
		HealthManager.take_damage(damage_amount)
		if HealthManager.current_health <= 0:
			player_death()
	pass # Replace with function body.


func _on_attack_cooldown_timeout():
	can_shoot = true
	pass # Replace with function body.
