class_name AttackArea extends Area2D


var brawler_owner:Brawler
var enemy_owner
var current_attack:String


func _ready() -> void:
	var parent = get_parent()
	if parent is BrawlerAction:
		brawler_owner = parent.get_parent()


func set_current_attack(id:String) -> void:
	current_attack = id