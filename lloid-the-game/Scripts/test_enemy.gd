extends Node2D

@export var fire_rate = 1.2
@export var bullet_scene: PackedScene

@onready var shoot_point = $ShootPoint
@onready var shoot_timer = $ShootTimer

func _ready():
	shoot_timer.wait_time = fire_rate
	shoot_timer.start()

func _on_ShootTimer_timeout():
	shoot()
func shoot():
	if not is_instance_valid(get_player()):
		return

	var bullet = bullet_scene.instantiate()
	bullet.global_position = shoot_point.global_position

	var dir = (get_player().global_position - global_position).normalized()
	bullet.direction = dir

	bullet.rotation = dir.angle()

	get_tree().current_scene.add_child(bullet)
func get_player():
	return get_tree().get_first_node_in_group("player")
