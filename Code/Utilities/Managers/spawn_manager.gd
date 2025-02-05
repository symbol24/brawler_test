class_name SpawnManager extends Node2D


@export var brawler_datas:Array[BrawlerData]

var spawn_points:Array[SpawnPoint] = []
var spawned_brawlers:Array[Brawler] = []


func _ready() -> void:
	Signals.SpawnPlayer.connect(_spawn_one_player)


func spawn_all_players() -> void:
	for each in Manager.mpm.players:
		_spawn_one_player(each) 


func respawn_player(_data:PlayerData) -> void:
	if _data.active_brawler.current_life_count > 0:
		await get_tree().create_timer(1).timeout
		_spawn_one_player(_data)


# TODO: Make sure to flush brawler data from the player data when ending a match
func _spawn_one_player(_data:PlayerData) -> void:
	if spawn_points.is_empty(): spawn_points = _get_spawn_points()
	var point:SpawnPoint = _get_spawn_point(_data.player_id)
	var brawler_data:BrawlerData
	if _data.active_brawler != null: brawler_data = _data.active_brawler
	else: brawler_data = _get_brawler_data_from_id(_data.brawler_id).get_duplicate()
		
	if brawler_data != null and point != null:
		_data.active_brawler = brawler_data
		var new_brawler:Brawler = load(brawler_data.path).instantiate()
		new_brawler.set_data(brawler_data, _data)
		new_brawler.data.setup_brawler()
		add_child(new_brawler)
		if not new_brawler.is_node_ready(): await new_brawler.ready
		new_brawler.global_position = point.global_position
		new_brawler.name = brawler_data.id + "_0"
		spawned_brawlers.append(new_brawler)
		new_brawler.set_state(Brawler.State.RESPAWN)
		Signals.BrawlerReady.emit(_data)
		#Debug.log("Brawler %s ready." % new_brawler.name)
	else:
		Debug.warning("Player with id %d and selected character %s not spawned due to missing Brawler Data." % [_data.player_id, _data.brawler_id])


func _get_spawn_points() -> Array[SpawnPoint]:
	var result:Array[SpawnPoint] = []
	var markers = get_tree().get_nodes_in_group("spawn_point")

	for m in markers:
		result.append(m as SpawnPoint)
	
	return result


func _get_spawn_point(_player_id:int) -> SpawnPoint:
	if spawn_points.is_empty(): 
		Debug.error("No spawn points in manager")
		return null

	for each in spawn_points:
		if each.player_id == _player_id: return each
	
	Debug.error("No spawn point found for player id: %d" % _player_id)
	return null


func _get_brawler_data_from_id(_id:String) -> BrawlerData:
	if brawler_datas.is_empty():
		Debug.error("No bralwer datas set in Spawn Manager")
		return null

	for each in brawler_datas:
		if each.id == _id: 
			return each
	
	Debug.error("No Braler Data found for id: %s" % _id)
	return null