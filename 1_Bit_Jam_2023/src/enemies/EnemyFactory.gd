class_name EnemyFactory
extends Node

static func get_enemy_packed_scene(enemy_type: Enemy.EnemyType) -> Enemy:
	match enemy_type:
		Enemy.EnemyType.SPECTER:
			return ScenePaths.enemy_specter_packed_scene.instantiate()
		Enemy.EnemyType.REX:
			return ScenePaths.enemy_rex_packed_scene.instantiate()
		Enemy.EnemyType.BUG_MONKEY:
			return ScenePaths.enemy_bug_monkey_packed_scene.instantiate()
		Enemy.EnemyType.SPIKER:
			return ScenePaths.enemy_spiker_packed_scene.instantiate()
		Enemy.EnemyType.ROCK_SLIME:
			return ScenePaths.enemy_rock_slime_packed_scene.instantiate()
		Enemy.EnemyType.CRAB:
			return ScenePaths.enemy_crab_packed_scene.instantiate()
	return null
