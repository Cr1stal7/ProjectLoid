extends CharacterBody2D

@export var walk_speed := 180.0
@export var sprint_multiplier := 1.6
func _physics_process(_delta):
	var dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	var speed := walk_speed
	if Input.is_action_pressed("Sprint"):
		speed *= sprint_multiplier
	velocity = dir * speed
	move_and_slide()
				
