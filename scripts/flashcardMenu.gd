extends Node2D

var buttons := []
var selected_button = null

func _ready() -> void:
	buttons = [
		$startButton,
		$settingsButton,
		$viewButton,
		$editButton,
	]
	for button in buttons:
		button.toggle_mode = true
		button.toggled.connect(func(pressed): _on_button_toggled(pressed, button))
	$startButton.set_meta("scene_path", "res://scenes/flashcardMode.tscn")
	$settingsButton.set_meta("scene_path", "res://scenes/flashcardSettings.tscn")
	$viewButton.set_meta("scene_path", "res://scenes/flashcardView.tscn")
	$editButton.set_meta("scene_path", "res://scenes/flashcardEdit.tscn")

func _on_button_toggled(button_pressed: bool, toggled_button):
	if button_pressed:
		for b in buttons:
			if b != toggled_button:
				b.button_pressed = false
		selected_button = toggled_button
		print("Selected:", toggled_button.name)
		$playButton.disabled = false

func _on_play_button_pressed():
	if selected_button:
		var scene_path = selected_button.get_meta("scene_path")
		print("Scene path selected:", scene_path)
		get_tree().change_scene_to_file(scene_path)
	else:
		print("No button selected")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardMode.tscn")
