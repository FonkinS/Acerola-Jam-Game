extends KinematicBody2D

const jumpHeight := 90
const jumpTime := 0.25
const moveSpeed := 300
const acceleration := 0.5
const deceleration := 0.5

var GRAVITY : int
var JUMP_STRENGTH : int

var velocity : Vector2

var coyoteTimer := 0.0
const coyoteTime := 0.3

var is_jumping := false

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
	
	if not is_jumping:
		if h_input == 0:
			$AnimationPlayer.play("Idle")
		else:
			$AnimationPlayer.play("Walk")
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyoteTimer > 0):
		is_jumping = true
		$AnimationPlayer.play("Jump")
		velocity.y = -JUMP_STRENGTH
	
	if is_on_floor():
		coyoteTimer = coyoteTime
	else:
		coyoteTimer -= delta
	
	if Input.is_action_just_pressed("drop"):
		set_collision_mask_bit(3, false)
		yield(get_tree().create_timer(0.1), "timeout")
		set_collision_mask_bit(3, true)
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_jump_finish():
	is_jumping = false
