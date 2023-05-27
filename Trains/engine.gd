extends "res://Trains/car.gd"

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
