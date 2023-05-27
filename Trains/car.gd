extends PathFollow2D

# distance between cars
@export var DISTANCE = 10.0

@onready var collider = $StaticBody2D/CollisionPolygon2D

# true if train is stopping
var stopping = true

# reference to player, initialized on player enter area2D
var player

# true if player is in area2D, else false
var player_can_board = false
# true if player is on board this car, else false
var player_on_board = false

# reference to next car in line
@export var next_car : PathFollow2D

# initialize next_car positions
func _ready():
	update_next_car()

# manage player input
func _process(_delta):
	manage_boarding()

# manages train's movement along a path2D track
func _physics_process(_delta):
	# update position on track
	update_position()
	
	# perform car specific action
	car_action()

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

# update position of self and player if player_on_board
func update_position():
	# update tail's position
	update_next_car()

func update_next_car():
	if next_car != null:
		next_car.set_progress(get_progress() - DISTANCE)
		next_car.update_position()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_can_board = true
		player = body

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_can_board = false

func car_action():
	pass
