extends KinematicBody2D


# Declare member variables here. Examples:
export (int) var Acceleration = 512
export (int) var MaxSpeed = 64
export (int) var Gravity = 200
export (int) var JumpForce = 128
export (int) var MaxSlopeAngle = 46
export (float) var Friction = 0.25

var motion = Vector2.ZERO
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(input_vector, delta)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
	move()

func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector

func apply_horizontal_force(input_vector, delta):
	if input_vector.x != 0:
		motion.x += input_vector.x * Acceleration * delta
		motion.x = clamp(motion.x, -MaxSpeed, MaxSpeed)

func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		motion.x = lerp(motion.x, 0, Friction)

func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JumpForce
	else:
		if Input.is_action_just_released("ui_up") and motion.y < -JumpForce/2:
			motion.y = -JumpForce/2

func apply_gravity(delta):
	if !is_on_floor():
		motion.y += Gravity * delta
		motion.y = min(motion.y, JumpForce)

func move():
	motion = move_and_slide(motion, Vector2.UP)
