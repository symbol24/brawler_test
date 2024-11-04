class_name PlayLevel extends Level


func _ready() -> void:
	super()
	Manager.spawn_manager.spawn_all_players()