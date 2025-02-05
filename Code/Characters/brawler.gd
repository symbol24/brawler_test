class_name Brawler extends CharacterBody2D


const RESPAWNIMMUNITYTIME:float = 3.0
const HITFLASHTIME:float = 0.15


enum State {
			NOTHING = -1,
			IDLE = 0,
			WALK = 1,
			JUMP = 2,
			FALL = 3,
			ATTACK1 = 4,
			ATTACK2 = 5,
			ATTACK3 = 6,
			DEATH = 7,
			TELEPORTOUT = 8,
			RESPAWN = 9,
			PREJUMP = 10,
			DASH = 11,
		}


@onready var sprite: Sprite2D = %sprite

@onready var animator: AnimationPlayer = %animator

var data:BrawlerData
var player_data:PlayerData

var active:bool = false
var current_state:State = State.IDLE:
	set(value):
		current_state = value
		if Debug.active: _debug_state_update()
var delayed_state_change:bool = false
var delayed_stated:State = State.NOTHING

var current_animation:String = ""
var direction:float = 0.0
var to_flip:Array = []
var flipped:bool = false

# Conditions
var can_change_state:bool = true
var can_move_on_x:bool = true
var can_move_on_y:bool = true
var can_move:bool = true
var can_flip:bool = true
var can_be_hit:bool = false


func _ready() -> void:
	can_be_hit = false
	Signals.BrawlerDeath.connect(_death)
	Signals.BrawlerHit.connect(_hit)
	if not animator.is_node_ready():
		await animator.ready
	animator.animation_finished.connect(_animation_ended)
	to_flip = _get_to_flip(self)


func _process(_delta: float) -> void:
	if delayed_state_change: _delayed_state_change()
	if can_flip: flipped = _flip(to_flip, flipped)
	if not can_move_on_x: velocity.x = 0.0
	if not can_move_on_y: velocity.y = 0.0
	if can_move:
		move_and_slide()


func set_data(_data:BrawlerData, _player_data:PlayerData) -> void:
	data = _data
	player_data = _player_data


func set_velocity_x(value:float = 0.0) -> void:
	if active:
		velocity.x = value


func add_velocity_x(value:float = 0.0) -> void:
	if active:
		velocity.x += value


func set_velocity_y(value:float = 0.0) -> void:
	if active:
		velocity.y = value


func add_velocity_y(value:float = 0.0) -> void:
	if active:
		velocity.y += value


func set_state(new_state:State) -> bool:
	if new_state == State.DEATH:
		if not can_change_state:
			delayed_state_change = true
			delayed_stated = new_state
			return can_change_state

	if can_change_state:
		current_state = new_state
		var prev_anim:String = current_animation
		match current_state:
			State.IDLE:
				if current_animation != "idle":
					current_animation = "idle"
			State.WALK:
				if current_animation != "walk":
					current_animation = "walk"
					can_flip = true
			State.PREJUMP:
				if current_animation != "prejump":
					current_animation = "prejump"
					can_flip = false
			State.JUMP:
				if current_animation != "jump":
					current_animation = "jump"
					can_flip = true
			State.FALL:
				if current_animation != "fall":
					current_animation = "fall"
					can_flip = true
			State.ATTACK1:
				if current_animation != "attack1":
					current_animation = "attack1"
					can_flip = false
			State.ATTACK2:
				if current_animation != "attack2":
					current_animation = "attack2"
					can_flip = false
			State.ATTACK3:
				if current_animation != "attack3":
					current_animation = "attack3"
					can_flip = false
			State.DEATH:
				if current_animation != "death":
					current_animation = "death"
					can_flip = false
			State.TELEPORTOUT:
				if current_animation != "teleport_out":
					current_animation = "teleport_out"
					can_change_state = false
					can_flip = false
			State.RESPAWN:
				if current_animation != "teleport_in":
					current_animation = "teleport_in"
					can_change_state = false
					can_flip = false
					get_tree().create_timer(data.spawn_in_delay).timeout.connect(_spawn_delay_end)
			State.DASH:
				if current_animation != "dash":
					current_animation = "dash"
					can_flip = false
			_:
				if current_animation != "idle":
					current_animation = "idle"
		
		if current_animation != prev_anim:
			_set_animation(current_animation)


	return can_change_state


func get_can_be_hit() -> bool:
	return data.is_alive and can_be_hit and active


func _set_animation(anim_name:String) -> void:
	#Debug.log("Animator received ", anim_name)
	animator.play(anim_name)


func _update_state() -> State:
	var new:State = current_state
	if not can_change_state:
		if is_on_floor() and (velocity.x >= 1 or velocity.x <= -1):
			new = State.WALK
		elif is_on_floor() and velocity.x < 0.1 and velocity.x > -0.1 and current_state != State.IDLE:
			new = State.IDLE
		
		if velocity.y <= -0.1:
			new = State.JUMP
		elif velocity.y >= 0.1:
			new = State.FALL
	
	return new


func _get_to_flip(_parent) -> Array:
	var result:Array = []
	var children = _parent.get_children()
	for child in children:
		if child.is_in_group("flip"):
			result.append(child)
		result.append_array(_get_to_flip(child))
	return result


func _flip(array:Array = [], is_flipped:bool = false) -> bool:
	var flip:bool = false
	if velocity.x > 0.1 and is_flipped:
		flip = true
	elif velocity.x < -0.1 and not is_flipped:
		flip = true

	if flip:
		for each in array:
			if each is Sprite2D:
				each.flip_h = !each.flip_h
			each.position.x = -each.position.x
		return !is_flipped
	
	return is_flipped


func _spawn_delay_end() -> void:
	can_change_state = false
	set_state(State.IDLE)
	active = true
	if data.current_life_count < data.starting_life:
		_respawn_immunity_flash(RESPAWNIMMUNITYTIME/0.3)
	else:
		can_be_hit = true


func _respawn_immunity_flash(_amount:float) -> void:
	var tween:Tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	var x:int = 0
	while x < _amount:
		tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.15)
		tween.tween_property(self, "modulate", Color.WHITE, 0.15)
		x += 1
	await get_tree().create_timer(RESPAWNIMMUNITYTIME).timeout
	can_be_hit = true


func _death(_brawler_data:BrawlerData) -> void:
	if _brawler_data == data:
		active = false
		set_state(State.DEATH)
		can_change_state = false
		can_move_on_x = false


func _hit(_brawler_data:BrawlerData) -> void:
	if _brawler_data == data:
		var tween:Tween = create_tween()
		tween.tween_property(self, "modulate", Color.RED, HITFLASHTIME)
		tween.tween_property(self, "modulate", Color.WHITE, HITFLASHTIME)


func _animation_ended(anim_name:String) -> void:
	match anim_name:
		"death":
			await get_tree().create_timer(1).timeout
			can_change_state = true
			set_state(State.TELEPORTOUT)
		"teleport_in":
			can_change_state = true
			set_state(State.IDLE)
		"teleport_out":
			Manager.spawn_manager.respawn_player(player_data)
			queue_free()
		_:
			pass


func _delayed_state_change() -> void:
	if can_change_state:
		set_state(delayed_stated)
		delayed_state_change = false
		delayed_stated = State.NOTHING


# DEBUG SECTION

func _debug_state_update() -> void:
	Signals.DebugUpdateBoxText.emit(player_data.player_id, "state", "State: " + State.keys()[current_state])