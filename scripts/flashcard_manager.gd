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
@onready var mascot_good: Sprite2D = get_node_or_null("animatedBackground/leaderboardMascotHolder/mascotGood")
@onready var mascot_bad: Sprite2D = get_node_or_null("animatedBackground/leaderboardMascotHolder/mascotBad")
@onready var mascot_reg: Sprite2D = get_node_or_null("animatedBackground/leaderboardMascotHolder/MascotReg")


@onready var correct_style: StyleBox = preload("res://assets/art/correctAnswerButton.tres")
@onready var incorrect_style: StyleBox = preload("res://assets/art/incorrectAnswerButton.tres")
@onready var default_style: StyleBox = preload("res://assets/art/stylizedBox.tres")

var flashcards: Array = []
var current_index: int = 0
var total_flash: int = 0
var score: int = 0
@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(_on_timer_timeout)

	var loader = preload("res://scripts/flashcard_loader.gd").new()
	loader.preLoad()
	flashcards = loader.get_flashcards()
	total_flash = flashcards.size()
	#score_label.text = "Score: %d/%d" % [score, total_flash]

	show_flashcard(current_index)
	refresh.text = "Refresh Flashcards"
	refresh.pressed.connect(refresh_flashcards)
	mascot_good.visible = false
	mascot_bad.visible = false
	mascot_reg.visible = true


func show_flashcard(index: int) -> void:
	if index >= flashcards.size():
		question_label.text = "Well done! You've completed all flashcards."
		for button in answer_buttons:
			button.visible = false
		return

	var card: Dictionary = flashcards[index]
	question_label.text = card["question"]

	for i in range(answer_buttons.size()):
		var btn: Button = answer_buttons[i]
		btn.text = card["choices"][i]
		btn.disabled = false

		# Reset to the original theme style instead of removing
		btn.add_theme_stylebox_override("normal", default_style)

		if btn.is_connected("pressed", Callable(self, "_on_answer_pressed")):
			btn.disconnect("pressed", Callable(self, "_on_answer_pressed"))
		btn.pressed.connect(Callable(self, "_on_answer_pressed").bind(card["choices"][i], card["answer"], btn))

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
	if selected == correct:
		#score += 1
		button.add_theme_stylebox_override("normal", correct_style)
		mascot_good.visible = true
		mascot_bad.visible = false
	else:
		button.add_theme_stylebox_override("normal", incorrect_style)
		mascot_good.visible = false
		mascot_bad.visible = true

	mascot_reg.visible = false
	#score_label.text = "Score: %d/%d" % [score, total_flash]

	for b in answer_buttons:
		#b.disabled = true
		if b.text == correct:
			b.add_theme_stylebox_override("normal", correct_style)

	timer.wait_time = 1.0
	timer.start()

func _on_timer_timeout() -> void:
	mascot_good.visible = false
	mascot_bad.visible = false
	mascot_reg.visible = true

	current_index += 1
	show_flashcard(current_index)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")
