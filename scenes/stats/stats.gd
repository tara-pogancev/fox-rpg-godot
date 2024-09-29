extends Node

@export var max_health = 1
@onready var health = max_health
@onready var timer: Timer = $Timer

var Player = preload("res://player/player.tscn")

signal no_health
signal health_changed


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func aply_damage(dmg: int):
	health -= dmg
	emit_signal("health_changed", health)
	if health <= 0:
		on_death()


func on_death():
	emit_signal("no_health")
	if timer != null:
		timer.start(2)


func _on_timer_timeout() -> void:
	# Respawn player
	health = max_health
	emit_signal("health_changed", health)

	get_tree().reload_current_scene()
