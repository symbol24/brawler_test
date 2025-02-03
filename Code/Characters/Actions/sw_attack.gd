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
	if _get_can_action(event) and event.is_action_pressed(button):
		if Input.get_axis("up", "down") > DOWNAXISNEEDED:
			if attack2_name == "": Debug.warning("player ", parent.name, " attack2_name is empty.")
			else: _play_attack(attack2_name)
		elif Input.get_axis("up", "down") < UPAXISNEEDED:
			if attack3_name == "": Debug.warning("player ", parent.name, " attack3_name is empty.")
			else: _play_attack(attack3_name)

		else:
			if attack1_name == "": Debug.warning("player ", parent.name, " attack1_name is empty.")
			else: _play_attack(attack1_name)


func _ready() -> void:
	super()
	if not parent.is_node_ready():
		await parent.ready
	parent.animator.animation_finished.connect(_animation_ended)
	sprite_x_pos = parent.sprite.position.x


func _process(delta: float) -> void:
	if attack_active: attack_active_time -= delta


func _play_attack(_attack_name:String) -> void:
	if can_action:
		var attack_data:AttackData = parent.data.get_attack_by_id(_attack_name)
		if attack_data:
			can_action = false
			delay = attack_data.post_attack_delay
			parent.set_state(attack_data.state)
			parent.can_change_state = false
			parent.sprite.position.x = attack_data.x_offset if not parent.sprite.flip_h else -attack_data.x_offset
			if attack_data.has_move:
				attack_active_time = attack_data.move_active_time
				attack_active = true
				parent.set_velocity_y(attack_data.move_speed)

			if Debug.active: Signals.DebugUpdateBoxText.emit(parent.player_data.player_id, "attacks", "last attack: " + current_attack)
		else:
			Debug.error("No attack found for id %s." % _attack_name)


func _animation_ended(anim:String) -> void:
	if anim in [attack1_name, attack2_name, attack3_name]:
		parent.sprite.position.x = sprite_x_pos if not parent.sprite.flip_h else -sprite_x_pos
		parent.can_change_state = true
		parent.set_state(Brawler.State.IDLE)
		get_tree().create_timer(delay).timeout.connect(_end_action)


func _end_action() -> void:
	can_action = true
