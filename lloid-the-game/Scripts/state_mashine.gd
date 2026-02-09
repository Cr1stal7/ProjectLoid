extends Node
#############################################
# State machine as set up in my video on FSMs
# https://www.youtube.com/watch?v=ow_Lum-Agbs
# Code is clearer here though, better names
#############################################

@export var initial_state : State

var current_state : State
var states : Dictionary = {}


func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
	
	if initial_state:
		current_state = initial_state
		current_state.Enter()


func _process(delta):
	if current_state:
		current_state.Update(delta)


func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)


func on_child_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	# Clean up the previous state
	if current_state:
		current_state.Exit()
	
	# Intialize the new state
	new_state.Enter()
	current_state = new_state
