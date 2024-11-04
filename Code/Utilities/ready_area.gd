class_name ReadyArea extends Area2D


func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)


func _body_entered(body:Node2D) -> void:
	if body is Brawler:
		Signals.PlayerReady.emit(body.player_data.player_id, true)


func _body_exited(body:Node2D) -> void:
	if body is Brawler:
		Signals.PlayerReady.emit(body.player_data.player_id, false)