extends Node2D

@onready var question_label: Label = get_node_or_null("animatedBackground/questionPanel/questionLabel")
@onready var question_edit_field = $animatedBackground/questionPanel/questionEdit
@onready var answer_buttons: Array[Button] = [
	$animatedBackground/answer1,
	$animatedBackground/answer2,
	$animatedBackground/answer3,
	$animatedBackground/answer4
]
@onready var choice_fields: Array[LineEdit] = [
	$animatedBackground/choiceEdit1,
	$animatedBackground/choiceEdit2,
	$animatedBackground/choiceEdit3,
	$animatedBackground/choiceEdit4
]
@onready var favButton = $fav
@onready var editButton = $edit
@onready var score_label: Label = get_node_or_null("animatedBackground/questionPanel/ScoreLabel")
@onready var refresh: Button = get_node_or_null("animatedBackground/questionPanel/RefreshFlash")

@onready var correct_style: StyleBox = preload("res://assets/art/correctAnswerButton.tres")
@onready var incorrect_style: StyleBox = preload("res://assets/art/incorrectAnswerButton.tres")
@onready var default_style: StyleBox = preload("res://assets/art/stylizedBox.tres")
@onready var hover_style: StyleBox = preload("res://assets/art/hoverButton.tres")

var loader = preload("res://scripts/flashcard_loader.gd").new()

var default_hover_font_color: Color
var flashcards: Array = []
var current_index: int = 0
var total_flash: int = 0
var score: int = 0
var isEditMode = false
var correctAnswerIndex = 0

func _ready() -> void:
	default_hover_font_color = answer_buttons[0].get_theme_color("font_hover_color")

	loader.preLoad()
	flashcards = loader.get_flashcards()
	total_flash = flashcards.size()
	#score_label.text = "Score: %d/%d" % [score, total_flash]

	show_flashcard(current_index)


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
	question_label.visible = true
	if card["favorited"]:
		favButton.add_theme_stylebox_override("normal", correct_style)
		favButton.add_theme_stylebox_override("hover", correct_style)
		favButton.add_theme_color_override("font_hover_color", favButton.get_theme_color("font_color"))
	else:
		# Reset to the original theme style instead of removing
		favButton.add_theme_stylebox_override("normal", default_style)
		favButton.add_theme_stylebox_override("hover", hover_style)
		favButton.add_theme_color_override("font_hover_color", default_hover_font_color)

	for i in range(answer_buttons.size()):
		var btn: Button = answer_buttons[i]
		btn.text = card["choices"][i]
		btn.disabled = false
		btn.visible = true
		choice_fields[i].visible = false

		# Reset to the original theme style instead of removing
		btn.add_theme_stylebox_override("normal", default_style)
		btn.add_theme_stylebox_override("hover", hover_style)
		btn.add_theme_color_override("font_hover_color", default_hover_font_color)

		if btn.text == card["answer"]:
			correctAnswerIndex = i
		
		for b in answer_buttons:
			#b.disabled = true
			if b.text == card["answer"]:
				b.add_theme_stylebox_override("normal", correct_style)
				b.add_theme_stylebox_override("hover", correct_style)
				b.add_theme_color_override("font_hover_color", b.get_theme_color("font_color"))

	if isEditMode:
		disable_edit_mode()
		
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

func _on_fav_pressed() -> void:
	if not flashcards[current_index]["favorited"]:
		flashcards[current_index]["favorited"] = true
		save_settings(flashcards[current_index]["isCustom"])
		favButton.add_theme_stylebox_override("normal", correct_style)
		favButton.add_theme_stylebox_override("hover", correct_style)
		favButton.add_theme_color_override("font_hover_color", favButton.get_theme_color("font_color"))
	else:
		# Reset to the original theme style instead of removing
		flashcards[current_index]["favorited"] = false
		save_settings(flashcards[current_index]["isCustom"])
		favButton.add_theme_stylebox_override("normal", default_style)
		favButton.add_theme_stylebox_override("hover", hover_style)
		favButton.add_theme_color_override("font_hover_color", default_hover_font_color)

func _on_edit_pressed() -> void:
	if not isEditMode:
		enable_edit_mode()
	else:
		disable_edit_mode()
	
func save_settings(isCustom):
	var questionDir
	if isCustom:
		questionDir = loader.customQuestionsDir
	else:
		questionDir = loader.defaultQuestionsDir
	var save_file = FileAccess.open(questionDir, FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var json_string
	if isCustom:
		json_string = JSON.stringify(loader.custom_flashcards)
	else:
		json_string = JSON.stringify(loader.default_flashcards)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func enable_edit_mode():
	isEditMode = true
	editButton.add_theme_stylebox_override("normal", correct_style)
	editButton.add_theme_stylebox_override("hover", correct_style)
	editButton.add_theme_color_override("font_hover_color", favButton.get_theme_color("font_color"))
	for i in range(answer_buttons.size()):
		var btn: Button = answer_buttons[i]
		var field: LineEdit = choice_fields[i]
		btn.text = flashcards[current_index]["choices"][i]
		field.text = flashcards[current_index]["choices"][i]
		btn.text = ""
		field.visible = true
	question_label.visible = false
	question_edit_field.visible = true
	question_edit_field.text = flashcards[current_index]["question"]
	question_edit_field.grab_focus()
	question_edit_field.select_all()

func disable_edit_mode():
		isEditMode = false
		editButton.add_theme_stylebox_override("normal", default_style)
		editButton.add_theme_stylebox_override("hover", hover_style)
		editButton.add_theme_color_override("font_hover_color", default_hover_font_color)
		for i in range(answer_buttons.size()):
			var btn: Button = answer_buttons[i]
			var field: LineEdit = choice_fields[i]
			btn.text = flashcards[current_index]["choices"][i]
			field.text = flashcards[current_index]["choices"][i]
			btn.visible = true
			field.visible = false
		question_label.visible = true
		question_label.text = flashcards[current_index]["question"]
		question_edit_field.visible = false

func _on_question_edit_text_changed() -> void:
	flashcards[current_index]["question"] = question_edit_field.text
	save_settings(flashcards[current_index]["isCustom"])

func _on_choice_edit_1_text_changed(new_text: String) -> void:
	flashcards[current_index]["choices"][0] = $animatedBackground/choiceEdit1.text
	if correctAnswerIndex == 0:
		flashcards[current_index]["answer"] = $animatedBackground/choiceEdit1.text
	save_settings(flashcards[current_index]["isCustom"])

func _on_choice_edit_2_text_changed(new_text: String) -> void:
	flashcards[current_index]["choices"][1] = $animatedBackground/choiceEdit2.text
	if correctAnswerIndex == 1:
		flashcards[current_index]["answer"] = $animatedBackground/choiceEdit2.text
	save_settings(flashcards[current_index]["isCustom"])

func _on_choice_edit_3_text_changed(new_text: String) -> void:
	flashcards[current_index]["choices"][2] = $animatedBackground/choiceEdit3.text
	if correctAnswerIndex == 2:
		flashcards[current_index]["answer"] = $animatedBackground/choiceEdit3.text
	save_settings(flashcards[current_index]["isCustom"])

func _on_choice_edit_4_text_changed(new_text: String) -> void:
	flashcards[current_index]["choices"][3] = $animatedBackground/choiceEdit4.text
	if correctAnswerIndex == 3:
		flashcards[current_index]["answer"] = $animatedBackground/choiceEdit4.text
	save_settings(flashcards[current_index]["isCustom"])
