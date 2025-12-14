extends Node
@onready var anim = $AnimatedSprite2D
@onready var hit_area = $Hit_Area
var Enemy_Hp = 10

func _on_hit_area_area_entered(area: Area2D) -> void:
	if area.name == "Attack_Area":
		
		anim.play("hit_anim")
	
	pass # Replace with function body.
