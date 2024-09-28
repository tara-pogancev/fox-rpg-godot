extends AudioStreamPlayer

@onready var player_stats: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stats.no_health.connect(play_sound)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_sound():
	play()
