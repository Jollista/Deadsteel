extends "res://Trains/car.gd"

# Max speed and current speed
@export var MAX_SPEED = 7.0
var SPEED = 0.0
# Acceleration for starting and stopping
@export var ACCELERATION = 0.05
var track_progress = 0.0

# decelerate to 0
func decelerate():
	SPEED = move_toward(SPEED, 0, ACCELERATION)

# accelerate to max_speed
func accelerate():
	SPEED = move_toward(SPEED, MAX_SPEED, ACCELERATION)

# toggle stopping, for player control purposes
func toggle_brake():
	# stop self
	stopping = !stopping
	
	# stop next_car if has next_car
	if next_car != null:
		next_car.toggle_brake()

# determine action based on stopping
func manage_speed():
	if stopping:
		decelerate()
	else:
		accelerate()

# update position of self and player if player_on_board
func update_position():
	# update position on track
	track_progress = get_progress() + SPEED
	set_progress(track_progress)
	
	# update player's position if on board
	if player != null and player_on_board:
		player.position = position
	
	# update tail's position
	update_next_car()

func car_action():
	determine_braking()
	manage_speed()

func determine_braking():
	if player_on_board and Input.is_action_just_pressed("car_action"):
		toggle_brake()
