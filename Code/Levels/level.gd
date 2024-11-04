class_name Level extends Node2D


var spawn_manager:SpawnManager


func _ready() -> void:
	spawn_manager = Manager.load_and_return_spawn_manager()
	add_child(spawn_manager)