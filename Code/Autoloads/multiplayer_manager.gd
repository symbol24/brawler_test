extends Node


const MAXPLAYERCOUNT:int = 2


var players:Array[PlayerData] = []

var waiting_for_input:bool = true


func _input(event: InputEvent) -> void:
	if waiting_for_input:
		if event.is_action_pressed("jump"):
			#Debug.log("Device id pressed: ", event.device)
			if not _is_device_in_use(event.device):
				_setup_new_player(event.device)
				

func _setup_new_player(_device:int) -> void:
	var new_player:PlayerData = PlayerData.new()
	new_player.device = _device
	new_player.player_id = players.size()
	players.append(new_player)
	Signals.SpawnPlayer.emit(new_player)
	if players.size() >= MAXPLAYERCOUNT: waiting_for_input = false


func _is_device_in_use(_device:int) -> bool:
	if players.is_empty(): return false
	for each in players:
		if _device == each.device:
			return true
	return false

