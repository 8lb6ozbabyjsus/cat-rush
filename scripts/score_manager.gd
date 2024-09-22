extends Node

static var total_score: int = 0

var time_played: float = 0.0
var total_items_collected: int = 0
var total_enemies_killed: int = 0


signal score_changed(new_score: int)
var save_path = "user://cash_rush_data.save"

func _ready():
	#save_data()
	load_data()
	print(total_score, "total_score")
	pass

func _process(delta):
	time_played += delta

func add_score(pickup_score: int):
	total_score += pickup_score
	total_items_collected += pickup_score
	score_changed.emit(total_score)

func add_items(pickup_score: int):
	total_score += pickup_score
	total_items_collected += pickup_score
	score_changed.emit(total_score)
	pass

func add_enemies_killed(kill_score: int):
	total_score += kill_score
	total_enemies_killed += kill_score
	score_changed.emit(total_score)
	pass

func save_data():
	var save_dict = {
		"total_score": total_score,
		"total_items_collected": total_items_collected,
		"total_enemies_killed": total_enemies_killed
	}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_line(JSON.stringify(save_dict))
	pass

func load_data():
	if !FileAccess.file_exists(save_path): return
	var file = FileAccess.open(save_path, FileAccess.READ)
	var json = JSON.new()
	json.parse(file.get_line())
	
	var data = json.get_data()
	print(data, "data")
	total_score = data["total_score"]
	total_items_collected = data["total_items_collected"]
	total_enemies_killed = data["total_enemies_killed"]
	
	pass
