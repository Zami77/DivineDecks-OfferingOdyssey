class_name OverworldManager
extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var overworld_node_holder: Node2D = $OverworldNodesHolder
@onready var player_token: PlayerToken = $PlayerToken

var player: Player = null
var overworld_nodes: Dictionary = {}
var player_at_node: int = 1 :
	set(value):
		_move_player_token(player_at_node, value)
		player_at_node = value

func _ready():
	var node_id = 1
	for node in overworld_node_holder.get_children():
		if node is OverworldNode:
			node.node_id = node_id
			line_2d.add_point(node.position + node.node_rect.size / 2)
			overworld_nodes[node_id] = node

func _setup_player(_player: Player) -> void:
	player = _player
	player_token.setup_token(player.class_type)

func _move_player_token(old_node_id: int, new_node_id: int) -> void:
	var player_token_tween = get_tree().create_tween()

func save_game() -> void:
	DataManager.game_data.overworld_data['player_at_node'] = player_at_node
	
	for node in overworld_nodes:
		if node is OverworldNode:
			DataManager.game_data.overworld_data['overworld_nodes'][node.node_id] = node.completed

func load_data() -> void:
	if DataManager.game_data.overworld_data:
		player_at_node = DataManager.game_data.overworld_data['player_at_node']
		
		
