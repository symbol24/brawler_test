class_name MainMenu extends Level


@export var ready_points:Array[ReadyPoint] = []

var readies:Array = []


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start") and Manager.multiplayer_manager.is_device_in_use(event.device):
		Debug.log("Device %d has pressed start." % event.device)
		if _check_if_one_ready():
			Signals.MPMAcceptInputs.emit(false)
			_play()



func _ready() -> void:
	super()
	Signals.PlayerReady.connect(_check_player_ready)
	Signals.MPMReady.connect(_send_mpm_input)
	Manager.load_mpm()


func _send_mpm_input() -> void:
	Signals.MPMAcceptInputs.emit(true)


func _check_player_ready(player_id:int, display:bool) -> void:
	var player_data:PlayerData = Manager.multiplayer_manager.get_player_data(player_id)
	if player_data:
		player_data.player_ready = display

	for each in readies:
		if each.player_id == player_id:
			each.visible = display
			return
	
	var new:ReadySign = Manager.data_manager.player_ready_label.instantiate()
	add_child(new)
	new.position = _get_ready_point(player_id).global_position
	new.player_id = player_id
	new.visible = display
	readies.append(new)
	

func _get_ready_point(_player_id:int = -1) -> ReadyPoint:
	for each in ready_points:
		if each.id == _player_id: return each

	return null


func _play() -> void:
	SceneManager.load_scene("test")


func _check_if_one_ready() -> bool:
	var count:int = 0
	for each in Manager.multiplayer_manager.players:
		if each.player_ready: count += 1
	
	return count >= 1