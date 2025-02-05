extends CanvasLayer


var player_ui:PlayerUi = null


func _ready() -> void:
	Signals.ToggleUi.connect(_toggle_ui)


func _toggle_ui(uid:String, display:bool) -> void:
	match uid:
		"player_ui":
			_display_player_ui(display)
		_:
			Debug.log("No ui with uid %s found." % uid)


func _display_player_ui(display:bool) -> void:
	if display:
		var new:PlayerUi = Manager.data_manager.player_ui.instantiate()
		add_child(new)
		if not new.is_node_ready(): await new.ready

		if player_ui != null:
			Debug.log("Previous Player Ui was not cleared. Clearing now.")
			player_ui.queue_free()
			player_ui = null
		
		player_ui = new

	else:
		player_ui.queue_free()
		player_ui = null
