class_name EnemyFactory
extends Node

static func get_enemy_packed_scene(enemy_type: Enemy.EnemyType) -> Enemy:
	match enemy_type:
		Enemy.EnemyType.SPECTER:
			return ScenePaths.enemy_specter_packed_scene.instantiate()
	return null
