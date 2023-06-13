extends Area2D

@export var damage = 1
@export var speed = 1.0
@export var target : Vector2

@export var outer_bounds = 10000

var angle

func _ready():
	angle = position.angle_to_point(target)

# move to target at speed
func _physics_process(_delta):
	position.y += speed * sin(angle)
	position.x += speed * cos(angle)
	if position.x >= outer_bounds or position.x <= -outer_bounds or position.y >= outer_bounds or position.y <= -outer_bounds:
		queue_free()

# deal damage to enemies
func _on_body_entered(body):
	if body in get_tree().get_nodes_in_group("enemies"):
		body.take_damage(damage)
		queue_free()
