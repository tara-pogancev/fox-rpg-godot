extends CharacterBody2D

@onready var stats: Node = $Stats
@onready var player_detection_zone: Area2D = $PlayerDetectionZone
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $HurtBox
@onready var soft_collision: Area2D = $SoftCollision
@onready var wander_controller: Node2D = $WanderController

@export var acceleration = 300
@export var max_speed = 50
@export var friction = 200

const EnemyDeathEffect = preload("res://effects/enemy_death_effect.tscn") 

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
			
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([WANDER, IDLE])
				wander_controller.start_wander_timer(randf_range(1, 3))
		
		WANDER:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([WANDER, IDLE])
				wander_controller.start_wander_timer(randf_range(1, 3))
				
			var direction = (global_position.direction_to(wander_controller.target_position))
			velocity = velocity.move_toward(direction * max_speed * 10, acceleration * delta)
			
			if global_position.distance_to(wander_controller.target_position) <= 5:
				state = pick_random_state([WANDER, IDLE])
				wander_controller.start_wander_timer(randf_range(1, 3))
				
		CHASE: 
			var player = player_detection_zone.player
			if player != null:
				var direction = (global_position.direction_to(player.global_position)).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
			else:
				state = IDLE
			
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
			
	animated_sprite_2d.flip_h = velocity.x < 0
	move_and_slide()

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurt_box_area_entered(area) -> void:
	velocity = area.knockback_vector * 160
	stats.aply_damage(area.damage)
	hurt_box.create_hit_effect()
	
func _on_stats_no_health() -> void:
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	enemyDeathEffect.global_position = global_position
	get_parent().add_child(enemyDeathEffect)
	queue_free()
