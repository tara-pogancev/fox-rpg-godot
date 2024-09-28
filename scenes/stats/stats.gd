extends Node

@export var  max_health = 1
@onready var health = max_health 

signal no_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func aply_damage(dmg: int):
	health -= dmg
	print("doing dmg")
	if (health <= 0):
		print("help me")
		emit_signal("no_health")
	
	
