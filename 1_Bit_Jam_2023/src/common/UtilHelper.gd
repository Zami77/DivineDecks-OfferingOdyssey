class_name UtilHelper
extends Node

static func get_player_portrait(class_type: Player.ClassType) -> Texture:
	match class_type:
		Player.ClassType.KNIGHT:
			return Textures.knight_portrait
		_:
			return Textures.knight_portrait
