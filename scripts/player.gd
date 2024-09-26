extends CharacterBody2D

const MAX_SPEED = 150
const ACCELERATION = 500
const FRICTION = 1000

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")

func _physics_process(delta: float):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
	else:
		#velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animation_state.travel("Idle")
		velocity = Vector2.ZERO 
	
	move_and_slide()
	
