extends Node2D

func _load_level() -> void:
	GlobalScript.checkpoint_pos = Vector2(-999, -999)
	GlobalScript.previous_checkpoint_node = null
	pass
