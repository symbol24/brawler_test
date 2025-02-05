class_name Dash extends BrawlerAction


const DASHTIME:float = 0.25
const DASHSPEED:float  = 400.0


var dashing:bool = false
var dash_time:float = DASHTIME
var dash_timer:float = dash_time:
	set(value):
		dash_timer = value
		if dash_timer <= 0.0:
			dash_timer = dash_time
			_end_dash()


func _ready() -> void:
	super()
	action_timer = delay_input + dash_time
	if not parent.is_node_ready(): await parent.ready
	dash_time = parent.animator.get_animation("dash").length


func _process(delta: float) -> void:
	super(delta)
	if dashing: dash_timer -= delta

 
func _trigger_action() -> void:
	if parent.set_state(Brawler.State.DASH):
		parent.can_move_on_y = false
		parent.can_change_state = false
		parent.can_be_hit = false
		can_action = false
		dashing = true
		action_timer = delay_input + dash_time
		var speed:float = DASHSPEED
		if parent.velocity.x != 0.0 and parent.direction < 0.0: speed = -DASHSPEED
		elif parent.velocity.x == 0.0:
			speed = -DASHSPEED if parent.sprite.flip_h else DASHSPEED
		parent.set_velocity_x(speed)
		#Debug.log("trigger dash")


func _end_dash() -> void:
	#Debug.log("end dash")
	dashing = false
	parent.can_move_on_y = true
	parent.can_change_state = true
	parent.can_be_hit = true
	parent.set_state(Brawler.State.IDLE)
