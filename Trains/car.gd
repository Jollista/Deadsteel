extends PathFollow2D

# distance between cars
@export var DISTANCE = 130.0

@onready var collider = $StaticBody2D/CollisionPolygon2D

@onready var board_area = $Area2D

# true if train is stopping
var stopping = true

# reference to player, initialized on player enter area2D
var player
signal player_found

# true if player is in area2D, else false
var player_can_board = false
# true if player is on board this car, else false
var player_on_board = false

# true if player can hop from this car to another, else false
var player_can_hop = true
# cooldown for car-hopping
@export var hop_delay = 0.1
@onready var timer = $Timer

# reference to next car in line (toward caboose)
@export var next_car : PathFollow2D
# reference to previous car in line (toward engine)
@export var prev_car : PathFollow2D

# initialize next_car positions
func _ready():
	# connect area2D signals to relevant functions
	board_area.body_entered.connect(_on_area_2d_body_entered)
	board_area.body_exited.connect(_on_area_2d_body_exited)
	# update next_car's initial position
	update_next_car()

# manage player input
func _process(_delta):
	manage_boarding()
	manage_car_hopping()

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
		board()
	
	# exit if on_board and interacting
	elif player_on_board and Input.is_action_just_pressed("interact"):
		exit()

# board train car
func board():
	collider.set_build_mode(collider.BUILD_SEGMENTS) # set build mode to segments to allow player inside
	player.position = position # set player position to inside car
	player_on_board = true # update bool
	
	# on board, wait a delay until player can hop again
	player_can_hop = false
	timer.start(hop_delay)
	await timer.timeout
	player_can_hop = true

# exit train car
func exit():
	collider.set_build_mode(collider.BUILD_SOLIDS) # set build mode to solids to eject player
	player_on_board = false # update bool

# manage moving between cars
func manage_car_hopping():
	# if can't hop, return
	if !player_can_hop:
		return
	
	# if player is on board, and input left, hop to next_car
	if player_on_board and Input.is_action_just_pressed("left"):
		hop_to(next_car)
	# else if player on board, and input right, hop to prev_car
	elif player_on_board and Input.is_action_just_pressed("right"):
		hop_to(prev_car)

func hop_to(target_car):
	# do not hop to null car
	if target_car != null:
		print("Hopping to car ", target_car.name, " from ", name)
		# exit car
		exit()
		# ensure player reference is non-null in target car
		target_car.initialize_player(player)
		# board
		target_car.board()
	else: 
		print("Cannot hop to null car")

# update position of self and player if player_on_board
func update_position():
	# update player's position if on board
	if player != null and player_on_board:
		player.position = position
	
	# update tail's position
	update_next_car()

# update the position of next_car
func update_next_car():
	if next_car != null:
		next_car.set_progress(get_progress() - DISTANCE)
		next_car.update_position()

# track whether or not player is in range to board
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print("Player can board ", name)
		player_can_board = true
		initialize_player(body)

# initialize reference to player
func initialize_player(body):
	# initialize player
	player = body

# track whether or not player is in range to board
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		print("Player OOR of ", name)
		player_can_board = false

# unique car action to be implemented in each unique car's script
func car_action():
	pass
