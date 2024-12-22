class_name State
extends Node

##Used by [StateMachine]. Determines what code is run when this is the current state.

var is_current_state := func(): return false

##Emitted when the state is ended. [param new_state] is the state to switch to.
@warning_ignore("unused_signal")
signal state_ended(new_state: State)

##Called by [StateMachine] when this state is switched to.
func enter() -> void:
	pass

##Called by [StateMachine] when the current state in the state machine changes.
func exit() -> void:
	pass

##Called by [StateMachine] whenever it chooses to run the code in this state.
func run() -> void:
	pass
