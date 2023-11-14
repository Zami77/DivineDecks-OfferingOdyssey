class_name Player
extends Node2D

signal player_destroyed
signal took_damage
signal stats_updated

@export var deck: Array[Card.CardName] = []
@export var class_type: ClassType = ClassType.KNIGHT
@export var start_health: int = 8

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

enum ClassType { KNIGHT }

func _ready():
	max_health = start_health
	current_health = max_health

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

