extends KinematicBody2D


# Declare member variables here. Examples:
export (int) var Acceleration = 512
export (int) var MaxSpeed = 64
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
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_vector != Vector2.ZERO:
		motion += input_vector * Acceleration * delta
		motion = motion.clamped(MaxSpeed)
	else:
		motion = motion.linear_interpolate(Vector2.ZERO, Friction)

	motion = move_and_slide(motion)
