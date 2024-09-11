extends Node

var main_menu = preload("res://ui/main_menu/main_menu.tscn")
var pause_menu = preload("res://ui/pause_menu/pause_menu.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color(0.16,0.71,1.00,1.00))

	SettingsManager.load_settings()

func start_game():
	if get_tree().paused:
		unpause_game()
		return
	SceneManager.load_next_level("Tutorial")

func quit_game():
	get_tree().quit()	

func pause_game():
	get_tree().paused = true
	var menu = pause_menu.instantiate()
	get_tree().get_root().add_child(menu)

func unpause_game():
	get_tree().paused = false

func main_menu_screen():
	var menu = main_menu.instantiate()
	get_tree().get_root().add_child(menu)
