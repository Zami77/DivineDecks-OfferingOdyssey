class_name GameManager
extends Node2D

@export var default_scene = "res://src/ui/main_menu/MainMenu.tscn"

@onready var transition_screen: TransitionScreen = $TransitionScreen
@onready var player: Player = $Player

var current_scene = null


func _ready():
	DataManager.load_game()
	transition_screen.visible = false
	_load_scene(default_scene)

func _load_scene(scene_path: String):
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
		current_scene.setup_combat(player)
		current_scene.combat_ended.connect(_on_combat_ended)
	
	await transition_screen.faded_to_scene

func _on_load_scene(scene_path) -> void:
	_load_scene(scene_path)

func _on_main_menu_option_selected(option: MainMenu.Option) -> void:
	match option:
		MainMenu.Option.START_RUN:
			_load_scene(ScenePaths.overworld_manager)
		MainMenu.Option.EXIT_GAME:
			get_tree().quit()

func _on_combat_ended(combat_winner: CombatManager.TurnOwner) -> void:
	match combat_winner:
		CombatManager.TurnOwner.PLAYER:
			_load_scene(ScenePaths.overworld_manager)
		CombatManager.TurnOwner.ENEMY:
			_load_scene(ScenePaths.main_menu) 
