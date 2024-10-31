class_name Brawler extends CharacterBody2D


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
		}


@export var brawler_data:BrawlerData
@onready var sprite: Sprite2D = %sprite

@onready var animator: AnimationPlayer = %animator

var data:BrawlerData

var current_state:State = State.IDLE:
	set(value):
		current_state = value
		if Debug.active: _debug_state_update()
var cant_change_state:bool = false
var can_move_on_x:bool = true
var current_animation:String = ""

var to_flip:Array = []
var flipped:bool = false
var can_flip:bool = true


func _ready() -> void:
	data = brawler_data.get_duplicate()
	if not animator.is_node_ready():
		await animator.ready
	animator.animation_finished.connect(_animation_end)
	to_flip = _get_to_flip()


func _process(_delta: float) -> void:
	#set_state(_update_state())
	if can_flip: flipped = _flip(to_flip, flipped)
	if not can_move_on_x: velocity.x = 0
	move_and_slide()


func set_velocity_x(value:float = 0.0) -> void:
	velocity.x = value


func add_velocity_x(value:float = 0.0) -> void:
	velocity.x += value


func set_velocity_y(value:float = 0.0) -> void:
	velocity.y = value


func add_velocity_y(value:float = 0.0) -> void:
	velocity.y += value


func _update_state() -> State:
	var new:State = current_state
	if not cant_change_state:
		if is_on_floor() and (velocity.x >= 1 or velocity.x <= -1):
			new = State.WALK
		elif is_on_floor() and velocity.x < 0.1 and velocity.x > -0.1 and current_state != State.IDLE:
			new = State.IDLE
		
		if velocity.y <= -0.1:
			new = State.JUMP
		elif velocity.y >= 0.1:
			new = State.FALL
	
	return new


func set_state(new_state:State) -> void:
	if not cant_change_state:
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
					cant_change_state = true
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
					cant_change_state = true
					can_flip = false
			State.ATTACK2:
				if current_animation != "attack2":
					current_animation = "attack2"
					cant_change_state = true
					can_flip = false
			State.ATTACK3:
				if current_animation != "attack3":
					current_animation = "attack3"
					cant_change_state = true
					can_flip = false
			State.DEATH:
				if current_animation != "death":
					current_animation = "death"
					cant_change_state = true
					can_flip = false
			State.TELEPORTOUT:
				if current_animation != "teleport_out":
					current_animation = "teleport_out"
					cant_change_state = true
					can_flip = false
			State.RESPAWN:
				if current_animation != "respawn":
					current_animation = "respawn"
					cant_change_state = true
					can_flip = false
			_:
				if current_animation != "idle":
					current_animation = "idle"
		
		if current_animation != prev_anim:
			_set_animation(current_animation)


func _set_animation(anim_name:String) -> void:
	#Debug.log("Animator received ", anim_name)
	animator.play("RESET")
	animator.stop()
	animator.play(anim_name)


func _get_to_flip() -> Array:
	var result:Array = []
	var children = get_children()
	for child in children:
		if child.is_in_group("flip"):
			result.append(child)
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


func _animation_end(anim_name:String) -> void:
	match anim_name:
		"attack1":
			pass
		_:
			pass


func _get_state_as_string() -> String:
	var result:String = ""
	match current_state:
		State.IDLE:
			result = "IDLE"
		State.WALK:
			result = "WALK"
		State.PREJUMP:
			result = "PREJUMP"
		State.JUMP:
			result = "JUMP"
		State.FALL:
			result = "FALL"
		State.ATTACK1:
			result = "ATTACK1"
		State.ATTACK2:
			result = "ATTACK2"
		State.ATTACK3:
			result = "ATTACK3"
		State.DEATH:
			result = "DEATH"
		State.TELEPORTOUT:
			result = "TELEPORTOUT"
		State.RESPAWN:
			result = "RESPAWN"
		_:
			pass
	return result



# DEBUG SECTION

func _debug_state_update() -> void:
	Signals.DebugUpdateBoxText.emit("state", "State: " + _get_state_as_string())