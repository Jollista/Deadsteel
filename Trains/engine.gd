extends PathFollow2D

# Max speed and current speed
@export var MAX_SPEED = 7.0
var SPEED = 0.0
# Acceleration for starting and stopping
@export var ACCELERATION = 0.05
var track_progress = 0.0

# true if train is stopping
var stopping = false

# manages train's movement along a path2D track
func _physics_process(_delta):
	print("Speed : ", SPEED)
	# moves self along Path2D
	if stopping:
		decelerate()
	else:
		accelerate()
	track_progress = get_progress() + SPEED
	set_progress(track_progress)
	#print("Progress : ", progress)

# decelerate to 0
func decelerate():
	SPEED = move_toward(SPEED, 0, ACCELERATION)

# accelerate to max_speed
func accelerate():
	SPEED = move_toward(SPEED, MAX_SPEED, ACCELERATION)

# toggle stopping, for player control purposes
func toggle_brake():
	stopping = !stopping
