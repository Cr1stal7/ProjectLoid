extends Area2D

@export var speed = 250
@export var damage = 1
var paried = false
var direction = Vector2.ZERO

func _physics_process(delta):
	if paried == true:
		position += direction * speed * delta
	else:
		position += direction * speed * delta
func _ready():
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _on_Bullet_area_entered(area):
	print_debug("Popal")
	if area.is_in_group("player_hitbox"):
		area.get_parent().take_damage(damage)
		queue_free()

	


func _on_area_entered(area: Area2D) -> void:
	print_debug("Popal")
	if area.name == "Attack_Area":
		paried = true
		direction = (get_global_mouse_position() - global_position).normalized()
	
	if area.is_in_group("player_hitbox"):
		area.get_parent().take_damage(damage)
		queue_free()
