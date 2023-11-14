class_name GameManager
extends Node2D

@export var default_scene = "res://src/ui/main_menu/MainMenu.tscn"

@onready var transition_screen: TransitionScreen = $TransitionScreen
@onready var player: Player = $Player

var current_scene = null
var run_type: OverworldManager.RunType = OverworldManager.RunType.NEW_RUN
var node_battled_at: int = -1

func _ready():
	DataManager.load_game()
	transition_screen.visible = false
	_load_scene(default_scene)

func _load_scene(scene_path: String):
	DataManager.save_game()
	transition_screen.fade_to_black()
	await transition_screen.faded_to_black
	
	var new_packed_scene = load(scene_path) as PackedScene
	var new_scene = new_packed_scene.instantiate()
	
	if current_scene:
		current_scene.queue_free()
	
	current_scene = new_scene
	transition_screen.fade_to_scene()
	add_child(new_scene)
	
	if current_scene is MainMenu:
		current_scene.option_selected.connect(_on_main_menu_option_selected)
	
	if current_scene is CombatManager:
		var overworld_node = DataManager.game_data.overworld_data.overworld_nodes\
			[str(DataManager.game_data.overworld_data.player_at_node)]
		current_scene.setup_combat(player, overworld_node.enemy_type)
		current_scene.combat_ended.connect(_on_combat_ended)
	
	if current_scene is OverworldManager:
		current_scene.setup_world(player, run_type)
		current_scene.combat_entered.connect(_on_combat_entered)
	
	await transition_screen.faded_to_scene

func _reset_run_data() -> void:
	node_battled_at = -1

func _on_load_scene(scene_path) -> void:
	_load_scene(scene_path)

func _on_main_menu_option_selected(option: MainMenu.Option) -> void:
	match option:
		MainMenu.Option.START_RUN:
			_reset_run_data()
			run_type = OverworldManager.RunType.NEW_RUN
			_load_scene(ScenePaths.overworld_manager)
		MainMenu.Option.CONTINUE_RUN:
			run_type = OverworldManager.RunType.CONTINUE_RUN
			_load_scene(ScenePaths.overworld_manager)
		MainMenu.Option.EXIT_GAME:
			get_tree().quit()

func _on_combat_ended(combat_winner: CombatManager.TurnOwner) -> void:
	match combat_winner:
		CombatManager.TurnOwner.PLAYER:
			run_type = OverworldManager.RunType.CONTINUE_RUN
			DataManager.game_data.overworld_data.overworld_nodes[str(node_battled_at)]['completed'] = true
			_load_scene(ScenePaths.overworld_manager)
		CombatManager.TurnOwner.ENEMY:
			_load_scene(ScenePaths.main_menu)

func _on_combat_entered(enemy_type: Enemy.EnemyType, node_id: int) -> void:
	node_battled_at = node_id
	_load_scene(ScenePaths.combat_manager)
