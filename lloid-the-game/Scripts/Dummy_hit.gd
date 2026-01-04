extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var hit_area = $Hit_Area
@export var fire_rate = 1.2
@export var bullet_scene: PackedScene

@onready var shoot_point = $ShootPoint
@onready var shoot_timer = $ShootTimer
var Enemy_Hp = 10
func _ready():
	shoot_timer.wait_time = fire_rate
	shoot_timer.start()

	
func shoot():
	print_debug("shot")
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
func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerAttack"):
		
		anim.play("hit_anim")
func _on_shoot_timer_timeout() -> void:
	shoot()
