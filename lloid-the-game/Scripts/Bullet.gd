extends Area2D
@onready var bulet_sprite = $"."
@export var speed = 250
@export var damage = 1
@export var speed_mult = 1.5
var paried = false
var direction = Vector2.ZERO
func _physics_process(delta):
	if paried == true:
		position += direction * speed * delta * speed_mult
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
		bulet_sprite.rotation=direction.angle()
		Engine.time_scale = 0.0
		await get_tree().create_timer(0.20, true, true, true).timeout
		Engine.time_scale = 1.0
	
	if area.is_in_group("player_hitbox"):
		area.get_parent().take_damage(damage)
		queue_free()
