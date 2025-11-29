extends Node

var player_hp: int = 30
var enemy_hp: int = 20

var turn: String = "player"  # "player" или "enemy"

@onready var attack_button = $"../Ui/AttackButton"
@onready var info_label = $"../Ui/InfoLabel"

func _ready():
	update_ui()
	attack_button.pressed.connect(_on_player_attack_pressed)

func update_ui():
	info_label.text = "HP игрока: %s   HP врага: %s\nХод: %s" % [
		player_hp, enemy_hp, turn
	]
	

func _on_player_attack_pressed():
	if turn != "player":
		return

	enemy_hp -= randi_range(4, 8)
	if enemy_hp <= 0:
		enemy_hp = 0
		update_ui()
		info_label.text += "\nПобеда!"
		attack_button.disabled = true
		return

	turn = "enemy"
	update_ui()
	await enemy_turn()

func enemy_turn():
	await get_tree().create_timer(0.8).timeout  # небольшая задержка

	player_hp -= randi_range(2, 6)

	if player_hp <= 0:
		player_hp = 0
		update_ui()
		info_label.text += "\nПоражение!"
		attack_button.disabled = true
		return

	turn = "player"
	update_ui()
