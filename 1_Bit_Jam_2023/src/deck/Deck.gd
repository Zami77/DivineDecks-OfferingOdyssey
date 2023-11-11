class_name Deck
extends Node2D

@export var cards: Array[Card] 
@export var deck_type: DeckType = DeckType.DECK

@onready var deck_texture_rect: TextureRect = $DeckTextureRect
	
enum DeckType { DECK, DISCARD }

func _ready():
	for card in cards:
		add_child(card)
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
	var drawn_card = cards.pop_front()
	remove_child(drawn_card)
	_check_visibility()
	return drawn_card

func add_card(new_card: Card) -> void:
	cards.append(new_card)
	add_card(new_card)
	_check_visibility()
