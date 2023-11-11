class_name CardHand
extends Node2D

signal card_selected(card: Card)

var hand_size: int = 3
var cards: Array[Card] = []

func add_card(new_card: Card) -> void:
	cards.append(new_card)
	add_child(new_card)
	new_card.position.x += (cards.size() - 1) * Dimensions.card_width
	new_card.card_selected.connect(_on_card_selected.bind(cards.size() - 1))

func _on_card_selected(card: Card, card_index) -> void:
	emit_signal("card_selected", card)
	cards.remove_at(card_index)
	remove_child(card)
