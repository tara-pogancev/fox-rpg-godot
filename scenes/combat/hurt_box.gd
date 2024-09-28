extends Area2D

@export var show_hit_effect: bool = true

const HitEffect = preload("res://scenes/hit_effect.tscn")

func _on_area_entered(area: Area2D) -> void:
	if show_hit_effect:
		var hitEffect = HitEffect.instantiate()
		hitEffect.global_position = global_position
		get_tree().current_scene.add_child(hitEffect)
