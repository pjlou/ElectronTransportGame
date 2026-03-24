extends Node2D

var include_option = 0

func _ready() -> void:
	pass

func _on_all_check_box_pressed() -> void:
	if $allCheckBox.button_pressed == false:
		$allCheckBox.button_pressed = true
	else:
		$defaultsCheckBox.button_pressed = false
		$customsCheckBox.button_pressed = false
		$favoritesCheckBox.button_pressed = false


func _on_defaults_check_box_pressed() -> void:
	if $defaultsCheckBox.button_pressed == false:
		$defaultsCheckBox.button_pressed = true
	else:
		$allCheckBox.button_pressed = false
		$customsCheckBox.button_pressed = false
		$favoritesCheckBox.button_pressed = false


func _on_customs_check_box_pressed() -> void:
	if $customsCheckBox.button_pressed == false:
		$customsCheckBox.button_pressed = true
	else:
		$allCheckBox.button_pressed = false
		$defaultsCheckBox.button_pressed = false
		$favoritesCheckBox.button_pressed = false


func _on_favorites_check_box_pressed() -> void:
	if $favoritesCheckBox.button_pressed == false:
		$favoritesCheckBox.button_pressed = true
	else:
		$allCheckBox.button_pressed = false
		$defaultsCheckBox.button_pressed = false
		$customsCheckBox.button_pressed = false

func _on_mult_choice_check_box_pressed() -> void:
	if $multChoiceCheckBox.button_pressed == false:
		$multChoiceCheckBox.button_pressed = true
	else:
		$fillInBlankCheckBox.button_pressed = false

func _on_fill_in_blank_check_box_pressed() -> void:
	if $fillInBlankCheckBox.button_pressed == false:
		$fillInBlankCheckBox.button_pressed = true
	else:
		$multChoiceCheckBox.button_pressed = false

func _on_replay_yes_check_box_pressed() -> void:
	if $replayYesCheckBox.button_pressed == false:
		$replayYesCheckBox.button_pressed = true
	else:
		$replayNoCheckBox.button_pressed = false

func _on_replay_no_check_box_pressed() -> void:
	if $replayNoCheckBox.button_pressed == false:
		$replayNoCheckBox.button_pressed = true
	else:
		$replayYesCheckBox.button_pressed = false


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardMenu.tscn")
	# add persistence of settings change here
