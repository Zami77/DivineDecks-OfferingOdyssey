class_name Player
extends Node2D

@export var deck: Array[Card.CardName] = []
@export var start_health: int = 8

var max_health: int = start_health
var current_health: int = max_health

