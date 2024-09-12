extends Node

var loading_screen = preload("res://ui/loading_screen/loading_screen.tscn")

var scenes : Dictionary = {
	"Tutorial" : "res://scenes/levels/tutorial/tutorial.tscn",
	# "Level_1" : "res://scenes/levels/level_1/level_1.tscn",
	# "Level_Selection" : "res://scenes/levels/level_selection.tscn",
	# "Level_Scoring" : "res://scenes/levels/level_scoring.tscn"
}

func load_next_level(level: String):
	var scene_path : String = scenes.get(level)

	if scene_path != null:
		var loading_screen_instance = loading_screen.instantiate()
		get_tree().root.add_child(loading_screen_instance)
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file(scene_path)	
		loading_screen_instance.queue_free()
