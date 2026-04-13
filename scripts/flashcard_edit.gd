extends Node2D

@onready var question_label: Label = get_node_or_null("animatedBackground/questionPanel/questionLabel")
@onready var answer_buttons: Array[Button] = [
	$animatedBackground/answer1,
	$animatedBackground/answer2,
	$animatedBackground/answer3,
	$animatedBackground/answer4
]
@onready var score_label: Label = get_node_or_null("animatedBackground/questionPanel/ScoreLabel")
@onready var refresh: Button = get_node_or_null("animatedBackground/questionPanel/RefreshFlash")

@onready var correct_style: StyleBox = preload("res://assets/art/correctAnswerButton.tres")
@onready var incorrect_style: StyleBox = preload("res://assets/art/incorrectAnswerButton.tres")
@onready var default_style: StyleBox = preload("res://assets/art/stylizedBox.tres")
@onready var hover_style: StyleBox = preload("res://assets/art/hoverButton.tres")

var default_hover_font_color: Color
var flashcards: Array = []
var current_index: int = 0
var total_flash: int = 0
var score: int = 0

func _ready() -> void:

	var loader = preload("res://scripts/flashcard_loader.gd").new()
	loader.preLoad()
	flashcards = loader.get_flashcards()
	total_flash = flashcards.size()
	#score_label.text = "Score: %d/%d" % [score, total_flash]

	show_flashcard(current_index)
	refresh.text = "Refresh Flashcards"
	refresh.pressed.connect(refresh_flashcards)


func show_flashcard(index: int) -> void:
	if index >= flashcards.size():
		index = 0
		current_index = 0
		show_flashcard(current_index)
	elif index < 0:
		index = flashcards.size() - 1
		current_index = flashcards.size() - 1
		show_flashcard(current_index)
	

	var card: Dictionary = flashcards[index]
	question_label.text = card["question"]

func refresh_flashcards() -> void:
	score = 0
	current_index = 0

	var loader = preload("res://scripts/flashcard_loader.gd").new()
	loader.preLoad()
	flashcards = loader.get_flashcards()
	total_flash = flashcards.size()

	#score_label.text = "Score: %d/%d" % [score, total_flash]
	show_flashcard(current_index)

	for btn in answer_buttons:
		btn.visible = true

func _on_answer_pressed(selected: String, correct: String, button: Button) -> void:
	pass

func _on_timer_timeout() -> void:
	pass

	current_index += 1
	show_flashcard(current_index)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/flashcardMenu.tscn")


func _on_prev_pressed() -> void:
	current_index -= 1
	show_flashcard(current_index)

func _on_next_pressed() -> void:
	current_index += 1
	show_flashcard(current_index)

func _on_edit_pressed() -> void:
	pass # Replace with function body.
