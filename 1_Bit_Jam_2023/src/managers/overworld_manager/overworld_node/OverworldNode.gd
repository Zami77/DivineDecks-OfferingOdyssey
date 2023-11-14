class_name OverworldNode
extends Area2D

signal overworld_node_selected(node: OverworldNode)

@export var enemy: Enemy.EnemyType = Enemy.EnemyType.SPECTER
@export var node_id: int = -1

@onready var node_rect: ColorRect = $ColorRect

var completed: bool = false

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		emit_signal("overworld_node_selected", self)
