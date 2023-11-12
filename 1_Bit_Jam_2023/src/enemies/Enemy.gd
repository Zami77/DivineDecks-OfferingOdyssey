class_name Enemy
extends Node2D

signal enemy_destroyed
signal action_selected(action: Action)

@export var enemy_type: EnemyType = EnemyType.SPECTER
@export var enemy_texture: Texture
@export var action_pool: Array[Action] = [Action.ATTACK]
@export var max_health: int = 3
@export var attack_amount: int = 0
@export var defend_amount: int = 0
@export var heal_amount: int = 0
@export var status_effect: Card.StatusEffect = Card.StatusEffect.POISON
@export var status_effect_amount: int = 1

@onready var enemy_image: TextureRect = $EnemyImage
@onready var health_label: Label = $HealthLabel
@onready var upcoming_action_label: Label = $UpcomingActionLabel

var current_health = max_health :
	set(value):
		current_health = value
		current_health = max(0, current_health)
		current_health = min(max_health, current_health)
		_update_health_label()
		_check_if_alive()
var upcoming_action: Action :
	set(value):
		upcoming_action = value
		_update_upcoming_action_label()
var action_bag: Array[Action]
var defense = 0

enum EnemyType { SPECTER }
enum Action { ATTACK, DEFEND, HEAL, STATUS }

func _ready():
	enemy_image.texture = enemy_texture
	_fill_bag()
	upcoming_action = action_bag[action_bag.size() - 1]
	current_health = max_health

func _fill_bag() -> void:
	if not action_bag:
		action_bag = action_pool.duplicate(true)
		action_bag.shuffle()

func take_damage(damage_amount: int) -> void:
	if damage_amount > defense:
		damage_amount -= defense
		defense = 0
	else:
		defense -= damage_amount
		damage_amount = 0
	current_health -= damage_amount

func gain_defense(defense_gain: int) -> void:
	defense += defense_gain

func gain_health(health_gain: int) -> void:
	current_health += health_gain

func execute_turn() -> void:
	upcoming_action_label.visible = false
	var turn_action: Action = action_bag.pop_back()
	
	emit_signal("action_selected", turn_action)
	
	_fill_bag()
	upcoming_action = action_bag[action_bag.size() - 1]
	upcoming_action_label.visible = true

func _check_if_alive() -> void:
	if current_health <= 0:
		emit_signal("enemy_destroyed")

func _update_health_label() -> void:
	health_label.text = "Health: %d/%d" % [current_health, max_health]

func _update_upcoming_action_label() -> void:
	upcoming_action_label.text = "Upcoming Action: %s" % [Action.keys()[upcoming_action]]

