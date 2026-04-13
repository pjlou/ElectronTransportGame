extends Node2D

var buttons := []
var selected_button = null
var flashcards: Array = []
var loader = preload("res://scripts/flashcard_loader.gd").new()
var settingsScript = preload("res://scripts/flashcardSettings.gd").new()
var settings

func _ready() -> void:
	loader.preLoad()
	settings = loader.get_settings()
	settings["isReview"] = 1
	flashcards = loader.get_filtered_flashcards()
	if flashcards.size() == 0:
		showReviewOption(false)
		return
	var currentTime = Time.get_unix_time_from_system()
	var cardsToReview = 0
	var nextReviewTime = 0
	for card in flashcards:
		var cardReviewTime =  Time.get_unix_time_from_datetime_dict(card["nextReview"])
		if nextReviewTime == 0:
			nextReviewTime = cardReviewTime
		if (not card["isNew"]) and (cardReviewTime < nextReviewTime):
			nextReviewTime = cardReviewTime
		if not card["isNew"] and Time.get_unix_time_from_datetime_dict(card["nextReview"]) < currentTime:
			cardsToReview += 1
	if cardsToReview > 0:
		$reviewReadyText.text = str(cardsToReview) + " cards to review"
		showReviewOption(true)
	elif nextReviewTime > currentTime:
		var nextReviewInterval = nextReviewTime - currentTime
		var nextReviewDays
		var nextReviewHours
		var nextReviewMinutes
		if nextReviewInterval > 86400:
			nextReviewDays = int(nextReviewInterval/86400)
			$reviewReadyText.text = "Next review is in " + str(nextReviewDays) + " days"
		elif nextReviewInterval > 3600:
			nextReviewHours = int(nextReviewInterval/3600)
			$reviewReadyText.text = "Next review is in " + str(nextReviewHours) + " hours"
		else:
			nextReviewMinutes = int(nextReviewInterval/60)
			$reviewReadyText.text = "Next review is in " + str(nextReviewHours) + " minutes"
		showReviewOption(true)
		
	else:
		$reviewReadyText.text = "No cards to review"
		# Hide option to review
		showReviewOption(false)

func showReviewOption(isVisible):
	$reviewReadyText.visible = isVisible
	$reviewButton.visible = isVisible

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func _on_start_button_pressed() -> void:
	settings["isReview"] = 0
	var save_file = FileAccess.open(loader.settingsDir, FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(settings)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	get_tree().change_scene_to_file("res://scenes/flashcardMode.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardSettings.tscn")

func _on_view_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardView.tscn")

func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/customFlashcards.tscn")


func _on_review_button_pressed() -> void:
	settings["isReview"] = 1
	var save_file = FileAccess.open(loader.settingsDir, FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(settings)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	get_tree().change_scene_to_file("res://scenes/flashcardMode.tscn")
