class_name BrawlerData extends Resource


@export var id:String
@export var path:String

@export_group("Health")
@export var starting_life:int = -1
@export var starting_hp:int = 1

@export_group("Move")
@export var friction:float = 700
@export var acceleration:float = 1100
@export var starting_speed:float = 200
@export var air_multiplier:float = 0.7

@export_group("Jump")
@export var starting_jump_count:int = 2
@export var starting_time_to_peak:float = 0.3
@export var starting_time_to_descend:float = 0.5
@export var starting_jump_height:int = 32
@export var starting_extra_jump_height:int = 16

@export_group("Attacks")
@export var attacks:Dictionary = {	"attack1":{
									"state":Brawler.State.ATTACK1,
									}
								}

# MOVE
var speed:float:
	get: return starting_speed


# JUMP
var jump_count:int:
	get: return starting_jump_count
var time_to_peak:float:
	get: return starting_time_to_peak
var time_to_descend:float:
	get: return starting_time_to_descend
var jump_height:int:
	get: return starting_jump_height
var extra_jump_height:int:
	get:return starting_jump_height


func get_duplicate() -> BrawlerData:
	var result:BrawlerData = BrawlerData.new()
	result = duplicate()
	result.attacks.clear()
	result.attacks = attacks.duplicate(true)
	return result


func get_attack_value(attack_key:String, value_key:String):
	if attacks.has(attack_key) and attacks[attack_key].has(value_key):
			return attacks[attack_key][value_key]
	return 0