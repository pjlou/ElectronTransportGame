extends Node

var default_flashcards: Array = []
var custom_flashcards: Array = [] 
var flashcards: Array = []
var all_flashcards: Array = []

var settings: Dictionary = {}

var exePath = OS.get_executable_path()
var exeDir = exePath.get_base_dir()
var defaultQuestionsDir = exeDir.path_join("questions.json")
var customQuestionsDir = exeDir.path_join("customquestions.json")
var settingsDir = exeDir.path_join("flashcardsettings.json")

func preLoad():
	if FileAccess.file_exists(settingsDir):
		load_settings(settingsDir)
	else:
		load_settings("res://data/flashcardsettings.json")
	if FileAccess.file_exists(defaultQuestionsDir):
		load_default_flashcards(defaultQuestionsDir)
	else:
		load_default_flashcards("res://data/questions.json")
	if FileAccess.file_exists(customQuestionsDir):
		load_custom_flashcards(customQuestionsDir)
	else:
		load_custom_flashcards("res://data/customquestions.json")
	all_flashcards = default_flashcards + custom_flashcards
	filter_flashcards()

func load_json(fileLoc):
	var file := FileAccess.open(fileLoc, FileAccess.READ)
	if file == null:
		printerr("Failed to open JSON.")
		return

	var content := file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	return result
	
func load_default_flashcards(fileLoc):

	var result = load_json(fileLoc)

	if typeof(result) != TYPE_ARRAY:
		printerr("Default flashcard JSON should be an array.")
		return

	default_flashcards = result
	for flashcard in default_flashcards:
		flashcard["isCustom"] = false
	print("Default flashcards loaded successfully!")

func load_custom_flashcards(fileLoc):

	var result = load_json(fileLoc)

	if typeof(result) != TYPE_ARRAY:
		printerr("Custom flashcard JSON should be an array.")
		return

	custom_flashcards = result
	for flashcard in custom_flashcards:
		flashcard["isCustom"] = true
	print("Custom flashcards loaded successfully!")

func load_settings(fileLoc):
	var result = load_json(fileLoc)
	
	if typeof(result) != TYPE_DICTIONARY:
		printerr("Settings JSON should be a dictionary.")
		return
		
	settings = result
	for key in settings:
		settings[key] = int(settings[key])
	print("Settings loaded successfully!")

func filter_flashcards() -> void:
	var flashcardsToInclude = settings["flashcardsToInclude"]
	if flashcardsToInclude == 0:
		flashcards = default_flashcards + custom_flashcards
	elif flashcardsToInclude == 1:
		flashcards = default_flashcards
	elif flashcardsToInclude == 2:
		flashcards = custom_flashcards
	elif flashcardsToInclude == 3:
		for card in default_flashcards + custom_flashcards:
			if card["favorited"]:
				flashcards.append(card)
	else:
		printerr("Flashcard settings error")
	

func get_flashcards() -> Array:
	return all_flashcards

func get_filtered_flashcards() -> Array:
	return flashcards

func get_settings() -> Dictionary:
	return settings
