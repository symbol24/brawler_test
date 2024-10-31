class_name SWAttack extends AttackAction


const UPAXISNEEDED:float = -0.4
const DOWNAXISNEEDED:float = 0.7


@export var attack1_name:String
@export var attack2_name:String
@export var attack3_name:String

var delay:float
var current_attack:String = ""
var attack_active:bool = false
var attack_active_time:float = 0.0:
	set(value):
		attack_active_time = value
		if attack_active_time <= 0.0:
			attack_active = false
			_animation_ended(current_attack)
var sprite_x_pos:float


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(button):
		if Input.get_axis("up", "down") > DOWNAXISNEEDED:
			if attack2_name == "": Debug.warning("player ", parent.name, " attack2_name is empty.")
			delay = parent.data.get_attack_value(attack2_name, "post_attack_delay")
			_play_attack2(parent.data.get_attack_value(attack2_name, "state"), attack2_name)
		elif Input.get_axis("up", "down") < UPAXISNEEDED:
			if attack2_name == "": Debug.warning("player ", parent.name, " attack3_name is empty.")
			delay = parent.data.get_attack_value(attack3_name, "post_attack_delay")
			_play_attack3(parent.data.get_attack_value(attack3_name, "state"), attack3_name)

		else:
			if attack1_name == "": Debug.warning("player ", parent.name, " attack1_name is empty.")
			delay = parent.data.get_attack_value(attack1_name, "post_attack_delay")
			_play_attack1(parent.data.get_attack_value(attack1_name, "state"), attack1_name)


func _ready() -> void:
	super()
	if not parent.is_node_ready():
		await parent.ready
	parent.animator.animation_finished.connect(_animation_ended)
	sprite_x_pos = parent.sprite.position.x


func _process(delta: float) -> void:
	if attack_active: attack_active_time -= delta


func _play_attack1(_state:Brawler.State, _animation_name:String) -> void:
	if can_action:
		current_attack = attack1_name
		can_action = false
		parent.set_state(_state)
		parent.sprite.position.x = parent.data.get_attack_value(attack1_name, "x") if not parent.sprite.flip_h else -parent.data.get_attack_value(attack1_name, "x")
		if Debug.active: Signals.DebugUpdateBoxText.emit("attacks", "last attack: " + current_attack)


func _play_attack2(_state:Brawler.State, _animation_name:String):
	if can_action:
		current_attack = attack2_name
		can_action = false
		attack_active_time = parent.data.get_attack_value(attack2_name, "active_time")
		attack_active = true
		parent.set_state(_state)
		parent.can_move_on_x = parent.data.get_attack_value(attack2_name, "can_move_x")
		parent.sprite.position.x = parent.data.get_attack_value(attack2_name, "x") if not parent.sprite.flip_h else -parent.data.get_attack_value(attack2_name, "x")
		parent.set_velocity_y(parent.data.get_attack_value(attack2_name, "down_speed"))
		if Debug.active: Signals.DebugUpdateBoxText.emit("attacks", "last attack: " + attack2_name)


func _play_attack3(_state:Brawler.State, _animation_name:String):
	if can_action:
		current_attack = attack3_name
		can_action = false
		attack_active_time = parent.data.get_attack_value(attack3_name, "active_time")
		attack_active = true
		parent.set_state(_state)
		parent.sprite.position.x = parent.data.get_attack_value(attack3_name, "x") if not parent.sprite.flip_h else -parent.data.get_attack_value(attack3_name, "x")
		parent.set_velocity_y(-parent.data.get_attack_value(attack3_name, "up_speed"))
		if Debug.active: Signals.DebugUpdateBoxText.emit("attacks", "last attack: " + attack3_name)



func _animation_ended(anim:String) -> void:
	if anim in [attack1_name, attack2_name, attack3_name]:
		parent.cant_change_state = false
		parent.set_state(Brawler.State.IDLE)
		parent.sprite.position.x = sprite_x_pos if not parent.sprite.flip_h else -sprite_x_pos
		await get_tree().create_timer(delay).timeout
		can_action = true


func _animation_changed(old:String, _new:String) -> void:
	if old == attack1_name:
		can_action = true
