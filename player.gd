extends CharacterBody2D

const SPEED = 150.0
const ACCELERATION = 10.0

func _physics_process(_delta):
	# Get input in all directions for top-down 8-directional movement
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	
	# if input, set velocity to speed in given directions
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else: # decelerate
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.y = move_toward(velocity.y, 0, ACCELERATION)

	move_and_slide()
