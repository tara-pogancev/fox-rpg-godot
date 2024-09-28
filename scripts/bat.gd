extends CharacterBody2D

@onready var stats: Node = $Stats
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var acceleration = 300
@export var max_speed = 50
@export var friction = 200

const EnemyDeathEffect = preload("res://scenes/enemy_death_effect.tscn") 

enum {
	IDLE, 
	WANDER, 
	CHASE
}

var state = CHASE

func _physics_process(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		
		WANDER:
			pass
			
		CHASE: 
			var player = player_detection_zone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
			else:
				state = IDLE
			
	animated_sprite_2d.flip_h = velocity.x < 0
	move_and_slide()

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_hurt_box_area_entered(area) -> void:
	velocity = area.knockback_vector * 160
	stats.aply_damage(area.damage)
	
func _on_stats_no_health() -> void:
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)
	queue_free()
