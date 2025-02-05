class_name PlayerPanel extends PanelContainer


@onready var player_stuff: Label = %player_stuff
@onready var heart_container: HBoxContainer = %heart_container


var brawler_data:BrawlerData
var lives:Array[TextureRect] = []


func _ready() -> void:
	Signals.BrawlerDeath.connect(_brawler_death)


func setup_lives(texture:CompressedTexture2D, amount:int) -> void:
	if texture:
		for i in amount:
			var new:TextureRect = TextureRect.new()
			heart_container.add_child(new)
			if not new.is_node_ready(): await new.ready
			new.texture = texture
			new.size = Vector2(8, 8)
			new.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			lives.append(new)


func setup_color(color:Color = Color.BLACK) -> void:
	if color != Color.BLACK:
		player_stuff.modulate = color


func _brawler_death(_data:BrawlerData) -> void:
	if _data == brawler_data:
		var life:TextureRect = lives.pop_back()
		if life != null:
			life.hide()
			heart_container.remove_child.call_deferred(life)
			life.queue_free.call_deferred()


func _brawler_add_life(_data:BrawlerData) -> void:
	if _data == brawler_data:
		var life:TextureRect = lives[0].duplicate()
		heart_container.add_child(life)
		lives.append(life)

	