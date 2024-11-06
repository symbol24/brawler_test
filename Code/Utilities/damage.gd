class_name Damage extends Resource


@export var base_value:int = 1


var value:int:
	get: return base_value


func get_damage() -> int:
	return value