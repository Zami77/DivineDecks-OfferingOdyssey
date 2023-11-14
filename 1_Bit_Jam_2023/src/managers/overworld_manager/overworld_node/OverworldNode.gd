class_name OverworldNode
extends Node2D

@export var enemy: Enemy.EnemyType = Enemy.EnemyType.SPECTER
@export var node_id: int = -1

@onready var node_rect: ColorRect = $ColorRect

var completed: bool = false
