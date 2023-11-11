class_name CombatManager
extends Node2D


@onready var deck: Deck = $Deck
@onready var discard: Deck = $Discard
@onready var hand: CardHand = $Hand

var player: Player = null

func _ready():
	DataManager.save_game()

func setup_combat(_player: Player) -> void:
	player = _player
	
	for card_name in player.deck:
		deck.add_card_from_name(card_name)
	
	_draw_hand()
	
func _draw_hand():
	if deck.cards.size() + discard.cards.size() < hand.hand_size:
		print("Game Over, not enough cards")
		return
	
	var cards_drawn = 0
	
	while cards_drawn < hand.hand_size:
		if deck.cards.size() > 0:
			hand.add_card(deck.draw())
			cards_drawn += 1
		else:
			# TODO: take cards from discard and put them into the deck
			pass
