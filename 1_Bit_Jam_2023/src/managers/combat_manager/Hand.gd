class_name CardHand
extends Node2D

signal card_selected(card: Card)
signal card_added
signal card_moved

static var hand_size: int = 3
var cards: Array[Card] = []
var card_buffer: int = 16

func add_card(new_card: Card) -> void:
	cards.append(new_card)
	add_child(new_card)
	new_card.global_position = global_position
	var new_position_x = (cards.size() - 1) * Dimensions.card_width
	
	var card_pos_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	card_pos_tween.tween_property(new_card, "position", new_card.position + Vector2(new_position_x, 0), 0.2)
	
	if not new_card.card_selected.is_connected(_on_card_selected):
		new_card.card_selected.connect(_on_card_selected)

	await card_pos_tween.finished
	emit_signal("card_moved")
	
func empty_hand() -> Array[Card]:
	var remaining_hand = cards.duplicate(true)
	
	cards = []
	
	return remaining_hand

func _on_card_selected(card: Card) -> void:
	emit_signal("card_selected", card)
	cards.erase(card)
	#remove_child(card)
