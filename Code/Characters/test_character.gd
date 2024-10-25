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
		}


@onready var animator: AnimationPlayer = %animator

var current_state:State = State.IDLE
var current_animation:String = ""

var to_flip:Array = []
var flipped:bool = false


func _ready() -> void:
	animator.animation_finished.connect(_animation_end)
	to_flip = _get_to_flip()


func _process(_delta: float) -> void:
	set_state(_update_state())
	flipped = _flip(to_flip, flipped)
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
	var new:State = State.NOTHING
	if velocity.x >= 0.1 or velocity.x <= -0.1:
		new = State.WALK
	
	if velocity.y <= -0.1:
		new = State.JUMP
	elif velocity.y >= 0.1:
		new = State.FALL
	
	return new


func set_state(new_state:State) -> void:
	current_state = new_state
	var prev_anim:String = current_animation
	match current_state:
		State.IDLE:
			if current_animation != "idle":
				current_animation = "idle"
		State.WALK:
			if current_animation != "walk":
				current_animation = "walk"
		State.JUMP:
			if current_animation != "jump":
				current_animation = "jump"
		State.FALL:
			if current_animation != "fall":
				current_animation = "fall"
		State.ATTACK1:
			if current_animation != "attack1":
				current_animation = "attack1"
		State.ATTACK2:
			if current_animation != "attack2":
				current_animation = "attack2"
		State.ATTACK3:
			if current_animation != "attack3":
				current_animation = "attack3"
		State.DEATH:
			if current_animation != "death":
				current_animation = "death"
		State.TELEPORTOUT:
			if current_animation != "teleport_out":
				current_animation = "teleport_out"
		State.RESPAWN:
			if current_animation != "respawn":
				current_animation = "respawn"
		_:
			if current_animation != "idle":
				current_animation = "idle"
	
	if current_animation != prev_anim:
		_set_animation(current_animation)


func _set_animation(anim_name:String) -> void:
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