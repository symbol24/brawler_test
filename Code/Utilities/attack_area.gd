class_name AttackArea extends Area2D


var brawler_owner:Brawler
var current_attack:String
var cancelled:bool = false


func _ready() -> void:
	area_entered.connect(_area_entered)
	var parent = get_parent()
	if parent is BrawlerAction:
		brawler_owner = parent.get_parent()


func set_current_attack(id:String) -> void:
	current_attack = id


func _area_entered(area:Area2D) -> void:
	if area is AttackArea:
		if area.brawler_owner != brawler_owner:
			cancelled = true