extends Node2D

@export var powerup_type : String = "double_jump"

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		InventoryManager.add_item("powerup_type", powerup_type)
		queue_free()
