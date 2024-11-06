class_name AttackData extends Resource


@export var id:String
@export var state:Brawler.State
@export var post_attack_delay:float = 0.1
@export var can_move_x:bool = true
@export var x_offset:int
@export var damages:Array[Damage] = []
@export var has_move:bool = false
@export var move_speed:float
@export var move_active_time:float