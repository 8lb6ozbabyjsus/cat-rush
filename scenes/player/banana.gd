extends AnimatedSprite2D

var impact_effect = preload("res://scenes/player/banana_impact_effect.tscn")

var speed : int = 200
var direction : int
var damage_amount : int = 1

func _physics_process(delta):
	move_local_x(direction * speed * delta)

func _on_timer_timeout():
	queue_free()

func _on_hitbox_area_entered(_area):
	#print("banana area entered")
	banana_impact()

func _on_hitbox_body_entered(_body):
	#print("banana body entered")
	banana_impact()

func get_damage_amount():
	return damage_amount

func banana_impact():
	var banana_impact_effect_instance = impact_effect.instantiate() as Node2D
	banana_impact_effect_instance.global_position = global_position
	get_parent().add_child(banana_impact_effect_instance)
	queue_free()
