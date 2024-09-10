extends CanvasLayer

var tutorial = preload("res://scenes/levels/tutorial/tutorial.tscn")
var settings = preload("res://ui/settings_menu/settings_menu.tscn")


func _on_start_button_pressed():
	GameManager.start_game()
	queue_free()

func _on_quit_button_pressed():
	GameManager.quit_game()


func _on_settings_button_pressed():
	var settings_menu = settings.instantiate()
	get_tree().get_root().add_child(settings_menu)
