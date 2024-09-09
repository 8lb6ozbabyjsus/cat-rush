extends CanvasLayer


@onready var score = $MarginContainer/VBoxContainer/HBoxContainer/Score

func _ready():
	ScoreManager.score_changed.connect(update_score)

func update_score(new_score: int):
	score.text = str(new_score)
	
