class_name DebugUi extends PanelContainer


const PLAYERINFO:String = "res://Scenes/Debug/debug_player_info.tscn"


@onready var debug_command_menu: DebugCommandsMenu = %debug_command_menu
@onready var info_control: Control = %info_control


var can_toggle_cm:bool = true
var infos:Array[DebugPlayerInfo] = []


func _input(event: InputEvent) -> void:
	if not get_tree().paused and can_toggle_cm and event.is_action_pressed("debug"):
		debug_command_menu.toggle_debug_command_menu()
		can_toggle_cm = false
	elif event.is_action_released("debug"):
		can_toggle_cm = true


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.DebugDisplayInfo.connect(_display_info)


func _display_info(_player_id:int, _display:bool) -> void:
	var info:DebugPlayerInfo = _get_debug_info(_player_id)
	if info:
		info.visible = _display
	else:
		var new_info:DebugPlayerInfo = load(PLAYERINFO).instantiate()
		new_info.player_id = _player_id
		info_control.add_child(new_info)
		Debug.log(_get_position(_player_id))
		new_info.position = _get_position(_player_id)
		new_info.visible = _display
		

func _get_debug_info(_player_id:int) -> DebugPlayerInfo:
	if infos.is_empty(): return null

	for each in infos: if each.player_id == _player_id: return each

	return null


func _get_position(_player_id:int) -> Vector2:
	match _player_id:
		0: #432, 240
			return Vector2(16, 16)
		1:
			return Vector2(16, 140)
		2:
			return Vector2(332, 16)
		3:
			return Vector2(332, 140)
		4:
			return Vector2(16, 16)
		5:
			return Vector2(16, 16)
		6:
			return Vector2(16, 16)
		_:
			return Vector2(16, 16)