extends Node2D

var buttons := []
var selected_button = null

func _ready() -> void:
	buttons = [
		$animatedBackground/guidedButton,
		$animatedBackground/unguidedButton,
		$animatedBackground/flashcardButton
	]
	for button in buttons:
		button.toggle_mode = true
		button.toggled.connect(func(pressed): _on_button_toggled(pressed, button))
	$animatedBackground/guidedButton.set_meta("scene_path", "res://scenes/guidedMode.tscn")
	$animatedBackground/unguidedButton.set_meta("scene_path", "res://scenes/unguidedMode.tscn")
	$animatedBackground/flashcardButton.set_meta("scene_path", "res://scenes/flashcardMode.tscn")

func _on_button_toggled(button_pressed: bool, toggled_button):
	if button_pressed:
		for b in buttons:
			if b != toggled_button:
				b.button_pressed = false
		selected_button = toggled_button
		print("Selected:", toggled_button.name)
		$animatedBackground/playButton.disabled = false

func _on_play_button_pressed():
	if selected_button:
		var scene_path = selected_button.get_meta("scene_path")
		print("Scene path selected:", scene_path)
		get_tree().change_scene_to_file(scene_path)
	else:
		print("No button selected")

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/startScreen.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
