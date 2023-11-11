class_name CardFactory
extends Node


static func get_card_packed_scene(card_name: Card.CardName) -> Card:
	match card_name:
		Card.CardName.ATTACK_SWORD:
			return ScenePaths.attack_sword_card_packed_scene.instantiate()
	
	return null
