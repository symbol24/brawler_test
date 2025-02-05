class_name Boot extends Node2D


const DATAMANAGER:String = "res://Scenes/Utilities/Managers/data_manager.tscn"


func _ready() -> void:
	Signals.ManagerReady.connect(_manager_loaded)
	Manager.load_manager(DATAMANAGER)


func _manager_loaded(_id:String) -> void:
	if _id == "data_manager":
		SceneManager.load_scene("main_menu")

		queue_free()