class_name Jump extends BrawlerAction


const JUMPCHARGEDELAY:float = 0.5
const MINIMUMJUMPCHARGEVALUE:float = 0.0
const PRECHARGEDELAY:float = 0.2
const TIMETOPEAK:float = 0.3
const TIMETODESCEND:float = 0.3
const JUMPHEIGHT:float = 32.0
const JUMPCOUNT:int = 2


@export var coyote_delay:float = 0.3
@export var input_delay:float = 0.15
@export var use_charge:bool = false

var jump_available:bool:
	get: return current_jump_count > 0
var current_jump_count:int = 2:
	set(value):
		current_jump_count = value
		if Debug.active: Signals.DebugUpdateBoxText.emit(parent.player_data.player_id, "jump_count", "current_jump_count = %d" % current_jump_count)

var gravity:float:
	get: return (2*JUMPHEIGHT)/pow(TIMETOPEAK,2)
var fall_gravity:float:
	get: return (2*JUMPHEIGHT)/pow(TIMETODESCEND,2)
var jump_speed:float:
	get: return gravity * TIMETOPEAK

var active_coyote:bool = false
var coyote_timer:float = 0.0:
	set(value):
		coyote_timer = value
		if coyote_timer >= coyote_delay:
			_end_coyote_time()
var landed:bool = false
var jump_charge_percent:float = 0.0:
	set(value):
		jump_charge_percent = value if value <= 1.0 else 1.0
var jump_charging:bool = false
var active_input_delay:bool = false
var input_timer:float = 0.0:
	set(value):
		input_timer = value
		if input_timer >= input_delay: 
			_end_input_delay()
var precharge_timer:float = 0.0:
	set(value):
		precharge_timer = value
		if precharge_timer >= PRECHARGEDELAY:
			precharge_wait = false
			precharge_timer = 0.0
			jump_charging = true
var precharge_wait:bool = false


func _input(event: InputEvent) -> void:
	if _get_can_action(event):
		if use_charge:
			if parent.velocity.x != 0.0 and not precharge_wait and not jump_charging:
				if event.is_action_released(button):
					_trigger_action()
			else:
				if event.is_action_pressed(button):
					if not precharge_wait and not jump_charging:
						precharge_wait = true
				
					elif precharge_wait and not jump_charging:
						parent.set_state(Brawler.State.PREJUMP)
						jump_charging = true
				
				if event.is_action_released(button):
					jump_charging = false
					precharge_wait = false
					parent.can_move_on_x = true
					parent.cant_change_state = false
					_trigger_action()
		else:
			if event.is_action_pressed(button):
				parent.can_move_on_x = true
				parent.cant_change_state = false
				_trigger_action()


func _ready() -> void:
	super()
	jump_charge_percent = MINIMUMJUMPCHARGEVALUE


func _process(delta: float) -> void:
	if not parent.is_on_floor():
		parent.add_velocity_y(_get_gravity() * delta)
		if landed: active_coyote = true
		if parent.current_state != Brawler.State.FALL and parent.velocity.y > 0:
			parent.set_state(Brawler.State.FALL)
	
	if parent.is_on_floor() and not landed:
		_land()
	
	if active_coyote: coyote_timer += delta
	if active_input_delay: input_timer += delta
	if jump_charging: 
		jump_charge_percent += delta
		if  parent.can_move_on_x:
			parent.can_move_on_x = false
			parent.set_state(Brawler.State.PREJUMP)
		if Debug.active: Signals.DebugUpdateBoxText.emit(parent.player_data.player_id, "jump", "charging: %10.2f" % jump_charge_percent)
	if precharge_wait: precharge_timer += delta


func _trigger_action() -> void:
	if can_action and jump_available:
		can_action = false
		landed = false
		parent.set_state(Brawler.State.JUMP)
		var final_jump_speed:float = -jump_speed if not parent.is_on_floor() else -(jump_speed + (parent.data.extra_jump_height * jump_charge_percent))
		if Debug.active: Signals.DebugUpdateBoxText.emit(parent.player_data.player_id, "jump", "final jump speed: %10.2f" % final_jump_speed)
		parent.set_velocity_y(final_jump_speed)
		current_jump_count -= 1
		can_action = true
		jump_charge_percent = MINIMUMJUMPCHARGEVALUE


func _land() -> void:
	landed = true
	current_jump_count = JUMPCOUNT
	active_coyote = false
	coyote_timer = 0.0
	parent.set_state(Brawler.State.IDLE)


func _end_coyote_time() -> void:
	if landed:
		active_coyote = false
		coyote_timer = 0.0
		current_jump_count -= 1
		landed = false


func _end_input_delay() -> void:
	active_input_delay = false
	input_timer = 0.0


func _get_gravity() -> float:
	return gravity if parent.velocity.y >= 0.0 else fall_gravity
