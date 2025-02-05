class_name Level extends Node2D



@export var display_player_ui:bool = true

var spawn_manager:SpawnManager


func _ready() -> void:
	if display_player_ui: Signals.ToggleUi.emit("player_ui", true)
	spawn_manager = Manager.load_and_return_spawn_manager()
	add_child(spawn_manager)


func _exit_tree() -> void:
	if display_player_ui: Signals.ToggleUi.emit("player_ui", false)