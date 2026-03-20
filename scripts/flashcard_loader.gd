extends Node

var flashcards: Array = []

var settings: Dictionary = {}

var exePath = OS.get_executable_path()
var exeDir = exePath.get_base_dir()
var questionsDir = exeDir.path_join("questions.json")
var settingsDir = exeDir.path_join("flashcardsettings.json")
	

func preLoad():
	if FileAccess.file_exists(questionsDir):
		load_flashcards(questionsDir)
	else:
		load_flashcards("res://data/questions.json")
	if FileAccess.file_exists(settingsDir):
		load_settings(settingsDir)
	else:
		load_settings("res://data/flashcardsettings.json")
		
		

func load_json(fileLoc):
	var file := FileAccess.open(fileLoc, FileAccess.READ)
	if file == null:
		printerr("Failed to open JSON.")
		return

	var content := file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	return result
	
func load_flashcards(fileLoc):

	var result = load_json(fileLoc)

	if typeof(result) != TYPE_ARRAY:
		printerr("Flashcard JSON should be an array.")
		return

	flashcards = result
	print("Flashcards loaded successfully!")

func load_settings(fileLoc):
	var result = load_json(fileLoc)
	
	if typeof(result) != TYPE_DICTIONARY:
		printerr("Settings JSON should be a dictionary.")
		return
		
	settings = result
	for key in settings:
		settings[key] = int(key)
	print("Settings loaded successfully!")
	

func get_flashcards() -> Array:
	return flashcards

func get_settings() -> Dictionary:
	return settings
