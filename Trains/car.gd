extends PathFollow2D

# Max speed and current speed
@export var MAX_SPEED = 7.0
var SPEED = 0.0
# Acceleration for starting and stopping
@export var ACCELERATION = 0.05
var track_progress = 0.0

@onready var collider = $StaticBody2D/CollisionPolygon2D

# true if train is stopping
var stopping = false

# reference to player, initialized on player enter area2D
var player

# true if player is in area2D, else false
var player_can_board = false
# true if player is on board this car, else false
var player_on_board = false

# manage player input
func _process(_delta):
	manage_boarding()

# manage player boarding and exiting the train
func manage_boarding():
	# board if not already on board, can board, and interacting
	if !player_on_board and player_can_board and Input.is_action_just_pressed("interact"):
		collider.set_build_mode(collider.BUILD_SEGMENTS) # set build mode to segments to allow player inside
		player_on_board = true # update bool
		player.position = position # set player position to inside car
	
	# exit if on_board and interacting
	elif player_on_board and Input.is_action_just_pressed("interact"):
		collider.set_build_mode(collider.BUILD_SOLIDS) # set build mode to solids to eject player
		player_on_board = false # update bool

# decelerate to 0
func decelerate():
	SPEED = move_toward(SPEED, 0, ACCELERATION)

# accelerate to max_speed
func accelerate():
	SPEED = move_toward(SPEED, MAX_SPEED, ACCELERATION)

# toggle stopping, for player control purposes
func toggle_brake():
	stopping = !stopping

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_can_board = true
		player = body

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_can_board = false
