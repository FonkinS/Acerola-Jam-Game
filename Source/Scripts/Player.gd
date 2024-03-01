extends KinematicBody2D

const jumpHeight := 128
const jumpTime := 0.25
const moveSpeed := 400
const acceleration := 0.5
const deceleration := 0.5

var GRAVITY : int
var JUMP_STRENGTH : int

var velocity : Vector2

var coyoteTimer := 0.0
const coyoteTime := 0.3

func _ready():
	GRAVITY = (2 * jumpHeight) / pow(jumpTime, 2)
	JUMP_STRENGTH = (2 * jumpHeight) / jumpTime


func _physics_process(delta):
	velocity.y += GRAVITY * delta
	
	var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if h_input == 0:
		velocity.x = lerp(velocity.x, h_input * moveSpeed, 1 / deceleration * delta * 4.75)
	else:
		velocity.x = lerp(velocity.x, h_input * moveSpeed, 1 / acceleration * delta * 4.75)
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyoteTimer > 0):
		velocity.y = -JUMP_STRENGTH
	
	if is_on_floor():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
