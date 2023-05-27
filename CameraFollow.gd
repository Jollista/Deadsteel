extends Camera2D

@onready var player = get_parent().get_node("Player")

# follows player's position if player exists
func _process(_delta):
	if player != null:
		position = player.position
