extends Node2D

@export var health_pickup_amount : int = 1
@export var score_value: int = 1

func _on_health_pickup_box_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.heal(health_pickup_amount)
		ScoreManager.add_score(score_value)
		queue_free()
