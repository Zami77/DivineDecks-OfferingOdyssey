class_name Card
extends Node2D

@export var card_image_texture: Texture
@export var card_types: Array[CardType] = [CardType.ATTACK]
@export var attack_amount: int = 0
@export var defend_amount: int = 0
@export var heal_amount: int = 0
@export var status_effect: StatusEffect = StatusEffect.POISON
@export var status_effect_amount: int = 1

@onready var card_image: TextureRect = $CardImage
@onready var card_text: Label = $CardText


enum CardType { ATTACK, DEFEND, STATUS, HEAL }
enum StatusEffect { POISON, STUN }

func _ready():
	card_image.texture = card_image_texture
	card_text.text = ""
	
	for type in card_types:
		match type:
			CardType.ATTACK:
				card_text.text += "deals %d damage to enemy" % attack_amount
			CardType.DEFEND:
				card_text.text += "adds %d defense to player" % defend_amount
			CardType.STATUS:
				card_text.text += "gives %d %s to enemy" % [status_effect_amount, StatusEffect.keys()[status_effect]]
			CardType.HEAL:
				card_text.text += "heals %d health to player" % heal_amount
		card_text.text += "\n"
