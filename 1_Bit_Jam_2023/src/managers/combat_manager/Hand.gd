class_name CardHand
extends Node2D

signal card_selected(card: Card)

static var hand_size: int = 3
var cards: Array[Card] = []
var card_buffer: int = 16

func add_card(new_card: Card) -> void:
	cards.append(new_card)
	add_child(new_card)
	new_card.position.x += (cards.size() - 1) * Dimensions.card_width
		
	new_card.card_selected.connect(_on_card_selected)

func _on_card_selected(card: Card) -> void:
	emit_signal("card_selected", card)
	cards.erase(card)
	#remove_child(card)
