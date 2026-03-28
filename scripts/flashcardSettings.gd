extends Node2D

var include_option = 0
var loader = preload("res://scripts/flashcard_loader.gd").new()
var settings: Dictionary = {}

func _ready() -> void:
	load_settings()
	settings_to_checkboxes()
	
func load_settings():
	loader.preLoad()
	settings = loader.get_settings()

func save_settings():
	var save_file = FileAccess.open(loader.settingsDir, FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(settings)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	
func settings_to_checkboxes():
	if settings["flashcardsToInclude"] == 0:
		_on_all_check_box_pressed()
	elif settings["flashcardsToInclude"] == 1:
		_on_defaults_check_box_pressed()
	elif settings["flashcardsToInclude"] == 2:
		_on_customs_check_box_pressed()
	elif settings["flashcardsToInclude"] == 3:
		_on_favorites_check_box_pressed()
	else:
		printerr("Flashcard settings error. Defaulting to All.")
		_on_all_check_box_pressed()
	
	if settings["answerType"] == 1:
		_on_fill_in_blank_check_box_pressed()
	elif settings["answerType"] == 0:
		_on_mult_choice_check_box_pressed()
	else:
		printerr("Flashcard settings error. Defaulting to Multiple Choice.")
		_on_mult_choice_check_box_pressed()
		
	if settings["replayIncorrectlyAnsweredCards"] == 1:
		_on_replay_no_check_box_pressed()
	elif settings["replayIncorrectlyAnsweredCards"] == 0:
		_on_replay_yes_check_box_pressed()
	else:
		printerr("Flashcard settings error. Defaulting to No Replay.")
		_on_replay_no_check_box_pressed()
			
func _on_all_check_box_pressed() -> void:
	settings["flashcardsToInclude"] = 0
	save_settings()
	if $allCheckBox.button_pressed == false:
		$allCheckBox.button_pressed = true
	else:
		$defaultsCheckBox.button_pressed = false
		$customsCheckBox.button_pressed = false
		$favoritesCheckBox.button_pressed = false


func _on_defaults_check_box_pressed() -> void:
	settings["flashcardsToInclude"] = 1
	save_settings()
	if $defaultsCheckBox.button_pressed == false:
		$defaultsCheckBox.button_pressed = true
		
	else:
		$allCheckBox.button_pressed = false
		$customsCheckBox.button_pressed = false
		$favoritesCheckBox.button_pressed = false


func _on_customs_check_box_pressed() -> void:
	settings["flashcardsToInclude"] = 2
	save_settings()
	if $customsCheckBox.button_pressed == false:
		$customsCheckBox.button_pressed = true
	else:
		$allCheckBox.button_pressed = false
		$defaultsCheckBox.button_pressed = false
		$favoritesCheckBox.button_pressed = false


func _on_favorites_check_box_pressed() -> void:
	settings["flashcardsToInclude"] = 3
	save_settings()
	if $favoritesCheckBox.button_pressed == false:
		$favoritesCheckBox.button_pressed = true
	else:
		$allCheckBox.button_pressed = false
		$defaultsCheckBox.button_pressed = false
		$customsCheckBox.button_pressed = false

func _on_mult_choice_check_box_pressed() -> void:
	settings["answerType"] = 0
	save_settings()
	if $multChoiceCheckBox.button_pressed == false:
		$multChoiceCheckBox.button_pressed = true
	else:
		$fillInBlankCheckBox.button_pressed = false

func _on_fill_in_blank_check_box_pressed() -> void:
	settings["answerType"] = 1
	save_settings()
	if $fillInBlankCheckBox.button_pressed == false:
		$fillInBlankCheckBox.button_pressed = true
	else:
		$multChoiceCheckBox.button_pressed = false

func _on_replay_yes_check_box_pressed() -> void:
	settings["replayIncorrectlyAnsweredCards"] = 0
	save_settings()
	if $replayYesCheckBox.button_pressed == false:
		$replayYesCheckBox.button_pressed = true
	else:
		$replayNoCheckBox.button_pressed = false

func _on_replay_no_check_box_pressed() -> void:
	settings["replayIncorrectlyAnsweredCards"] = 1
	save_settings()
	if $replayNoCheckBox.button_pressed == false:
		$replayNoCheckBox.button_pressed = true
	else:
		$replayYesCheckBox.button_pressed = false


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardMenu.tscn")
	# add persistence of settings change here
