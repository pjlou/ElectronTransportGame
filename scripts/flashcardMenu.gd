extends Node2D

var buttons := []
var selected_button = null

func _ready() -> void:
	pass

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardMode.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardSettings.tscn")

func _on_view_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardView.tscn")

func _on_edit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/customFlashcards.tscn")
