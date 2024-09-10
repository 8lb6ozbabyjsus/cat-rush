extends CanvasLayer

var tutorial = preload("res://scenes/levels/tutorial/tutorial.tscn")

func _on_start_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_quit_button_pressed():
	GameManager.quit_game()
