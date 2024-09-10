extends Node

var main_menu = preload("res://ui/main_menu/main_menu.tscn")
var pause_menu = preload("res://ui/pause_menu/pause_menu.tscn")
var tutorial = preload("res://scenes/levels/tutorial/tutorial.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color(0.16,0.71,1.00,1.00))


func start_game():
	if get_tree().paused:
		unpause_game()
		return
	transition_to_level(tutorial)

func transition_to_level(level):
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_packed(level)


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
