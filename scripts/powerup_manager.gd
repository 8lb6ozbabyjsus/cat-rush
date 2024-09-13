extends Node

var _current_jump_count : int = 0
var _max_jumps : int = 1

func reset_jump_count():
    _current_jump_count = 0

func increment_jump_count():
    _current_jump_count += 1

func can_jump() -> bool:
    return _current_jump_count < _max_jumps

func set_max_jumps(value: int):
    _max_jumps = value

func get_current_jump_count() -> int:
    return _current_jump_count