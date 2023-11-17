class_name Player
extends Node2D

signal player_destroyed
signal took_damage
signal stats_updated

@export var class_type: ClassType = ClassType.KNIGHT :
	set(value):
		class_type = value
		
@export var start_health: int = 8

var deck: Array[Card.CardName] = []
var max_health: int = start_health
var current_health: int = max_health :
	set(value):
		current_health = value
		current_health = max(0, current_health)
		current_health = min(max_health, current_health)
		_stats_changed()

var defense: int = 0 :
	set(value):
		defense = value
		_stats_changed()
var statuses: Array[Card.StatusEffect] = []

enum ClassType { KNIGHT, WARLOCK }

func _ready():

	_setup_class_type()
	current_health = max_health
	
	load_game()

func _setup_class_type() -> void:
	var class_stats: PlayerStats
	var class_deck: PrebuiltDeck
	
	match class_type:
		ClassType.KNIGHT:
			class_stats = ScenePaths.knight_stats_resource
			class_deck = 
		ClassType.WARLOCK:
			class_stats = ScenePaths.warlock_stats_resource
	
	max_health = class_stats.max_health

func take_damage(damage_amount: int) -> void:
	if damage_amount > defense:
		damage_amount -= defense
		defense = 0
	else:
		defense -= damage_amount
		damage_amount = 0
	current_health -= damage_amount
	emit_signal("took_damage")

func gain_defense(defense_gain: int) -> void:
	defense += defense_gain

func gain_health(health_gain: int) -> void:
	current_health += health_gain

func _reset_run_stats() -> void:
	current_health = start_health
	max_health = start_health
	class_type = ClassType.KNIGHT
	deck = []
	_setup_starter_deck()
	DataManager.reset_run_data()
	
func load_game() -> void:
	if DataManager.game_data.player_data:
		current_health = DataManager.game_data.player_data['current_health']
		max_health = DataManager.game_data.player_data['max_health']
		var deck_card_names = DataManager.game_data.player_data['deck']
		deck = []
		for card_name in deck_card_names:
			deck.append(card_name as Card.CardName)
		
		class_type = DataManager.game_data.player_data['class_type']
		

func save_game() -> void:
	DataManager.game_data.player_data['current_health'] = current_health
	DataManager.game_data.player_data['max_health'] = max_health
	DataManager.game_data.player_data['deck'] = deck
	DataManager.game_data.player_data['class_type'] = class_type
	
	DataManager.save_game()

func _stats_changed() -> void:
	emit_signal("stats_updated")
	if current_health == 0:
		emit_signal("player_destroyed")

