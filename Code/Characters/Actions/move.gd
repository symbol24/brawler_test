class_name Move extends CharacterAction


@export var friction:float = 700
@export var acceleration:float = 1100
@export var speed:float = 200

var direction:float = 0.0


func _process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	parent.set_velocity_x(_get_new_x(parent.velocity.x, direction, delta))


func _get_new_x(_old_x:float = 0.0, _input:float = 0.0, delta:float = 0.0) -> float:
	var new_x:float = _old_x
	var air_multi:float = 0.6 if parent.velocity.y >= 0.1 else 1.0

	if _input > 0.1 or _input < -0.1:
		new_x = move_toward(_old_x, _input * speed * air_multi, delta * acceleration)
	elif _input < 0.1 and _input > -0.1:
		new_x = move_toward(_old_x, 0, delta * acceleration)

	return new_x