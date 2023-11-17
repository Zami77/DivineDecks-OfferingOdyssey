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
static var heal_heart_card_packed_scene = preload("res://src/cards/heal_cards/HealHeartCard.tscn")
static var defend_helmet_card_packed_scene = preload("res://src/cards/defend_cards/DefendHelmetCard.tscn")

static var enemy_specter_packed_scene = preload("res://src/enemies/specter/Specter.tscn")
