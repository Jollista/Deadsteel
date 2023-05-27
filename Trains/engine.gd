extends PathFollow2D

@export var SPEED = 7.0
var track_progress = 0.0

func _physics_process(_delta):
	# moves self along Path2D
	track_progress = get_progress() + SPEED
	set_progress(track_progress)
	print("Progress : ", progress)
