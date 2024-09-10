extends CanvasLayer

func _on_start_button_pressed():
	GameManager.unpause_game()
	queue_free()

func _on_quit_button_pressed():
	GameManager.quit_game()


func _on_main_menu_button_pressed():
	GameManager.main_menu_screen()
