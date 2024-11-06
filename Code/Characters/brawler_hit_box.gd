class_name BrawlerHitBox extends Area2D


@onready var brawler:Brawler = get_parent() as Brawler


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is AttackArea:
		if area.brawler_owner != null and area.brawler_owner != brawler and brawler.get_can_be_hit():
			var attach:AttackData = area.brawler_owner.data.get_attack_by_id(area.current_attack)
			var dmgs:Array[Damage] = attach.damages
			brawler.data.receive_damages(dmgs)