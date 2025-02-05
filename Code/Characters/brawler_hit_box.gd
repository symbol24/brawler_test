class_name BrawlerHitBox extends Area2D


@onready var brawler:Brawler = get_parent() as Brawler


func _ready() -> void:
	area_entered.connect(_area_entered)


func _area_entered(area:Area2D) -> void:
	if area is AttackArea:
		if area.brawler_owner != null and area.brawler_owner != brawler and brawler.get_can_be_hit():
			await get_tree().create_timer(0.1).timeout
			if not area.cancelled:
				var attach:AttackData = area.brawler_owner.data.get_attack_by_id(area.current_attack)
				await get_tree().create_timer(0.05).timeout
				var dmgs:Array[Damage] = attach.damages
				brawler.data.receive_damages(dmgs)
			else:
				area.cancelled = false