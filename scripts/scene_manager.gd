extends Node

var scenes : Dictionary = {
	"Tutorial" : "res://scenes/levels/tutorial/tutorial.tscn",
	# "Level_1" : "res://scenes/levels/level_1/level_1.tscn",
	# "Level_Selection" : "res://scenes/levels/level_selection.tscn",
	# "Level_Scoring" : "res://scenes/levels/level_scoring.tscn"
}

func load_next_level(level: String):
	var scene_path : String = scenes.get(level)
	if scene_path != null:
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(scene_path)	
