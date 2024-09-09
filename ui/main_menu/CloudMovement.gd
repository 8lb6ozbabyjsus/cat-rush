extends Node2D

# Speed at which the clouds move (in pixels per second)
@export var cloud_speed: Vector2 = Vector2(5.0, 0.8)  # X for horizontal, Y for vertical

# Size of the viewport (in pixels)
@export var viewport_size: Vector2 = Vector2(400, 270)

func _process(delta: float) -> void:
	# Move the TileMapLayer by cloud_speed * delta
	position -= cloud_speed * delta
