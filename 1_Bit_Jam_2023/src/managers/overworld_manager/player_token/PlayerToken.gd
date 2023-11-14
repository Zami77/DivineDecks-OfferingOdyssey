class_name PlayerToken
extends Node2D

@onready var texture_rect: TextureRect = $TextureRect

func setup_token(class_type: Player.ClassType) -> void:
	texture_rect.texture = UtilHelper.get_player_portrait(class_type)
