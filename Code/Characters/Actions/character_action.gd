class_name BrawlerAction extends Node2D

@export var button:String
@export var delay_input:float = 0.3

var parent:CharacterBody2D
var can_action:bool = true
var action_timer:float = delay_input:
	set(value):
		action_timer = value
		if action_timer <= 0.0:
			action_timer = delay_input
			_end_action()

func _input(event: InputEvent) -> void:
	if _get_can_action(event)  and event.is_action_pressed(button):
		_trigger_action()


func _ready() -> void:
	parent = get_parent() as CharacterBody2D


func _process(delta: float) -> void:
	if not can_action: action_timer -= delta


func _trigger_action() -> void:
	Debug.log("base triggering action")
	can_action = false


func _end_action() -> void:
	can_action = true


func _get_can_action(_event:InputEvent) -> bool:
	return parent and parent.player_data and parent.active and _event.device == parent.player_data.device and button != ""