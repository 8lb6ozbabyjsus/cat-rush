extends Node

static var total_score: int

signal score_changed(new_score: int)

func add_score(pickup_score: int):
	total_score += pickup_score
	score_changed.emit(total_score)