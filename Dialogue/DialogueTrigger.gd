extends StaticBody2D

# true if the player is inside the area2d's collision shape; else, false
var player_in_range = false
# reference to player, initialized when player enters area2d's collision shape
var player

# reference to dialogue_canvas in the scene
@onready var dialogue_canvas = get_parent().get_node("DialogueCanvas")

func _ready():
	# connect signal from dialogue_canvas, dialogue_ended, to trigger dialogue_over when received
	dialogue_canvas.dialogue_ended.connect(dialogue_over)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		trigger_dialogue()

# choose a dialogue and then have dialogue_canvas start it
func trigger_dialogue():
	# stop checking for input for starting dialogue
	set_process(false)
	
	# choose a dialogue
	var dialogue = choose_dialogue()
	print("chose dialogue : ", dialogue)
	
	# start it
	dialogue_canvas.start_dialogue(dialogue)

func choose_dialogue():
	return "res://Dialogue/JSONs/Coal/WelcomeToDeephaven.json"

# called when signal received dialogue_ended
func dialogue_over():
	# start checking for input for starting dialogue again
	set_process(true)
	print("dialogue end signal received")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		player = body

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_range = true
