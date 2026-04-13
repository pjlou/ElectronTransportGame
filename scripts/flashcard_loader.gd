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
		add_review_info(flashcard)
	print("Default flashcards loaded successfully!")

func load_custom_flashcards(fileLoc):

	var result = load_json(fileLoc)

	if typeof(result) != TYPE_ARRAY:
		printerr("Custom flashcard JSON should be an array.")
		return

	custom_flashcards = result
	for flashcard in custom_flashcards:
		flashcard["isCustom"] = true
		add_review_info(flashcard)
	print("Custom flashcards loaded successfully!")

func add_review_info(card):
	if not card.has("isNew"):
		card["isNew"] = true
	if not card.has("lastReview"):
		card["lastReview"] = Time.get_datetime_dict_from_unix_time(0)
	if not card.has("nextReview"):
		card["nextReview"] = Time.get_datetime_dict_from_system()
	if not card.has("correctStreak"):
		card["correctStreak"] = 0

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
	if not settings.has("isReview"):
		settings["isReview"] = 0
	print(settings["isReview"])
	if settings["isReview"] == 1:
		var reviewFlashcards: Array = []
		for card in flashcards:
			if (Time.get_unix_time_from_datetime_dict(card["nextReview"]) - Time.get_unix_time_from_system()) <= 0:
				reviewFlashcards.append(card)
		flashcards = reviewFlashcards
	

func get_flashcards() -> Array:
	return all_flashcards
	
func get_default_flashcards() -> Array:
	return default_flashcards
	
func get_custom_flashcards() -> Array:
	return custom_flashcards

func get_filtered_flashcards() -> Array:
	return flashcards

func get_settings() -> Dictionary:
	return settings
