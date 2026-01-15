extends CharacterBody2D
@export var swing_curve: Curve
@onready var attack_pivot := $Attackpivot
@onready var attack_area := $Attackpivot/Area2D
@onready var timer := $Attack_Timer
@export var preferred_distance := 100.0
@export var tolerance := 20.0
@export var move_speed := 30.0
@onready var player = get_tree().get_first_node_in_group("player") as Node2D
var is_attacking = false
var attack_timer_started = false
var to_player = Vector2.DOWN
var dash_attack_vector = Vector2.DOWN
var is_dash_atk = false
var attack_time := 0.5
var dash_time := 0.7
var attack_angle := deg_to_rad(140)

func _ready():
	
	swing_attack()
	
func _physics_process(_delta: float) -> void:
	if not player:
		return
	to_player = player.global_position - global_position
	if is_attacking == false:
		if attack_timer_started == false:
			attack_timer_started = true
			start_random_timer()
		var distance = to_player.length()

		if distance > preferred_distance + tolerance:
		# подойти
			velocity = to_player.normalized() * move_speed

		elif distance < preferred_distance - tolerance:
		# отступить
			velocity = -to_player.normalized() * move_speed

		else:
		# нужная зона
			velocity = Vector2.ZERO
		move_and_slide()
	elif is_attacking == true and is_dash_atk == true:
		velocity = dash_attack_vector.normalized() * 500
		move_and_slide()
func start_random_timer():
	timer.wait_time = randf_range(2.0, 5.0)
	timer.start()
func dash_attack():
	if not player:
		return
	is_attacking = true
	is_dash_atk = true
	dash_attack_vector = player.global_position - global_position
	attack_pivot.rotation = dash_attack_vector.angle() + deg_to_rad(-90)
	attack_area.visible=true
	await get_tree().create_timer(0.2).timeout
	attack_area.visible=false
	is_attacking = false
	is_dash_atk = false
	
func swing_attack():
	var t := 0.0
	attack_area.monitoring = true
	attack_area.visible=true
	while t < attack_time:
		t += get_physics_process_delta_time()
		var time := t / attack_time
		var curve_value = swing_curve.sample(time)
		attack_pivot.rotation = lerp(
			-attack_angle * 0.5,
			 attack_angle * 0.5,
			 curve_value
		)
		await get_tree().physics_frame

	attack_area.monitoring=false
	attack_area.visible=false
	

	move_and_slide()

func _on_attack_timer_timeout() -> void:
	var attack = randi_range(1, 2)
	if attack == 1:
		swing_attack()
	elif attack == 2:
		dash_attack()
	attack_timer_started = false
