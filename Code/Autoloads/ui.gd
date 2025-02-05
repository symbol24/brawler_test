extends CanvasLayer


var player_ui:PlayerUi = null
var match_result:MatchResult = null


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.ToggleUi.connect(_toggle_ui)


func _toggle_ui(uid:String, display:bool) -> void:
	match uid:
		"player_ui":
			_display_player_ui(display)
		"match_result":
			_display_end_match_result(display)
		_:
			Debug.log("No ui with uid %s found." % uid)


func _display_player_ui(display:bool) -> void:
	if display:
		var new:PlayerUi = Manager.data_manager.player_ui.instantiate()
		add_child(new)
		if not new.is_node_ready(): await new.ready

		if player_ui != null:
			Debug.warning("Previous Player Ui was not cleared. Clearing now.")
			player_ui.queue_free()
			player_ui = null
		
		player_ui = new

	else:
		player_ui.queue_free()
		player_ui = null


func _display_end_match_result(display:bool) -> void:
	if display:
		await get_tree().create_timer(3).timeout
		get_tree().paused = true
		if match_result != null:
			Debug.warning("Previous match result screen not cleared. Clearing now.")
			match_result.queue_free()
			match_result = null

		match_result = Manager.data_manager.match_result.instantiate()
		add_child(match_result)
		if not match_result.is_node_ready(): await match_result.ready
		match_result.set_result()

	else:
		if match_result != null:
			match_result.queue_free()
			match_result = null