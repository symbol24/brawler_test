class_name DebugPlayerInfo extends Control

@onready var output_movement: RichTextLabel = %output_movement
@onready var state: RichTextLabel = %state
@onready var jump: RichTextLabel = %jump
@onready var jump_2: RichTextLabel = %jump2
@onready var attacks: RichTextLabel = %attacks
@onready var axes: RichTextLabel = %axes

var player_id:int = -1


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.DebugUpdateBoxText.connect(_update_debug_box_text)


func _update_debug_box_text(_player_id:int, _id:String, _text:String) -> void:
	if Debug.active and _player_id == player_id:
		match _id:
			"move":
				output_movement.text = _text
			"state":
				state.text = _text
			"jump":
				jump.text = _text
			"jump_count":
				jump_2.text = _text
			"attacks":
				attacks.text = _text
			"axes":
				axes.text = _text
			_:
				pass