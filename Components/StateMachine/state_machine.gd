class_name StateMachine
extends Node

##Manages states.
##Add [State] nodes as children.

##The initial state that is run when this node is ready.
@export var initial_state : State
##When true, [method State.run] of the current state will be run every physics process.
@export var run_state_every_frame := true

@onready var _current_state := initial_state : set = set_state

func _ready():
	for child in get_children():
		if child is State:
			child.connect("state_ended", set_state)
			child.is_current_state = func(): return _current_state == child

func _physics_process(delta):
	if run_state_every_frame: run_current_state()

##Change current state to [param new_state]
func set_state(new_state: State) -> void:
	_current_state.exit()
	_current_state = new_state
	new_state.enter()

##Call [method State.run] on the current state.
func run_current_state() -> void:
	if _current_state != null:
		_current_state.run() 
