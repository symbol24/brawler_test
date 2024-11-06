extends Node2D


const MAXPLAYERCOUNT:int = 2


@export var packe_data_manager:PackedScene

var data_manager:DataManager
var mpm:MultiplayerManager
var spawn_manager:SpawnManager

# load scenes that are not levels
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.StartMPM.connect(load_mpm)


func _process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		
		# When loading is complete in ResourceLoader, launch the _complete_load function.
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()


func load_mpm() -> void:
	if mpm == null:
		mpm = data_manager.packed_multiplayer_manager.instantiate()
		add_child(mpm)
		mpm.name = "mpm"
	else:
		Signals.MPMReady.emit()


func load_and_return_spawn_manager() -> SpawnManager:
	if spawn_manager != null:
		spawn_manager = null
	spawn_manager = data_manager.packed_spawn_manager.instantiate()
	return spawn_manager
	

func load_manager(_path:String = "") -> void:
	# Starting the ResourceLoader.
	to_load = _path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)


func _complete_load() -> void:
	is_loading = false

	var new_scene := ResourceLoader.load_threaded_get(to_load)
	var new = new_scene.instantiate()

	add_child.call_deferred(new)

	if new is DataManager:
		data_manager = new
		Debug.log("Data manager loaded")
	elif new is SpawnManager:
		spawn_manager = new
		Debug.log("Spawn manager loaded")
