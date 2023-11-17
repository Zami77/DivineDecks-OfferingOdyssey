class_name Deck
extends Node2D

@export var card_names: Array[Card.CardName] = []
@export var deck_type: DeckType = DeckType.DECK

@onready var deck_texture_rect: TextureRect = $DeckTextureRect
	
var cards: Array[Card]
var rng = RandomNumberGenerator.new()

enum DeckType { DECK, DISCARD }

func _ready():
	rng.randomize()
	
	for card_name in card_names:
		add_card_from_name(card_name)
	cards.shuffle()
	
	match deck_type:
		DeckType.DECK:
			deck_texture_rect.texture = Textures.deck_texture
		DeckType.DISCARD:
			deck_texture_rect.texture = Textures.discard_texture
	
	_check_visibility()

func _check_visibility() -> void:
	visible = cards.size() > 0

func shuffle() -> void:
	cards.shuffle()

func draw() -> Card:
	var drawn_card = cards.pop_at(rng.randi_range(0, cards.size() - 1))
	drawn_card.visible = true
	#remove_child(drawn_card)
	_check_visibility()
	return drawn_card

func add_card(new_card: Card) -> void:
	cards.append(new_card)
	add_child(new_card)
	new_card.global_position = global_position
	new_card.visible = false
	_check_visibility()
	cards.shuffle()

func add_card_from_name(card_name: Card.CardName) -> void:
	var card = CardFactory.get_card_packed_scene(card_name)
	add_child(card)
	cards.append(card)
	card.visible = false
	_check_visibility()
