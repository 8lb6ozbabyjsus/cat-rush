class_name NodeFiniteStateMachine
extends Node

@export var initial_state : NodeState

var node_states : Dictionary = {}
var current_state : NodeState
var current_state_name : String

func _ready():
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child

	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.on_process(delta)

func _physics_process(delta):
	if current_state:
		current_state.on_physics_process(delta)

	print("current state: ", current_state.name.to_lower())


func transition_to(node_state : String):
	if not node_states.has(node_state):
		return

	var new_state = node_states[node_state]

	if !new_state:
		return

	if current_state:
		current_state.exit()

	new_state.enter()
	current_state = new_state
	current_state_name = current_state.name.to_lower()
