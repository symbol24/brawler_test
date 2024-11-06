class_name BrawlerData extends Resource


@export var id:String
@export var path:String

@export_category("Health")
@export var starting_life:int = -1
@export var starting_hp:int = 1

@export_category("Move")
@export var friction:float = 700
@export var acceleration:float = 1100
@export var starting_speed:float = 200
@export var air_multiplier:float = 0.7

@export_category("Jump")
@export var starting_jump_count:int = 2
@export var starting_time_to_peak:float = 0.3
@export var starting_time_to_descend:float = 0.5
@export var starting_jump_height:int = 32
@export var starting_extra_jump_height:int = 16

@export_category("Attacks")
@export var attacks:Array[AttackData]

@export_category("Spawning")
@export var spawn_in_delay:float = 0.5

# HP
var current_hp:int = -1:
	set(value):
		current_hp = value
		if current_hp <= 0:
			current_life_count -= 1
			is_alive = false
			Signals.BrawlerDeath.emit(self)
var current_life_count:int = -1:
	set(value):
		current_life_count = value
		if current_life_count < 0: current_life_count = 0
		Signals.UpdatePlayerLifeCount.emit(self)
var is_alive:bool = true

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


func setup_brawler() -> void:
	current_hp = starting_hp
	if current_life_count == -1:
		current_life_count = starting_life
	is_alive = true


func get_duplicate() -> BrawlerData:
	var result:BrawlerData = BrawlerData.new()
	result = duplicate()
	result.attacks.clear()
	result.attacks = attacks.duplicate(true)
	return result


func receive_damages(_damages:Array[Damage]) -> void:
	if not _damages.is_empty(): Signals.BrawlerHit.emit(self)
	for each in _damages:
		if is_alive: current_hp -= each.get_damage()


func get_attack_value(attack_id:String, var_name:String):
	for each in attacks:
		if each.id == attack_id and each.get(var_name): return each.get(var_name)
	return null


func get_attack_by_id(_id:String) -> AttackData:
	for each in attacks:
		if each.id == _id: return each
	return null