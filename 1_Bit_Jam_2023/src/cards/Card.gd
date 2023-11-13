class_name Card
extends Node2D

signal card_selected(card: Card)
signal card_used

@export var card_image_texture: Texture
@export var card_types: Array[CardType] = [CardType.ATTACK]
@export var card_name: CardName = CardName.ATTACK_SWORD
@export var attack_amount: int = 0
@export var defend_amount: int = 0
@export var heal_amount: int = 0
@export var status_effect: StatusEffect = StatusEffect.POISON
@export var status_effect_amount: int = 1

@onready var card_image: TextureRect = $CardImage
@onready var card_text: Label = $CardText
@onready var selectable_area: Area2D = $SelectableArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer


enum CardType { ATTACK, DEFEND, STATUS, HEAL }
enum StatusEffect { POISON, STUN }
enum CardName { ATTACK_SWORD, DEFEND_HELMET, HEAL_HEART }

func _ready():
	_setup_card_image()
	_setup_card_text()
	
	selectable_area.input_event.connect(_on_selectable_are_input_event)

func _setup_card_image() -> void:
	card_image.texture = card_image_texture

func _setup_card_text() -> void:
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

func use_card() -> void:
	animation_player.play("card_used")
	await animation_player.animation_finished
	emit_signal("card_used")

func _on_selectable_are_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		emit_signal("card_selected", self)
