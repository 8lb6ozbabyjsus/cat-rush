extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export_category("Fall State")
@export var coyote_time : float = 0.2

const GRAVITY : int = 700
var coyote_jump : bool

func on_process(_delta: float):
	pass


func on_physics_process(delta: float):
	if !character_body_2d.is_on_floor():
		get_coyote_time()
	character_body_2d.velocity.y += GRAVITY * delta

	# Check for wall cling
	if GameInputEvents.wall_cling_input() and character_body_2d.is_on_wall():
		state_changed.emit("AttackWall")


	character_body_2d.move_and_slide()

	# state changes

	# land state
	if character_body_2d.is_on_floor():
		state_changed.emit("Land")

	# Allow jumping while falling (for better player control)
	if GameInputEvents.jump_input():
		state_changed.emit("Jump")

func enter():
	coyote_jump = true
	animated_sprite_2d.play("fall")

func exit():
	animated_sprite_2d.stop()

func get_coyote_time():
	await get_tree().create_timer(coyote_time).timeout
	coyote_jump = false