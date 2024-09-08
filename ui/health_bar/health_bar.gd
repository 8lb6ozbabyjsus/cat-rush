extends Node2D

@export var heart1: Texture2D
@export var heart0: Texture2D
@export var health : int = 3

@onready var health_1 = $Health1
@onready var health_2 = $Health2
@onready var health_3 = $Health3


func _ready():
	HealthManager.health_changed.connect(on_player_health_changed)


func on_player_health_changed(player_current_health : int):
	if player_current_health == 3:
		health_1.texture = heart1
		health_2.texture = heart1
		health_3.texture = heart1
	elif player_current_health == 2:
		health_1.texture = heart1
		health_2.texture = heart1
		health_3.texture = heart0
	elif player_current_health == 1:
		health_1.texture = heart1	
		health_2.texture = heart0
		health_3.texture = heart0
	elif player_current_health == 0:
		health_1.texture = heart0
		health_2.texture = heart0
		health_3.texture = heart0

func update_health_bar():
	pass
