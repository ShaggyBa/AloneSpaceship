extends Node

const SAVE_FILE = "user://save_file.save"
const CURRENT_SCHEMA_VERSION = 1

var game_data := {}

func _ready():
	load_data()
	
	
func save_data() -> void:
	game_data = _normalize_data(game_data)
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		push_error("Unable to open save file for writing: %s" % SAVE_FILE)
		return
	file.store_var(game_data)
	file.close()
	
	
func load_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_FILE):
		game_data = _default_data()
		save_data()
		return game_data

	var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		push_error("Unable to open save file for reading: %s" % SAVE_FILE)
		game_data = _default_data()
		return game_data

	game_data = file.get_var()
	file.close()
	game_data = _normalize_data(game_data)
	save_data()
	return game_data


func _default_data() -> Dictionary:
	return {
		"schema_version": CURRENT_SCHEMA_VERSION,
		"score": 0,
		"progression": {}
	}


func _normalize_data(raw_data) -> Dictionary:
	var normalized := _default_data()
	if typeof(raw_data) != TYPE_DICTIONARY:
		return normalized

	if raw_data.has("score"):
		normalized["score"] = int(raw_data["score"])
	if raw_data.has("progression") and typeof(raw_data["progression"]) == TYPE_DICTIONARY:
		normalized["progression"] = raw_data["progression"]

	normalized["schema_version"] = CURRENT_SCHEMA_VERSION
	return normalized
