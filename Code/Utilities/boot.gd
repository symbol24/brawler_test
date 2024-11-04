class_name Boot extends Node2D


const DATAMANAGER:String = "res://Scenes/Utilities/Managers/data_manager.tscn"


func _ready() -> void:
	Manager.load_manager(DATAMANAGER)
	SceneManager.load_scene("main_menu")

	queue_free()