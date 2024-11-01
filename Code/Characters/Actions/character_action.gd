class_name BrawlerAction extends Node2D

@export var button:String

var parent:CharacterBody2D
var can_action:bool = true


func _input(event: InputEvent) -> void:
	if _get_can_action(event)  and event.is_action_pressed(button):
		_trigger_action()


func _ready() -> void:
	parent = get_parent() as CharacterBody2D


func _trigger_action() -> void:
	Debug.log("base triggering action")
	can_action = false


func _get_can_action(_event:InputEvent) -> bool:
	return parent and parent.player_data and _event.device == parent.player_data.device and button != ""