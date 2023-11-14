class_name CombatManager
extends Node2D

signal card_moved
signal hand_emptied
signal hand_drawn
signal combat_ended(winner: TurnOwner)

@export var card_play_tween_duration: float = 0.3

@onready var deck: Deck = $Deck
@onready var discard: Deck = $Discard
@onready var hand: CardHand = $Hand
@onready var card_play_area: Node2D = $CardPlayArea
@onready var enemy_area: Node2D = $EnemyArea
@onready var end_turn_button: DefaultButton = $PlayerStatsContainer/EndTurnButton
@onready var combat_end_panel: CombatEndPanel = $CombatEndPanel
@onready var player_health_label: Label = $PlayerStatsContainer/PlayerHealthLabel
@onready var player_defense_label: Label = $PlayerStatsContainer/PlayerDefenseLabel
@onready var player_status_label: Label = $PlayerStatsContainer/PlayerStatusLabel
@onready var player_texture_rect: TextureRect = $PlayerTextureRect

var player: Player = null
var enemy: Enemy = null
var turn_owner: TurnOwner = TurnOwner.PLAYER
var match_winner: TurnOwner = TurnOwner.PLAYER
var mid_card_action: bool = false

enum TurnOwner { PLAYER, ENEMY, COMBAT_OVER }

func _ready():
	DataManager.save_game()
	hand.card_selected.connect(_on_card_selected_from_hand)
	end_turn_button.pressed.connect(_on_end_turn_button_pressed)
	combat_end_panel.end_combat_selected.connect(_on_end_combat_selected)
	end_turn_button.disabled = true

func setup_combat(_player: Player, enemy_type: Enemy.EnemyType = Enemy.EnemyType.SPECTER) -> void:
	_init_player(_player)
	_init_enemy(enemy_type)
	
	for card_name in player.deck:
		deck.add_card_from_name(card_name)
	
	_execute_player_turn()

func _init_player(_player: Player):
	player = _player
	player.player_destroyed.connect(_on_player_destroyed)
	player.stats_updated.connect(_on_player_stats_updated)
	_on_player_stats_updated()
	_set_player_texture_rect()

func _set_player_texture_rect() -> void:
	match player.class_type:
		Player.ClassType.KNIGHT:
			player_texture_rect.texture = Textures.knight_portrait

func _init_enemy(enemy_type: Enemy.EnemyType) -> void:
	enemy = EnemyFactory.get_enemy_packed_scene(enemy_type)
	enemy_area.add_child(enemy)
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	enemy.action_selected.connect(_on_enemy_action_selected)

func _execute_player_turn():
	if turn_owner == TurnOwner.COMBAT_OVER:
		return
	
	turn_owner = TurnOwner.PLAYER
	_draw_hand()
	await hand_drawn
	end_turn_button.disabled = false

func _draw_hand():
	if deck.cards.size() + discard.cards.size() < hand.hand_size:
		print("Game Over, not enough cards")
		return
	
	var cards_drawn = 0
	
	while cards_drawn < hand.hand_size:
		if deck.cards.size() > 0:
			var drawn_card = deck.draw()
			_move_card(drawn_card, hand.global_position)
			await card_moved
			
			deck.remove_child(drawn_card)
			hand.add_card(drawn_card)
			await hand.card_moved
			cards_drawn += 1
		else:
			var discard_cards: Array[Card] = []
			while discard.cards.size() > 0:
				discard_cards.append(discard.draw())
			# TODO: add animation going to deck location
			for card in discard_cards:
				deck.add_card(card)
	
	emit_signal("hand_drawn")

func _execute_card_action(card: Card) -> void:
	end_turn_button.disabled = true
	mid_card_action = true
	var card_old_global_pos = card.global_position
	hand.remove_card(card)
	add_child(card)
	card.global_position = card_old_global_pos
	
	# move to card play area
	_move_card(card, card_play_area.global_position)
	await card_moved
	
	# do card action
	_do_card_action(card)
	
	await get_tree().create_timer(0.3).timeout
	
	card.use_card()
	await card.card_used
	
	# remove from game
	remove_child(card)
	card.queue_free()
	mid_card_action = false
	end_turn_button.disabled = false

func _move_card(card: Card, end_global_position: Vector2) -> void:
	var card_pos_tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	card_pos_tween.tween_property(card, "global_position", end_global_position, card_play_tween_duration)
	await card_pos_tween.finished
	emit_signal("card_moved")

func _execute_enemy_turn() -> void:
	if turn_owner == TurnOwner.COMBAT_OVER:
		return
		
	turn_owner = TurnOwner.ENEMY
	end_turn_button.disabled = true
	if not hand.is_empty():
		_empty_hand()
		await hand_emptied
	enemy.execute_turn()

func _empty_hand() -> void:
	var remaining_cards_in_hand = hand.empty_hand()
	
	for card in remaining_cards_in_hand:
		_move_card(card, discard.global_position)
		await card_moved
		hand.remove_card(card)
		discard.add_card(card)
	
	emit_signal("hand_emptied")

func _do_card_action(card: Card) -> void:
	for card_type in card.card_types:
		match card_type:
			Card.CardType.ATTACK:
				enemy.take_damage(card.attack_amount)
			Card.CardType.DEFEND:
				player.gain_defense(card.defend_amount)
			Card.CardType.STATUS:
				pass
			Card.CardType.HEAL:
				player.gain_health(card.heal_amount)

func _do_enemy_action(action: Enemy.Action) -> void:
	match action:
		Enemy.Action.ATTACK:
			player.take_damage(enemy.attack_amount)
		Enemy.Action.DEFEND:
			enemy.gain_defense(enemy.defend_amount)
		Enemy.Action.STATUS:
			pass
		Enemy.Action.HEAL:
			enemy.gain_health(enemy.heal_amount)
	
	await get_tree().create_timer(0.3).timeout
	_execute_player_turn()

func _end_combat() -> void:
	turn_owner = TurnOwner.COMBAT_OVER
	combat_end_panel.set_winner_label(match_winner)
	combat_end_panel.visible = true

func _on_card_selected_from_hand(card_selected: Card) -> void:
	if turn_owner == TurnOwner.COMBAT_OVER or turn_owner == TurnOwner.ENEMY or mid_card_action or end_turn_button.disabled:
		return
		
	_execute_card_action(card_selected)

func _on_enemy_destroyed() -> void:
	match_winner = TurnOwner.PLAYER
	_end_combat()

func _on_player_destroyed() -> void:
	match_winner = TurnOwner.ENEMY
	_end_combat()

func _on_end_turn_button_pressed() -> void:
	_execute_enemy_turn()

func _on_enemy_action_selected(action: Enemy.Action) -> void:
	_do_enemy_action(action)

func _on_end_combat_selected() -> void:
	emit_signal("combat_ended", match_winner)

func _on_player_stats_updated() -> void:
	player_health_label.text = "Health: %d/%d" % [player.current_health, player.max_health]
	player_defense_label.text = "Defense: %d" % [player.defense]
	player_status_label.text = "Status: %s" % ["Healthy"]

