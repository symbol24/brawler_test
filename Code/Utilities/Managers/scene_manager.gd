extends Node2D


@export var levels:LevelData

var active_level:Level
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []


func _ready() -> void:
	# Process mode is set to "always" through code
	process_mode = PROCESS_MODE_ALWAYS

	if levels == null: push_error("Level data in scene manager is not set.")


func _process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		
		# When loading is complete in ResourceLoader, launch the _complete_load function.
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()
	

func load_scene(_id:String = "") -> void:
	# Send loadscreen toggle on
	Signals.ToggleLoadingScreen.emit(true)
	get_tree().paused = true
	
	# If path is empty, dont try to load.
	var path:String = levels.get_level_path(_id)
	if path == "":
		Debug.error("Path to load is empty.")
		return
	
	# Starting the ResourceLoader.
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)


func clear_active_level() -> void:
	if active_level != null:
		active_level.queue_free()
		active_level = null
		

func _complete_load() -> void:
	is_loading = false

	# Get the new level from the ResourceLoader and instantiate it.
	var new_scene := ResourceLoader.load_threaded_get(to_load)
	var new = new_scene.instantiate() as Level
	# If there is an active level, queue_free it.
	if active_level != null: 
		var temp := active_level
		remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()

	active_level = new

	add_child.call_deferred(new)
	
	if not new.is_node_ready():
		await new.ready
	
	get_tree().paused = false
	Signals.SceneLoadingComplete.emit(new)
