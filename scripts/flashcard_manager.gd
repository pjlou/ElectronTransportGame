extends Node2D

@onready var question_label: Label = get_node_or_null("animatedBackground/questionPanel/questionLabel")
@onready var answer_buttons: Array[Button] = [
	$animatedBackground/answer1,
	$animatedBackground/answer2,
	$animatedBackground/answer3,
	$animatedBackground/answer4
]
@onready var fill_answer_entry = $animatedBackground/fillAnswerEntry
@onready var fill_answer_button = $animatedBackground/fillAnswerButton
@onready var fill_answer_status = $animatedBackground/fillAnswerStatus
@onready var score_label: Label = get_node_or_null("animatedBackground/questionPanel/ScoreLabel")
@onready var refresh: Button = get_node_or_null("animatedBackground/questionPanel/RefreshFlash")
@onready var mascot_good: Sprite2D = get_node_or_null("animatedBackground/leaderboardMascotHolder/mascotGood")
@onready var mascot_bad: Sprite2D = get_node_or_null("animatedBackground/leaderboardMascotHolder/mascotBad")
@onready var mascot_reg: Sprite2D = get_node_or_null("animatedBackground/leaderboardMascotHolder/MascotReg")

@onready var correct_style: StyleBox = preload("res://assets/art/correctAnswerButton.tres")
@onready var incorrect_style: StyleBox = preload("res://assets/art/incorrectAnswerButton.tres")
@onready var default_style: StyleBox = preload("res://assets/art/stylizedBox.tres")
@onready var hover_style: StyleBox = preload("res://assets/art/hoverButton.tres")

var loader = preload("res://scripts/flashcard_loader.gd").new()

var default_hover_font_color: Color
var flashcards: Array = []
var customFlashcards: Array = []
var defaultFlashcards: Array = []
var missed: Array = []
var settings: Dictionary = {}
var current_index: int = 0
var total_flash: int = 0
var score: int = 0
@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	default_hover_font_color = answer_buttons[0].get_theme_color("font_hover_color")
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)

	var loader = preload("res://scripts/flashcard_loader.gd").new()
	loader.preLoad()
	flashcards = loader.get_filtered_flashcards()
	defaultFlashcards = loader.get_default_flashcards()
	customFlashcards = loader.get_custom_flashcards()
	total_flash = flashcards.size()
	settings = loader.get_settings()
	#score_label.text = "Score: %d/%d" % [score, total_flash]

	show_flashcard(current_index)
	refresh.text = "Refresh Flashcards"
	refresh.pressed.connect(refresh_flashcards)
	mascot_good.visible = false
	mascot_bad.visible = false
	mascot_reg.visible = true
	
	if settings['answerType'] == 1:
		# hide multiple choice options
		for button in answer_buttons:
			button.visible = false
		# show fill-in-the-blank
		fill_answer_entry.visible = true
		fill_answer_button.visible = true
		fill_answer_entry.add_theme_font_size_override("font_size", 48)
		fill_answer_entry.keep_editing_on_text_submit = true

func show_flashcard(index: int) -> void:
	if index >= flashcards.size():
		if settings['replayIncorrectlyAnsweredCards']==1 or missed.size()==0:
			question_label.text = "Well done! You've completed all flashcards."
			for button in answer_buttons:
				button.visible = false
			fill_answer_entry.visible = false
			fill_answer_button.visible = false
			return
		else:
			current_index = 0
			index = 0
			flashcards = missed
			missed = []

	var card: Dictionary = flashcards[index]
	question_label.text = card["question"]

	for i in range(answer_buttons.size()):
		var btn: Button = answer_buttons[i]
		btn.text = card["choices"][i]
		btn.disabled = false

		# Reset to the original theme style instead of removing
		btn.add_theme_stylebox_override("normal", default_style)
		btn.add_theme_stylebox_override("hover", hover_style)
		btn.add_theme_color_override("font_hover_color", default_hover_font_color)

		if btn.is_connected("pressed", Callable(self, "_on_answer_pressed")):
			btn.disconnect("pressed", Callable(self, "_on_answer_pressed"))
		btn.pressed.connect(Callable(self, "_on_answer_pressed").bind(card["choices"][i], card["answer"], btn))

	if settings["answerType"] == 1:
		# Reset to the original theme style instead of removing
		fill_answer_button.add_theme_stylebox_override("normal", default_style)
		fill_answer_button.add_theme_stylebox_override("hover", hover_style)
		fill_answer_button.add_theme_color_override("font_hover_color", default_hover_font_color)
		
		fill_answer_status.text = "Enter your answer above"
		fill_answer_entry.text = ""
		fill_answer_entry.edit()

func refresh_flashcards() -> void:
	score = 0
	current_index = 0
	missed = []

	var loader = preload("res://scripts/flashcard_loader.gd").new()
	loader.preLoad()
	flashcards = loader.get_filtered_flashcards()
	total_flash = flashcards.size()

	#score_label.text = "Score: %d/%d" % [score, total_flash]
	show_flashcard(current_index)

	if settings['answerType'] == 0:
		for btn in answer_buttons:
			btn.visible = true

