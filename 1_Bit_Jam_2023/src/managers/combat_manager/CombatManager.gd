class_name CombatManager
extends Node2D

@export var card_play_tween_duration: float = 0.3

@onready var deck: Deck = $Deck
@onready var discard: Deck = $Discard
@onready var hand: CardHand = $Hand
@onready var card_play_area: Node2D = $CardPlayArea
@onready var enemy_area: Node2D = $EnemyArea

var player: Player = null
var enemy: Enemy = null
var turn_owner: TurnOwner = TurnOwner.PLAYER

enum TurnOwner { PLAYER, ENEMY, COMBAT_OVER }

func _ready():
	DataManager.save_game()
	hand.card_selected.connect(_on_card_selected_from_hand)

func setup_combat(_player: Player, enemy_type: Enemy.EnemyType = Enemy.EnemyType.SPECTER) -> void:
	player = _player
	enemy = EnemyFactory.get_enemy_packed_scene(enemy_type)
	enemy_area.add_child(enemy)
	
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
			var drawn_card = deck.draw()
			hand.add_card(drawn_card)
			cards_drawn += 1
		else:
			var discard_cards: Array[Card] = []
			while discard.cards.size() > 0:
				discard_cards.append(discard.draw())
			# TODO: add animation going to deck location
			for card in discard_cards:
				deck.add_card(card)

func _execute_card_action(card: Card) -> void:
	var card_old_global_pos = card.global_position
	hand.remove_child(card)
	add_child(card)
	card.global_position = card_old_global_pos
	
	# move to card play area
	var card_pos_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	card_pos_tween.tween_property(card, "global_position", card_play_area.global_position, card_play_tween_duration)
	await card_pos_tween.finished
	
	# do card action
	_do_card_action(card)
	
	await get_tree().create_timer(0.3).timeout
	# remove from game
	remove_child(card)

func _do_card_action(card: Card) -> void:
	for card_type in card.card_types:
		match card_type:
			Card.CardType.ATTACK:
				pass
			Card.CardType.DEFEND:
				pass
			Card.CardType.STATUS:
				pass
			Card.CardType.HEAL:
				pass

func _on_card_selected_from_hand(card_selected: Card) -> void:
	_execute_card_action(card_selected)
