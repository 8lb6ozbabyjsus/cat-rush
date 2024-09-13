class_name GameInputEvents
extends Node

static func movement_input() -> float:
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction

static func jump_input() -> bool:
	var jump_input : bool = Input.is_action_just_pressed("jump") 
	return jump_input

static func attack_input() -> bool:
	var attack_input : bool = Input.is_action_just_pressed("attack")
	return attack_input

static func attack_up_input() -> bool:
	var attack_up_input : bool = Input.is_action_just_pressed("attack") and Input.is_action_pressed("look_up")
	return attack_up_input

static func sneak_input() -> bool:
	var sneak_input : bool = Input.is_action_pressed("sneak")
	return sneak_input

static func sneak_attack_input() -> bool:
	var sneak_input : bool = Input.is_action_pressed("sneak")
	var attack_input : bool = Input.is_action_just_pressed("attack")
	return sneak_input and attack_input

static func force_fall_input() -> bool:
	var force_fall_input : bool = Input.is_action_just_pressed("force_fall")
	return force_fall_input

static func wall_cling_input() -> bool:
	var wall_cling_input : bool = Input.is_action_pressed("wall_cling")
	return wall_cling_input

static func wall_cling_attack_input() -> bool:
	var wall_cling_input : bool = Input.is_action_pressed("wall_cling")
	var attack_input : bool = Input.is_action_just_pressed("attack")
	return wall_cling_input and attack_input    

static func interact_input() -> bool:
	var interact_input : bool = Input.is_action_just_pressed("interact")
	return interact_input

static func pause_input() -> bool:
	var pause_input : bool = Input.is_action_just_pressed("pause")
	return pause_input

static func inventory_input() -> bool:
	var inventory_input : bool = Input.is_action_just_pressed("inventory")
	return inventory_input

# static func map_input() -> bool:
#     var map_input : bool = Input.is_action_just_pressed("map")
#     return map_input