func calculate_next_review(isCorrect: bool):
	var card = flashcards[current_index]
	card["isNew"] = false
	card["lastReview"] = Time.get_datetime_dict_from_system()
	var nextReviewTime
	var q
	# use SM-2 learning algorithm where I(n) is I(n-1) * Ease Factor
	# wherease Ease Factor (EF) is EF + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
	# see en.wikipedia.org/wiki/SuperMemo for more information
	if not card.has("EF"):
		# EF is 2.5 initially
		card["EF"] = 2.5
	if isCorrect: 
		# assume user rates correct response as "correct with hesitation" (q value of 4)
		q = 4
		if card["correctStreak"] == 0:
			# next review is in one day, converted to seconds for unix time
			nextReviewTime = Time.get_unix_time_from_system() + 24 * 60 * 60
		elif card["correctStreak"] == 1:
			# next review is in six days, converted to seconds for unix time
			nextReviewTime = Time.get_unix_time_from_system() + 24 * 60 * 60
		else:
			nextReviewTime = Time.get_unix_time_from_system() + (24 * 60 * 60) * card["EF"]
		card["correctStreak"] += 1
	else:
		# assume user rates incorrect response as familiar upon seeing the correct answer (q value of 1)
		q = 1
		# user is expected to review until getting it correct, so the next review time is the current time
		nextReviewTime = Time.get_unix_time_from_system()
		card["correctStreak"] = 0
	card["nextReview"] = Time.get_datetime_dict_from_unix_time(nextReviewTime)
	card["EF"] =  card["EF"] + (0.1 - (5 - q) * (0.08 + (5 - q) * 0.02))
	if card["EF"] < 1.3:
		card["EF"] = 1.3
	save_card_data(card)

func save_card_data(card):
	var questionDir
	if card["isCustom"]:
		questionDir = loader.customQuestionsDir
	else:
		questionDir = loader.defaultQuestionsDir
	var save_file = FileAccess.open(questionDir, FileAccess.WRITE)
	# JSON provides a static method to serialized JSON string.
	var json_string
	if card["isCustom"]:
		json_string = JSON.stringify(customFlashcards)
	else:
		json_string = JSON.stringify(defaultFlashcards)
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)
	print("Wrote to " + questionDir)

func _on_answer_pressed(selected: String, correct: String, button: Button) -> void:
	var normal_font_color := button.get_theme_color("font_color")
	if selected == correct:
		#score += 1
		button.add_theme_stylebox_override("normal", correct_style)
		button.add_theme_stylebox_override("hover", correct_style)
		button.add_theme_color_override("font_hover_color", normal_font_color)
		mascot_good.visible = true
		mascot_bad.visible = false
		calculate_next_review(true)
	else:
		missed.append(flashcards[current_index])
		button.add_theme_stylebox_override("normal", incorrect_style)
		button.add_theme_stylebox_override("hover", incorrect_style)
		button.add_theme_color_override("font_hover_color", normal_font_color)
		mascot_good.visible = false
		mascot_bad.visible = true
		calculate_next_review(false)

	mascot_reg.visible = false
	#score_label.text = "Score: %d/%d" % [score, total_flash]

	for b in answer_buttons:
		#b.disabled = true
		if b.text == correct:
			b.add_theme_stylebox_override("normal", correct_style)
			b.add_theme_stylebox_override("hover", correct_style)
			b.add_theme_color_override("font_hover_color", b.get_theme_color("font_color"))
		print(b.mouse_filter)
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE

	timer.wait_time = 1.0
	timer.start()

func _on_fill_answer_entry_text_submitted(answer: String) -> void:
	var normal_font_color = fill_answer_button.get_theme_color("font_color")
	var isCorrect
	if answer.to_lower() == flashcards[current_index]["answer"].to_lower():
		#score += 1
		isCorrect = true
		fill_answer_button.add_theme_stylebox_override("normal", correct_style)
		fill_answer_button.add_theme_stylebox_override("hover", correct_style)
		fill_answer_button.add_theme_color_override("font_hover_color", normal_font_color)
		fill_answer_status.text = ""
		mascot_good.visible = true
		mascot_bad.visible = false
		calculate_next_review(true)
	elif answer.to_lower().similarity(flashcards[current_index]["answer"].to_lower()) > 0.8:
		fill_answer_status.text = "Close! Check your spelling."
		fill_answer_entry.grab_focus()
		fill_answer_entry.edit()
		return
	else:
		missed.append(flashcards[current_index])
		isCorrect = false
		fill_answer_button.add_theme_stylebox_override("normal", incorrect_style)
		fill_answer_button.add_theme_stylebox_override("hover", incorrect_style)
		fill_answer_button.add_theme_color_override("font_hover_color", normal_font_color)
		fill_answer_status.text = "Correct Answer: " + flashcards[current_index]["answer"]
		mascot_good.visible = false
		mascot_bad.visible = true
		calculate_next_review(false)

	mascot_reg.visible = false
	#score_label.text = "Score: %d/%d" % [score, total_flash]
	
	# longer wait time for wrong answers
	if isCorrect:
		timer.wait_time = 1.0
	else:
		timer.wait_time = 2.0
	timer.start()

func _on_timer_timeout() -> void:
	mascot_good.visible = false
	mascot_bad.visible = false
	mascot_reg.visible = true
	for b in answer_buttons:
		b.mouse_filter = Control.MOUSE_FILTER_STOP

	current_index += 1
	show_flashcard(current_index)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")
