class_name Level extends Node2D


@export var display_player_ui:bool = true

var spawn_manager:SpawnManager


func _ready() -> void:
	Signals.BrawlerDeath.connect(_check_end_match)
	if display_player_ui: Signals.ToggleUi.emit("player_ui", true)
	spawn_manager = Manager.load_and_return_spawn_manager()
	add_child(spawn_manager)


func get_winner() -> PlayerData:
	for player in Manager.mpm.players:
		if not player.active_brawler.is_fully_dead: return player
	
	Debug.error("No winner?")
	return null


func _exit_tree() -> void:
	if display_player_ui: Signals.ToggleUi.emit("player_ui", false)
	Signals.ToggleUi.emit("match_result", false)


func _check_end_match(_b_data:BrawlerData) -> void:
	var dead_count:int = 0
	for player in Manager.mpm.players:
		if player.active_brawler.is_fully_dead: dead_count += 1
	#Debug.log("Dead count: ", dead_count, " player count size: ", Manager.mpm.players.size())
	if dead_count == Manager.mpm.players.size()-1:
		Signals.ToggleUi.emit("match_result", true)
		