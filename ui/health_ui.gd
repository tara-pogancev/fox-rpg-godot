extends Control

var hearts = 4
var max_hearts = 4

@onready var label: Label = $Label
@onready var heart_ui_empty: TextureRect = $"HeartUI empty"
@onready var heart_ui_full: TextureRect = $"HeartUI full"

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.size.x = hearts * 15

func set_max_health(value):
	max_hearts = max(value, 1)
	
func _ready() -> void:
	max_hearts = PlayerStats.max_health
	hearts = PlayerStats.health
	PlayerStats.health_changed.connect(set_hearts)
	if heart_ui_full != null:
		heart_ui_full.size.x = hearts * 15
	if heart_ui_empty != null:
		heart_ui_empty.size.x = max_hearts * 15	
	
