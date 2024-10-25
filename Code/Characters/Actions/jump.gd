class_name Jump extends CharacterAction


@export var jump_count:int = 2
@export var time_to_peak:float = 0.3
@export var time_to_descend:float = 0.5
@export var jump_height:int = 32
@export var coyote_delay:float = 0.3
@export var input_delay:float = 0.15

var jump_available:bool:
	get:
		return current_jump_count > 0
var current_jump_count:int = 2:
	set(value):
		current_jump_count = value
		print("current_jump_count = ", current_jump_count)
var gravity:float
var fall_gravity:float
var jump_speed:float

var active_coyote:bool = false
var coyote_timer:float = 0.0:
	set(value):
		coyote_timer = value
		if coyote_timer >= coyote_delay:
			_end_coyote_time()

var landed:bool = false

var active_input_delay:bool = false
var input_timer:float = 0.0:
	set(value):
		input_timer = value
		if input_timer >= input_delay: 
			_end_input_delay()

func _input(_event: InputEvent) -> void:
	if can_action and not active_input_delay and _event.is_action_pressed("jump"):
		print("Detecting jump input!")
		_jump()
		can_action = false
	
	if not can_action and _event.is_action_released("jump"):
		can_action = true



func _ready() -> void:
	super()
	current_jump_count = jump_count
	gravity = (2*jump_height)/pow(time_to_peak,2)
	fall_gravity = (2*jump_height)/pow(time_to_descend,2)
	jump_speed = gravity * time_to_peak


func _process(_delta: float) -> void:
	if not parent.is_on_floor():
		parent.add_velocity_y(_get_gravity() * _delta)
		if landed: active_coyote = true
	
	if parent.is_on_floor() and not landed:
		_land()
	
	if active_coyote: coyote_timer += _delta
	if active_input_delay: input_timer += _delta


func _jump() -> void:
	if jump_available:
		print("in jump current_jump_count = ", current_jump_count)
		landed = false
		parent.set_velocity_y(-jump_speed)
		current_jump_count -= 1


func _land() -> void:
	print("landed")
	landed = true
	current_jump_count = jump_count
	active_coyote = false
	coyote_timer = 0.0


func _end_coyote_time() -> void:
	if landed:
		active_coyote = false
		coyote_timer = 0.0
		print("coyote time updating stuff")
		current_jump_count -= 1
		landed = false


func _end_input_delay() -> void:
	active_input_delay = false
	input_timer = 0.0


func _get_gravity() -> float:
	return gravity if parent.velocity.y >= 0.0 else fall_gravity