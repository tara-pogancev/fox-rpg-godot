extends CharacterBody2D

@onready var stats: Node = $Stats

const EnemyDeathEffect = preload("res://scenes/enemy_death_effect.tscn") 

enum {
	IDLE, 
	WANDER, 
	CHASE
}

var state = IDLE

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	move_and_slide()

func _on_hurt_box_area_entered(area) -> void:
	velocity = area.knockback_vector * 160
	stats.aply_damage(area.damage)
	
func _on_stats_no_health() -> void:
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)
	queue_free()
