class_name CardFactory
extends Node


static func get_card_packed_scene(card_name: Card.CardName) -> Card:
	match card_name:
		Card.CardName.ATTACK_SWORD:
			return ScenePaths.attack_sword_card_packed_scene.instantiate()
		Card.CardName.HEAL_HEART:
			return ScenePaths.heal_heart_card_packed_scene.instantiate()
		Card.CardName.DEFEND_HELMET:
			return ScenePaths.defend_helmet_card_packed_scene.instantiate()
	
	return null
