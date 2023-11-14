class_name PlayerToken
extends Node2D

signal player_token_selected

@onready var texture_rect: TextureRect = $TextureRect
@onready var selectable_area: Area2D = $SelectableArea

func _ready():
	selectable_area.input_event.connect(_on_input_event)

func setup_token(class_type: Player.ClassType) -> void:
	texture_rect.texture = UtilHelper.get_player_portrait(class_type)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		emit_signal("player_token_selected")
