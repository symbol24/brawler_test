class_name DataManager extends Node2D


@export_category("UI")
@export var player_ui:PackedScene
@export var player_ready_label:PackedScene
@export var player_panel:PackedScene


@export_category("Levels")
@export var packed_spawn_manager:PackedScene
@export var packed_multiplayer_manager:PackedScene


@export_category("Brawlers")
@export var brawlers:Array[PackedScene]
var instanciated_brawlers:Array[Brawler] = []