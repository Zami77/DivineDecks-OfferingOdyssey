class_name Player
extends Node2D

signal player_destroyed

@export var deck: Array[Card.CardName] = []
@export var start_health: int = 8

var max_health: int = start_health
var current_health: int = max_health :
	set(value):
		current_health = value
		current_health = max(0, current_health)
		current_health = min(max_health, current_health)
		_health_changed()

func _ready():
	max_health = start_health
	current_health = max_health

func _health_changed() -> void:
	if current_health == 0:
		emit_signal("player_destroyed")
