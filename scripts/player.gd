extends CharacterBody2D

const MAX_SPEED = 150
const ACCELERATION = 500
const FRICTION = 1000
const ROLL_SPEED = 1.5

enum {
	MOVE, 
	ROLL, 
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.RIGHT

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")
@onready var sword_hitbox: Area2D = $SwordHitbox


func _ready():
	animation_tree.active = true
	sword_hitbox.knockback_vector = roll_vector

func _physics_process(delta: float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		sword_hitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		animation_state.travel("Idle")
		velocity = Vector2.ZERO 
	
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state =  ROLL

func attack_state(delta):
	animation_state.travel("Attack")
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION/10 * delta)
	move_and_slide()

func roll_state(delta):
	animation_state.travel("Roll")
	velocity = velocity.move_toward(roll_vector * MAX_SPEED * ROLL_SPEED, delta * ACCELERATION )
	move_and_slide()
	
func roll_finished():
	state = MOVE
	
func attack_finished():
	state = MOVE
	
