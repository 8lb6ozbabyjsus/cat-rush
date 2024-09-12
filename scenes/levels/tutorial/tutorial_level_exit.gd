extends Node2D

@export var next_level : String = "Level_Scoring"

func _on_exit_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		var player = body as CharacterBody2D
		player.queue_free()

	await get_tree().create_timer(3.0).timeout
	print("Player entered level exit")
	SceneManager.load_next_level(next_level)


func _on_animation_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("open")


func _on_animation_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("close")
