class_name MainMenu
extends Node2D

signal option_selected(option: Option)

@onready var start_run_button: Button = $VBoxContainer/StartRunButton
@onready var continue_run_button: Button = $VBoxContainer/ContinueRunButton
@onready var exit_button: Button = $VBoxContainer/ExitGameButton

enum Option { START_RUN, CONTINUE_RUN, EXIT_GAME }
# Called when the node enters the scene tree for the first time.
func _ready():
	start_run_button.pressed.connect(_on_button_press.bind(Option.START_RUN))
	continue_run_button.pressed.connect(_on_button_press.bind(Option.CONTINUE_RUN))
	exit_button.pressed.connect(_on_button_press.bind(Option.EXIT_GAME))


func _on_button_press(option: Option) -> void:
	emit_signal("option_selected", option)
