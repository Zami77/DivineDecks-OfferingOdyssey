class_name OverworldManager
extends Node2D

signal player_token_moved
signal combat_entered(enemy_type: Enemy.EnemyType, node_id: int)

@export var world_id: String = "overworld_1"
@export var player_token_tween_duration: float = 0.5
@onready var line_2d: Line2D = $Line2D
@onready var overworld_node_holder: Node2D = $OverworldNodesHolder
@onready var player_token: PlayerToken = $PlayerToken

var player: Player = null
var overworld_nodes: Dictionary = {}
var player_at_node: int = 1 :
	set(value):
		_move_player_token(player_at_node, value)
		player_at_node = value
var run_type: RunType = RunType.NEW_RUN

enum RunType { NEW_RUN, CONTINUE_RUN }

func _ready():
	var node_id = 1
	for node in overworld_node_holder.get_children():
		if node is OverworldNode:
			node.node_id = node_id
			line_2d.add_point(node.position + node.node_rect.size / 2)
			overworld_nodes[str(node_id)] = node
			node_id += 1
			node.overworld_node_selected.connect(_on_overworld_node_selected)

func setup_world(_player: Player, player_run_type: RunType	= RunType.NEW_RUN) -> void:
	player = _player
	player_token.setup_token(player.class_type)
	player_token.player_token_selected.connect(_on_player_token_selected)
	run_type = player_run_type
	
	if run_type == RunType.CONTINUE_RUN:
		load_data()
	player_token.global_position = overworld_nodes[str(player_at_node)].global_position
	save_game()

func _move_player_token(old_node_id: int, new_node_id: int) -> void:
	var player_token_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	player_token_tween.tween_property(player_token, "position", overworld_nodes[str(new_node_id)].position, player_token_tween_duration)
	await player_token_tween.finished
	emit_signal("player_token_moved")

func _on_player_token_selected() -> void:
	print("player token selected")

func _on_overworld_node_selected(overworld_node: OverworldNode) -> void:
	print("overworld_node %d selected" % [overworld_node.node_id])
	
	if is_valid_combat_node(overworld_node):
		save_game()
		emit_signal("combat_entered", overworld_node.enemy, overworld_node.node_id)
	elif is_valid_advance(overworld_node):
		save_game()
		_move_player_token(player_at_node, player_at_node + 1)
		player_at_node += 1

func is_valid_combat_node(overworld_node: OverworldNode) -> bool:
	return overworld_node.node_id == player_at_node and not overworld_node.completed

func is_valid_advance(overworld_node: OverworldNode) -> bool:
	return overworld_node.node_id - 1 == player_at_node and overworld_nodes[str(player_at_node)].completed and overworld_nodes.has(str(player_at_node + 1))

func save_game() -> void:
	DataManager.game_data.overworld_data['player_at_node'] = player_at_node
	DataManager.game_data.overworld_data['world_id'] = world_id
	for node_id in overworld_nodes:
		if overworld_nodes[node_id] is OverworldNode:
			var node = overworld_nodes[node_id]
			if not DataManager.game_data.overworld_data.has('overworld_nodes'):
				DataManager.game_data.overworld_data['overworld_nodes'] = {}
			if not DataManager.game_data.overworld_data.overworld_nodes.has(str(node.node_id)):
				DataManager.game_data.overworld_data.overworld_nodes[node_id] = {}
			
			DataManager.game_data.overworld_data['overworld_nodes'][str(node.node_id)]['completed'] = node.completed
			DataManager.game_data.overworld_data['overworld_nodes'][str(node.node_id)]['enemy_type'] = node.enemy
		
		DataManager.save_game()

func load_data() -> void:
	DataManager.load_game()
	
	if DataManager.game_data.overworld_data:
		player_at_node = DataManager.game_data.overworld_data['player_at_node']
		
		for node_id in DataManager.game_data.overworld_data.overworld_nodes:
			var loaded_node_stat = DataManager.game_data.overworld_data.overworld_nodes[str(node_id)]
			overworld_nodes[str(node_id)].completed = loaded_node_stat.completed
		
		
