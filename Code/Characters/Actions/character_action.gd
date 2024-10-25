class_name CharacterAction extends Node2D


var parent:CharacterBody2D
var can_action:bool = true


func _ready() -> void:
	parent = get_parent() as CharacterBody2D