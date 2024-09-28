extends AnimatedSprite2D

func _ready() -> void:
	connect("animation_finished", Callable(self, "_on_animated_finished"))

func _on_animated_finished() -> void:
	queue_free()
