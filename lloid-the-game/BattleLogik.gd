extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var Atc_anim = $Attack_Area/AnimatedSprite2D
@onready var attack_area = $Attack_Area
@onready var attack_shape = $Attack_Area/CollisionShape2D
@onready var combo_timer = $combo_timer
@onready var AttackTimer = $AttackCooldown
@onready var scythe_shapr = $Scythe/CollisionShape2D
@onready var scythe_area = $Scythe
@onready var scythe_anim=$Scythe/AnimatedSprite2D
@onready var scythe_timer_attack=$Scythe_attack_timer
@onready var scythe_timer_dash=$Scythe_dash_timer
@onready var hitbox=$Hitbox
@onready var Hero_Hp=$TextureProgressBar
@export var knockback = -80
@export var walk_speed := 180.0
@export var sprint_multiplier := 1.6
@export var Attack_Distance := 20
var weapon = 1
var Dashing = false
var Attack_variance = 1
var running = false
var is_attacking = false
var last_dir := "down"
var aim_dir := Vector2.DOWN
var aim_dir_temp := Vector2.DOWN
const Max_Frames = 300
var history:Array=[]
var is_rewinding := false
func _ready() -> void:
	Atc_anim.play("idle")
func _physics_process(_delta):
	update_look_from_movement()
	var dir = Vector2(
		Input.get_action_strength("right_walk") - Input.get_action_strength("left_walk"),
		Input.get_action_strength("down_walk") - Input.get_action_strength("up_walk")
	).normalized()
	var speed := walk_speed
	if Dashing ==true:
		velocity = aim_dir_temp * 500
		move_and_slide()
	#if Input.is_action_pressed("Sprint"):
	#	speed *= sprint_multiplier
	#	running = true
	if is_attacking == false and is_rewinding == false:
		velocity = dir * speed
		move_and_slide()
		
		
	if Input.is_action_pressed("rewind"):
		is_rewinding = true
	else:
		is_rewinding = false

	if is_rewinding:
		rewind_state()
		rewind_state()
		return

	record_state()
	
	
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
	if Input.is_action_just_pressed("Attack") and is_attacking == false:
		attack()
	
func update_look_from_movement():
	if velocity.length()>0:
		aim_dir = velocity.normalized()
func record_state():
	history.push_back({
		"pos": global_position,
		"vel": velocity,
		"rot": rotation,
		"anim": anim.animation,
		"frame": anim.frame,
		"flip_h": anim.flip_h,
		"Hp": Hero_Hp.value
	})

	if history.size() > Max_Frames:
		history.pop_front()
func rewind_state():
	if history.is_empty():
		return

	var state = history.pop_back()
	global_position = state.pos
	velocity = state.vel
	rotation = state.rot
	Hero_Hp.value = state.Hp
	anim.play(state.anim)
	anim.frame = state.frame
	anim.flip_h = state.flip_h
	anim.pause()
	
func attack():
	is_attacking = true
	AttackTimer.start()
	if Attack_variance == 1:
		Dashing = true
		aim_dir_temp = velocity.normalized()
		combo_timer.start()
		scythe_timer_dash.start()
		scythe_timer_attack.start()
		Attack_variance += 1
		
	elif Attack_variance == 2:
		scythe_area.position = aim_dir * Attack_Distance
		scythe_shapr.disabled = true
		await get_tree().process_frame#atack area reload
		scythe_shapr.disabled = false
		scythe_area.rotation = aim_dir.angle()
		scythe_area.monitorable = true
		await get_tree().create_timer(0.12).timeout
		scythe_shapr.disabled = true
		scythe_area.monitorable = false
		combo_timer.start()
		scythe_anim.play("Attack_sythe")
		Attack_variance += 1
		await get_tree().create_timer(0.12).timeout
	else:
		combo_timer.start()
		scythe_anim.play("Attack_sythe")
		Attack_variance = 1
		await get_tree().create_timer(0.12).timeout
		scythe_shapr.shape.radius = 32.0
		scythe_area.position = global_position.normalized()
		scythe_shapr.disabled = true
		await get_tree().process_frame#atack area reload
		scythe_shapr.disabled = false
		scythe_area.rotation = aim_dir.angle()
		scythe_area.monitorable = true
		await get_tree().create_timer(0.12).timeout
		scythe_shapr.disabled = true
		scythe_area.monitorable = false
		scythe_shapr.shape.radius = 22
		

func _on_combo_timer_timeout() -> void:
	Attack_variance = 1
	
	
func _on_scythe_dash_timer_timeout() -> void:
	Dashing = false
	
	
	
func _on_scythe_attack_timer_timeout() -> void: 
	scythe_area.position = aim_dir * Attack_Distance
	scythe_shapr.disabled = true
	await get_tree().process_frame#atack area reload
	scythe_shapr.disabled = false
	scythe_area.rotation = aim_dir.angle()
	scythe_anim.play("Attack_sythe")
	scythe_area.monitorable = true
	await get_tree().create_timer(0.12).timeout
	scythe_shapr.disabled = true
	scythe_area.monitorable = false


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		Hero_Hp.value-=10
	if Hero_Hp.value==0 or Hero_Hp.value<0:
		queue_free()
		
		
func _on_attack_cooldown_timeout() -> void:
	is_attacking = false
