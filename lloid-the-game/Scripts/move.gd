extends State
@onready var anim = $"../../AnimatedSprite2D"
@onready var char = $"../.."
@export var walk_speed: int
var last_dir := "down"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var dir = Vector2(
		Input.get_action_strength("right_walk") - Input.get_action_strength("left_walk"),
		Input.get_action_strength("down_walk") - Input.get_action_strength("up_walk")
	).normalized()
	var speed := walk_speed
	if dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			if dir.x > 0:
				anim.flip_h = false
				last_dir = "right"
			else:
				anim.flip_h = true
				last_dir = "right"
		elif dir.x > 0 and dir.y > 0:
			anim.flip_h = false
			last_dir = "down_right"
		elif dir.x > 0 and dir.y < 0:
			anim.flip_h = false
			last_dir = "up_right"
		elif dir.x < 0 and dir.y > 0:
			anim.flip_h = true
			last_dir = "down_right"
		elif dir.x < 0 and dir.y < 0:
			anim.flip_h = true
			last_dir = "up_right"
		else:
			last_dir = "down" if dir.y > 0 else "up"
	else:
		anim.play("idle")	
		
		anim.play("walk_" + last_dir)
	char.velocity = dir * speed
