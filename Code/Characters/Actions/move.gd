class_name Move extends BrawlerAction


var display_debug:bool = true

var friction:float:
	get:return parent.data.friction if parent and parent.data else 700
var acceleration:float:
	get:return parent.data.acceleration if parent and parent.data else 1100
var speed:float:
	get:return parent.data.speed if parent and parent.data else 200

var direction:float = 0.0


func _input(event: InputEvent) -> void:
	if _get_can_move(event):
		direction = event.axis_value


func _process(delta: float) -> void:
	parent.set_velocity_x(_get_new_x(parent.velocity.x, direction, delta))
	_state_check()
	if display_debug: _debug_move_output()


func _get_new_x(_old_x:float = 0.0, _direction:float = 0.0, delta:float = 0.0) -> float:
	var new_x:float = _old_x
	var air_multi:float = parent.data.air_multiplier if parent.velocity.y >= 0.1 else 1.0

	if _direction > 0.1 or _direction < -0.1:
		new_x = move_toward(_old_x, _direction * speed * air_multi, delta * acceleration)
	elif _direction < 0.1 and _direction > -0.1:
		new_x = move_toward(_old_x, 0, delta * friction)

	return new_x


func _state_check() -> void:
	if parent.is_on_floor() and parent.current_state != Brawler.State.WALK and (parent.velocity.x > 1 or parent.velocity.x < -1):
		parent.set_state(Brawler.State.WALK)
	elif parent.is_on_floor() and parent.current_state != Brawler.State.IDLE and parent.velocity.x > -1 and parent.velocity.x < 1:
		parent.set_state(Brawler.State.IDLE)


func _debug_move_output() -> void:
	var to_send:String = ""
	to_send = "velocity.x: %10.2f \n" % parent.velocity.x
	to_send += "velocity.y: %10.2f" % parent.velocity.y
	Signals.DebugUpdateBoxText.emit("move", to_send)


func _get_can_move(_event:InputEvent) -> bool:
	return parent and parent.data and _event.device == parent.player_data.device and _event is InputEventJoypadMotion and (_event.is_action("left") or _event.is_action("right"))