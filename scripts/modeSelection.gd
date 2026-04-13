extends Node2D

func _ready() -> void:
	pass

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/startScreen.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")

func _on_guided_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/guidedMode.tscn")

func _on_unguided_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/unguidedMode.tscn")

func _on_flashcard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardMenu.tscn")
