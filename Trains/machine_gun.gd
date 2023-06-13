extends "res://Trains/car.gd"

# variables that determine 
@export var damage = 1.0
@export var spread = 1.0
@export var num_bullets = 1
@export var speed = 15.0
@export var size = 1.0
@export var rate_of_fire = 10
@onready var gun_delay = $GunDelay

# reference to bullet tscn
var Bullet = preload("res://Objects/bullet.tscn")

# shoot guys
func car_action():
	aim()

# shoot a bullet at the mouse position while car_action is held down
func aim():
	animate_crosshairs()
	if player_on_board:
		var mouse_pos = get_global_mouse_position()
		while Input.is_action_pressed("car_action") and gun_delay.is_stopped():
			print("Mouse position: ", mouse_pos)
			for i in num_bullets:
				fire(mouse_pos) # fire at mouse position num_bullets times
			gun_delay.start(1.0/rate_of_fire) # start delay between shots

# create a bullet that moves at bullet_speed to
func fire(target):
	target = get_actual_target(target)
	create_bullet(target)
	pass

# create an instance of a bullet and return a reference to it
func create_bullet(target, bullet_damage=damage, bullet_speed=speed, bullet_size=size):
	# create new TempSpike instance
	var bullet_instance = Bullet.instantiate()
	bullet_instance.target = target
	
	# initialize it
	bullet_instance.position = $StaticBody2D.global_position
	bullet_instance.apply_scale(Vector2(bullet_size, bullet_size))
	bullet_instance.damage = bullet_damage
	bullet_instance.speed = bullet_speed
	
	# add bullet_instance to scene
	get_parent().call_deferred("add_child", bullet_instance)
	
	# return bullet_instance
	return bullet_instance

# factors in spread to return absolute target
func get_actual_target(target):
	return target
	pass

# place crosshairs onto mouse position when in this car
func animate_crosshairs():
	if player_on_board:
		$Crosshair.set_deferred("visible", true)
		$Crosshair.set_position(get_local_mouse_position())
	else:
		$Crosshair.set_deferred("visible", false)


func _on_gun_delay_timeout():
	print("Ready to fire!")
