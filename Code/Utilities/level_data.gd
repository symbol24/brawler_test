class_name LevelData extends Resource


@export var levels:Dictionary = {}
@export var extra_loading_time:float = 0


func get_level_path(id:String) -> String:
	if levels.has(id):
		return levels[id]
	push_error("Level data does not have id: ", id)
	return ""