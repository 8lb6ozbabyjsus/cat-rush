extends Node2D


@export var score_value: int = 1

@onready var sprite2D: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func _ready():
	label.hide()

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		print("Coin collected | Score: ", score_value)
		sprite2D.hide()

		label.text = "+%s" % score_value	
		ScoreManager.add_score(score_value)
		
		label.show()
		
		var tween = create_tween()
		tween.tween_property(label, "position", Vector2(label.position.x, label.position.y + -10), 1).from_current()
		tween.tween_callback(queue_free)
		
		
