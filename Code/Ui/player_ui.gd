class_name PlayerUi extends SyControl


var positions:Array[Vector2] = [Vector2(8,8), Vector2(8,8), Vector2(8,8), Vector2(8,8)]


func _ready() -> void:
	Signals.BrawlerReady.connect(_build_player_panel)


func _build_player_panel(player_data:PlayerData) -> void:
	if player_data != null:	
		var new:PlayerPanel = Manager.data_manager.player_panel.instantiate()
		add_child(new)
		if not new.is_node_ready(): await new.ready
		new.brawler_data = player_data.active_brawler
		new.setup_lives(player_data.active_brawler.lives_icon[player_data.player_id], player_data.active_brawler.current_life_count)
		new.setup_color(player_data.active_brawler.colors[player_data.player_id])
		new.player_stuff.text = tr(player_data.active_brawler.id)
		new.name = "player_panel_" + player_data.active_brawler.id + "_" + str(player_data.player_id)
		match player_data.player_id:
			0:
				new.set_anchors_and_offsets_preset(PRESET_TOP_LEFT)
				new.position.x += 8
				new.position.y += 8
			1:
				new.set_anchors_and_offsets_preset(PRESET_TOP_RIGHT)
				new.position.x -= (new.size.x/2)
				new.position.y += 8
			2:
				new.set_anchors_and_offsets_preset(PRESET_BOTTOM_LEFT)
				new.position.x += 8
				new.position.y -= (new.size.y/2)
			_:
				new.set_anchors_and_offsets_preset(PRESET_BOTTOM_RIGHT)
				new.position.x -= (new.size.x/2)
				new.position.y -= (new.size.y/2)


