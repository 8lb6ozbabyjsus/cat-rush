extends CanvasLayer


@onready var score = $MarginContainer/VBoxContainer/HBoxContainer/Score

func _ready():
	ScoreManager.score_changed.connect(update_score)
	update_score(ScoreManager.total_score)

func update_score(new_score: int):
	score.text = str(new_score)
	


func _on_pause_button_pressed():
	GameManager.pause_game()
