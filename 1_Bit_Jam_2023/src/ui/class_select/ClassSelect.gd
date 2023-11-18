class_name ClassSelect
extends Node2D

signal class_type_selected(class_type: Player.ClassType)

@onready var select_knight_button: DefaultButton = $Control/ClassSelectBoxContainer/KnightContainer/SelectKnightButton
@onready var select_warlock_button: DefaultButton = $Control/ClassSelectBoxContainer/WarlockContainer/SelectWarlockButton

# Called when the node enters the scene tree for the first time.
func _ready():
	select_knight_button.pressed.connect(_on_class_selected.bind(Player.ClassType.KNIGHT))
	select_warlock_button.pressed.connect(_on_class_selected.bind(Player.ClassType.WARLOCK))
	_determine_classes_available()

func _determine_classes_available() -> void:
	# Knight always available
	select_knight_button.disabled = false
	
	# Set other classes as unavailable
	select_warlock_button.disabled = true
	
	if DataManager.game_data.persistent_data.unlocked_characters.has(str(Player.ClassType.WARLOCK)):
		select_warlock_button.disabled = false

func _on_class_selected(class_type: Player.ClassType) -> void:
	emit_signal("class_type_selected", class_type)
