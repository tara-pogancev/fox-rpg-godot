extends Area2D

var player = null:
	get:
		return player
	set(value):
		player = value


func _on_body_entered(body: Node2D) -> void:
	player = body


func _on_body_exited(body: Node2D) -> void:
	player = null


func can_see_player() -> bool:
	return player != null
