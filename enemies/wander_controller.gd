extends Node2D

@export var wander_range = 50

@onready var timer: Timer = $Timer
@onready var start_position = global_position
@onready var target_position = global_position

func _ready():
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	target_position = start_position + target_vector

func _on_timer_timeout() -> void:
	update_target_position()

func start_wander_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left
