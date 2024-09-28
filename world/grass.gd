extends Node2D

const GrassEffect = preload("res://effects/grass_effect.tscn") 

func _on_hurt_box_area_entered(area: Area2D) -> void:
	var grassEffect = GrassEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()
