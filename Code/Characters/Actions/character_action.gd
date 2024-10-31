class_name BrawlerAction extends Node2D

@export var button:String

var parent:CharacterBody2D
var can_action:bool = true


func _input(_event: InputEvent) -> void:
	if can_action and button != "" and _event.is_action_pressed(button):
		_trigger_action()


func _ready() -> void:
	parent = get_parent() as CharacterBody2D


func _trigger_action() -> void:
	Debug.log("base triggering action")
	can_action = false