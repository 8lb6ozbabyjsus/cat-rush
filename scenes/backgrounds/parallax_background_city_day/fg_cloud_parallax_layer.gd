extends ParallaxLayer

@export var scroll_speed : float = 5 # Speed of the scrolling

func _process(delta):
	# Continuously move the clouds to the left by adjusting the motion_offset
	motion_offset.x -= scroll_speed * delta
