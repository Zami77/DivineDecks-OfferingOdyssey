class_name ScenePaths
extends Node

static var combat_manager = "res://src/managers/combat_manager/CombatManager.tscn"
static var main_menu = "res://src/ui/main_menu/MainMenu.tscn"
static var overworld_manager = "res://src/managers/overworld_manager/OverworldManager.tscn"
static var class_select = "res://src/ui/class_select/ClassSelect.tscn"

static var start_deck = "res://src/deck/start_deck/StartDeck.tscn"
static var start_deck_knight = preload("res://src/deck/start_deck/StartDeckKnight.tres")
static var start_deck_warlock = preload("res://src/deck/start_deck/StartDeckWarlock.tres")

static var knight_stats_resource = preload("res://src/player/player_stats/KnightStats.tres")
static var warlock_stats_resource = preload("res://src/player/player_stats/WarlockStats.tres")

static var attack_sword_card_packed_scene = preload("res://src/cards/attack_cards/AttackSwordCard.tscn")
static var attack_club_card_packed_scene = preload("res://src/cards/attack_cards/club/AttackClubCard.tscn")
static var attack_dark_magic_card_packed_scene = preload("res://src/cards/attack_cards/dark_magic/AttackDarkMagic.tscn")
static var attack_light_magic_card_packed_scene = preload("res://src/cards/attack_cards/light_magic/AttackLightMagic.tscn")
static var attack_nuke_card_packed_scene = preload("res://src/cards/attack_cards/nuke/AttackNukeCard.tscn")
static var attack_scythe_card_packed_scene = preload("res://src/cards/attack_cards/scythe/AttackScytheCard.tscn")
static var attack_staff_card_packed_scene = preload("res://src/cards/attack_cards/staff/AttackStaffCard.tscn")

static var defend_helmet_card_packed_scene = preload("res://src/cards/defend_cards/DefendHelmetCard.tscn")
static var defend_hood_card_packed_scene = preload("res://src/cards/defend_cards/hood/DefendHoodCard.tscn")
static var defend_special_knight_helmet_card_packed_scene = preload("res://src/cards/defend_cards/special_knight_helmet/DefendSpecialKnightHelmet.tscn")
static var defend_star_of_card_packed_scene = preload("res://src/cards/defend_cards/star_of/DefendStarOfCard.tscn")

static var heal_heart_card_packed_scene = preload("res://src/cards/heal_cards/HealHeartCard.tscn")
static var heal_cracked_orb_card_packed_scene = preload("res://src/cards/heal_cards/cracked_orb/HealCrackedOrbCard.tscn")
static var heal_health_potion_card_packed_scene = preload("res://src/cards/heal_cards/health_potion/HealHealthPotion.tscn")


static var enemy_specter_packed_scene = preload("res://src/enemies/specter/Specter.tscn")
