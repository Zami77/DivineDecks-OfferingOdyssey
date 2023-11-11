class_name Deck
extends Node2D

@export var cards: Array[Card]

func _ready():
	for card in cards:
		add_child(card)
	cards.shuffle()

func shuffle() -> void:
	cards.shuffle()

func draw() -> Card:
	var drawn_card = cards.pop_front()
	remove_child(drawn_card)
	return drawn_card
