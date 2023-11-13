class_name CombatEndPanel
extends Panel

signal end_combat_selected

@onready var end_match_button: DefaultButton = $vBoxContainer/EndMatchButton
@onready var winner_label: Label = $vBoxContainer/WinnerLabel

func _ready():
	end_match_button.pressed.connect(_on_end_match_button_pressed)
	z_index = ZIndexPosition.combat_end_panel

func set_winner_label(match_winner: CombatManager.TurnOwner) -> void:
	match match_winner:
		CombatManager.TurnOwner.PLAYER:
			winner_label.text = 'Player Wins!'
		CombatManager.TurnOwner.ENEMY:
			winner_label.text = 'Enemy Wins!'

func _on_end_match_button_pressed() -> void:
	emit_signal("end_combat_selected")
