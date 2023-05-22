extends CharacterBody2D


const SPEED = 150.0
const ACCELERATION = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(_delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		print("Velocity : ", velocity)
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.y = move_toward(velocity.y, 0, ACCELERATION)

	move_and_slide()
