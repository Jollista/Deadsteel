extends PathFollow2D

# Max speed and current speed
@export var MAX_SPEED = 7.0
var SPEED = 0.0
# Acceleration for starting and stopping
@export var ACCELERATION = 0.05
var track_progress = 0.0

# true if train is stopping
var stopping = false

var player
var player_can_board = false
var player_on_board = false

# manage player input
func _process(_delta):
	# board if not already on board, can board, and interacting
	if !player_on_board and player_can_board and Input.is_action_just_pressed("interact"):
		player_on_board = true
		player.position = position
	# exit if on_board and interacting
	elif player_on_board and Input.is_action_just_pressed("interact"):
		player_on_board = false

# manages train's movement along a path2D track
func _physics_process(_delta):	
	# manage speed
	if stopping:
		decelerate()
	else:
		accelerate()
	
	# update position on track
	track_progress = get_progress() + SPEED
	set_progress(track_progress)
	
	# update player's position if on board
	if player != null and player_on_board:
		player.position = position

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
