class_name MatchResult extends SyControl


@onready var result: Label = %result


func _input(event: InputEvent) -> void:
	if visible:
		if event.is_action_pressed("ui_accept") and Manager.mpm.is_device_in_use(event.device):
			SceneManager.load_scene("main_menu")


func set_result() -> void:
	var player_data:PlayerData = SceneManager.active_level.get_winner()
	result.text = player_data.active_brawler.id
	result.modulate = player_data.active_brawler.colors[player_data.player_id]
