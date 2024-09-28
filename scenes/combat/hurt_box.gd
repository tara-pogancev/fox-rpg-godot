extends Area2D

const HitEffect = preload("res://scenes/hit_effect.tscn")

@onready var timer: Timer = $Timer

signal invincibility_started
signal invincibility_ended

var invincible = false:
	get: 
		return invincible
	set(value):
		invincible = value
		if invincible:
			emit_signal("invincibility_started")
		else:
			emit_signal("invincibility_ended")

func create_hit_effect() -> void:
	var hitEffect = HitEffect.instantiate()
	hitEffect.global_position = global_position
	get_tree().current_scene.add_child(hitEffect)

func stat_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_timer_timeout() -> void:
	self.invincible = false

func _on_invincibility_started() -> void:
	set_deferred("monitoring", false)

func _on_invincibility_ended() -> void:
	set_deferred("monitoring", true)
