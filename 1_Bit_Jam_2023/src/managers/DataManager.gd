extends Node

var save_filename = "user://game_data.save"


var game_data = {
	"player_data": {},
	"overworld_data": {
		"player_at_node": 0,
		"overworld_nodes": {}
	},
	"settings": {},
	"persistent_data": {}
}

func _ready():
	if OS.is_debug_build():
		save_filename = "res://game_data.save"

func reset_run_data() -> void:
	game_data.player_data = {}
	game_data.overworld_data.player_at_node = 0
	game_data.overworld_data.overworld_nodes = {}

func save_game() -> void:
	var save_file = FileAccess.open(save_filename, FileAccess.WRITE)
	save_file.store_line(JSON.stringify(game_data, '\t'))

func load_game() -> void:
	if not FileAccess.file_exists(save_filename):
		return
	
	var save_file = FileAccess.open(save_filename, FileAccess.READ)
	var save_file_text = save_file.get_as_text()
	
	if not save_file_text:
		return
	
	var save_data_json = JSON.parse_string(save_file_text)
	
	if not save_data_json:
		push_error("save_data was null")
		return
	
	game_data = save_data_json
	
