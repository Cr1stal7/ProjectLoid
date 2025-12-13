extends CharacterBody2D
@onready var anim = $AnimatedSprite2D
@export var walk_speed := 180.0
@export var sprint_multiplier := 1.6
var running = false
var last_dir := "down"
func _physics_process(_delta):
	var dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	var speed := walk_speed
	
	if Input.is_action_pressed("Sprint"):
		speed *= sprint_multiplier
		running = true
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
