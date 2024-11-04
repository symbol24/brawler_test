class_name MultiplayerManager extends Node


const MAXPLAYERCOUNT:int = 2


var players:Array[PlayerData] = []
var waiting_for_input:bool = false


func _input(event: InputEvent) -> void:
	if waiting_for_input:
		if event.is_action_pressed("jump"):
			#Debug.log("Device id pressed: ", event.device)
			if not is_device_in_use(event.device):
				_setup_new_player(event.device)


func _ready() -> void:
	Signals.MPMAcceptInputs.connect(_toggle_mpm)

	Signals.MPMReady.emit()
	Debug.log("MPM Ready")


func get_player_data(player_id:int) -> PlayerData:
	_print_active_players()
	for each in players:
		if each.player_id == player_id: return each
	Debug.warning("No player data found for id %d" % player_id)
	return null


func is_device_in_use(_device:int) -> bool:
	if players.is_empty(): return false
	for each in players:
		if _device == each.device:
			#Debug.log("device %d in use" % _device)
			return true
	return false


func get_player_id_for_device(_device:int) -> int:
	for each in players:
		if each.device == _device: return each.player_id
	return -1


func _toggle_mpm(value:bool = false) -> void:
	waiting_for_input = value
	Debug.log("MPM accepts inputs: ", value)


func _setup_new_player(_device:int) -> void:
	var new_player:PlayerData = PlayerData.new()
	new_player.device = _device
	new_player.player_id = players.size()
	players.append(new_player)
	
	if players.size() >= MAXPLAYERCOUNT: waiting_for_input = false
	#Debug.log("Player count: %d" % players.size())
	_print_active_players()
	Signals.SpawnPlayer.emit(new_player)


# Debug

func _print_active_players() -> void:
	for each in players:
		Debug.log("Player %d is using device %d." % [each.player_id, each.device])