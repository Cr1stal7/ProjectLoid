extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var Atc_anim = $Attack_Area/AnimatedSprite2D
@onready var attack_area = $Attack_Area
@onready var attack_shape = $Attack_Area/CollisionShape2D
@onready var combo_timer = $combo_timer
@export var walk_speed := 180.0
@export var sprint_multiplier := 1.6
@export var Attack_Distance := 20
var Attack_variance = 1
var running = false
var is_attacking = false
var last_dir := "down"
var aim_dir := Vector2.DOWN
func _ready() -> void:
	Atc_anim.play("idle")
func _physics_process(_delta):
	
	var dir = Vector2(
		Input.get_action_strength("right_walk") - Input.get_action_strength("left_walk"),
		Input.get_action_strength("down_walk") - Input.get_action_strength("up_walk")
	).normalized()
	var speed := walk_speed
	
	if Input.is_action_pressed("Sprint"):
		speed *= sprint_multiplier
		running = true
	if is_attacking == false:
		velocity = dir * speed
		move_and_slide()
	if dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				$AnimatedSprite2D.flip_h = false
				last_dir = "right"
			else:
				$AnimatedSprite2D.flip_h = true
				last_dir = "right"
		elif dir.x > 0 and dir.y > 0:
			$AnimatedSprite2D.flip_h = false
			last_dir = "down_right"
		elif dir.x > 0 and dir.y < 0:
			$AnimatedSprite2D.flip_h = false
			last_dir = "up_right"
		elif dir.x < 0 and dir.y > 0:
			$AnimatedSprite2D.flip_h = true
			last_dir = "down_right"
		elif dir.x < 0 and dir.y < 0:
			$AnimatedSprite2D.flip_h = true
			last_dir = "up_right"
		else:
			last_dir = "down" if dir.y > 0 else "up"
		if running != false:
			anim.play("run_" + last_dir)
		else:
			anim.play("walk_" + last_dir)
		
	
	else:
		anim.play("idle")
	running = false
	aim_dir = (get_global_mouse_position() - global_position).normalized()
	if Input.is_action_just_pressed("Attack") and is_attacking == false:
		attack()
func attack():
	is_attacking = true
	if Attack_variance == 1:
		attack_area.position = aim_dir * Attack_Distance
		combo_timer.start()
		attack_shape.disabled = true
		await get_tree().process_frame#atack area reload
		attack_shape.disabled = false
		attack_area.rotation = aim_dir.angle()
		Atc_anim.play("Attack_1")
		attack_area.monitorable = true
		await get_tree().create_timer(0.12).timeout
		attack_shape.disabled = true
		attack_area.monitorable = false
		is_attacking = false
		Attack_variance += 1
	elif Attack_variance == 2:
		combo_timer.start()
		Atc_anim.play("Attack_2")
		Attack_variance += 1
		await get_tree().create_timer(0.12).timeout
		is_attacking = false
	else:
		combo_timer.start()
		Atc_anim.play("Attack_3")
		Attack_variance = 1
		await get_tree().create_timer(0.12).timeout
		is_attacking = false
		


func _on_combo_timer_timeout() -> void:
	Attack_variance = 1
	
	
	pass # Replace with function body.
