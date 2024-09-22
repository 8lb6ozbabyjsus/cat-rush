extends Control

var next_level : String = ""

var total_items_collected: int = 0
var total_enemies_killed: int = 0
var time_played: String = ""
var total_score: int = 0

@onready var total_enemies_killed_node: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/total_enemies_killed
@onready var total_items_collected_node: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/total_items_collected
@onready var time_played_node: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/time_taken
@onready var total_score_node: Label = $CenterContainer/Panel/MarginContainer/VBoxContainer/score

func _ready():
	hide()
	
	#show_stats()
	pass

func _show(_next_level) -> void:
	show()
	show_stats()
	next_level = _next_level

func set_time_played() -> void:
	var time_played_string = get_time_played_as_string()
	pass

func get_time_played_as_string() -> String:
	var total_time = ScoreManager.time_played
	var minutes = int(total_time / 60)
	var seconds = int(total_time) % 60
	return "%02d:%02d" % [minutes, seconds]
	
func show_stats() -> void:
	total_enemies_killed = ScoreManager.total_enemies_killed
	total_items_collected = ScoreManager.total_items_collected
	total_score = ScoreManager.total_score
	time_played = get_time_played_as_string()
	
	total_enemies_killed_node.text = 'Total Enemies Killed: ' + str(total_enemies_killed)
	total_items_collected_node.text = 'Total Items Collected: ' + str(total_items_collected)
	time_played_node.text = 'Time Taken: ' + str(time_played) + ' secs'
	total_score_node.text = 'Score: ' + str(total_score)
	
	pass

func _on_button_pressed():
	# Load Next Level
	ScoreManager.save_data()
	hide()
	SceneManager.load_next_level(next_level)
	pass # Replace with function body.
