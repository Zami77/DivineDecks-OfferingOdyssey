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
		Card.CardName.HEAL_HEALTH_POTION:
			return ScenePaths.heal_health_potion_card_packed_scene.instantiate()
		Card.CardName.DEFEND_SPECIAL_KNIGHT_HELMET:
			return ScenePaths.defend_special_knight_helmet_card_packed_scene.instantiate()
		Card.CardName.DEFEND_HOOD:
			return ScenePaths.defend_hood_card_packed_scene.instantiate()
		Card.CardName.ATTACK_STAFF:
			return ScenePaths.attack_staff_card_packed_scene.instantiate()
		Card.CardName.ATTACK_SCYTHE:
			return ScenePaths.attack_scythe_card_packed_scene.instantiate()
		Card.CardName.ATTACK_NUKE:
			return ScenePaths.attack_nuke_card_packed_scene.instantiate()
		Card.CardName.ATTACK_CLUB:
			return ScenePaths.attack_club_card_packed_scene.instantiate()
		Card.CardName.HEAL_CRACKED_ORB:
			return ScenePaths.heal_cracked_orb_card_packed_scene.instantiate()
		Card.CardName.DEFEND_STAR_OF:
			return ScenePaths.defend_star_of_card_packed_scene.instantiate()
		Card.CardName.ATTACK_LIGHT_MAGIC:
			return ScenePaths.attack_light_magic_card_packed_scene.instantiate()
		Card.CardName.ATTACK_DARK_MAGIC:
			return ScenePaths.attack_dark_magic_card_packed_scene.instantiate()
	return null
