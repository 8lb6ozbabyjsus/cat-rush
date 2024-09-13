extends CharacterBody2D

var banana = preload("res://scenes/player/weapons/banana/banana.tscn")
var player_death_effect = preload("res://scenes/player/player_death_effect/player_death_effect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var bananacananon : Marker2D = $BananaCananon

var is_dead = false

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
	animated_sprite_2d.visible = true
	# Reset health
	HealthManager.heal(HealthManager.max_health)	

func _on_hurtbox_body_entered(body : Node2D):
	if body.is_in_group("Enemy") and !is_dead:
		print("Hurt: ", body.damage_amount)
		
		animated_sprite_2d.play("damage")
		HealthManager.take_damage(body.damage_amount)
		if HealthManager.current_health <= 0:
			player_death()
