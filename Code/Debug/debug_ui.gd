class_name DebugUi extends PanelContainer


@onready var debug_command_menu: VBoxContainer = %debug_command_menu
@onready var output_movement: RichTextLabel = %output_movement
@onready var state: RichTextLabel = %state
@onready var jump: RichTextLabel = %jump
@onready var jump_2: RichTextLabel = %jump2
@onready var attacks: RichTextLabel = %attacks
@onready var output: RichTextLabel = %output
@onready var input: LineEdit = %input
@onready var axes: RichTextLabel = %axes

var can_toggle_cm:bool = true


func _input(event: InputEvent) -> void:
	if not get_tree().paused and can_toggle_cm and event.is_action_pressed("debug"):
		_toggle_debug_command_menu()
		can_toggle_cm = false
	elif event.is_action_released("debug"):
		can_toggle_cm = true


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.DebugUpdateBoxText.connect(_update_debug_box_text)
	Signals.DebugPrint.connect(_debug_print)
	input.text_changed.connect(_ignore_tild)


func _debug_print(_text:String) -> void:
	output.text += "\n"
	output.text += _text


func _ignore_tild(_new:String) -> void:
	var modified:String = _new
	if not _new.is_empty():
		while "`" in _new:
			_new = _new.erase(_new.find("`"), 1)
		if modified != _new:
			input.text = _new


func _toggle_debug_command_menu() -> void:
	debug_command_menu.visible = !debug_command_menu.visible
	if debug_command_menu.visible:
		input.text = ""
		input.grab_focus()


func _update_debug_box_text(_id:String, _text:String) -> void:
	if Debug.active:
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

