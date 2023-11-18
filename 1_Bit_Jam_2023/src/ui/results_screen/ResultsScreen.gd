class_name ResultsScreen
extends Node2D

signal back_to_main_menu

@onready var main_menu_button: DefaultButton = $MainMenuButton
@onready var run_outcome_label: Label = $VBoxContainer/RunOutcomeLabel
@onready var cards_reamining_label: Label = $VBoxContainer/CardsRemainingLabel
@onready var player_class_label: Label = $VBoxContainer/PlayerClassLabel

func _ready():
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func setup_results(player: Player, successful_run: bool) -> void:
	if successful_run:
		AudioManager.play_victory_theme()
		DialogueManager.show_dialogue_balloon(load("res://src/dialogs/results_screen/SuccessfulRun.dialogue"))
	else:
		AudioManager.play_defeat_theme()
		DialogueManager.show_dialogue_balloon(load("res://src/dialogs/results_screen/DefeatRun.dialogue"))
	
	run_outcome_label.text = "Run: Successful" if successful_run else "Run: Failure"
	cards_reamining_label.text = "Cards Remaining: %d" % [len(player.deck)]
	player_class_label.text = "Class: %s" % [Player.ClassType.keys()[player.class_type]]

func _on_main_menu_button_pressed() -> void:
	emit_signal("back_to_main_menu")
