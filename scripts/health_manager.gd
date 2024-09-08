extends Node

var max_health : int = 3
var current_health : int

signal health_changed(new_health : int)

func _ready():
	current_health = max_health

func take_damage(damage : int):
	current_health -= damage
	
	if current_health <= 0:
		current_health = 0
		die()


	print(current_health)
	health_changed.emit(current_health)

func heal(heal_amount : int):
	current_health += heal_amount
	if current_health > max_health:
		current_health = max_health

	print(current_health)
	health_changed.emit(current_health)

func die():
	print("Dead")
	health_changed.emit(current_health)