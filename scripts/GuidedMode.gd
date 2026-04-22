extends Node2D

var textbox
var pauseMenu
var pauseButton
var pauseLayer

var isPaused = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	textbox = find_child("Textbox", true, false)
	pauseLayer = find_child("PauseLayer", true, false)
	
	if pauseLayer:
		pauseLayer.layer = 100
		pauseMenu = pauseLayer.find_child("PauseMenu3", true, false)
		pauseButton = pauseLayer.find_child("PauseButton", true, false)
		
		if pauseMenu:
			pauseMenu.hide()
		if pauseButton:
			pauseButton.show()
			pauseButton.pressed.connect(_on_pause_pressed)
		
		var resume_btn = pauseLayer.find_child("ResumeButton", true, false)
		var menu_btn = pauseLayer.find_child("MainMenuButton", true, false)
		if resume_btn:
			resume_btn.pressed.connect(_on_resume_pressed)
		if menu_btn:
			menu_btn.pressed.connect(_on_main_menu_pressed)

func _on_pause_pressed():
	print("PAUSE BUTTON CLICKED")
	_pause_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("esc"):
		if get_tree().paused:
			_resume_game()
		else:
			_pause_game()

func _pause_game():
	print("PAUSING GAME")
	isPaused = true
	get_tree().paused = true
	if textbox and "game_paused_by_menu" in textbox:
		textbox.game_paused_by_menu = true
		textbox.tween.pause()
	if pauseMenu:
		pauseMenu.show()
	if pauseButton:
		pauseButton.hide()

func _resume_game():
	print("RESUMING GAME")
	isPaused = false
	if textbox and "game_paused_by_menu" in textbox:
		textbox.game_paused_by_menu = false
		textbox.tween.play()
	if pauseMenu:
		pauseMenu.hide()
	if pauseButton:
		pauseButton.show()
	if textbox and textbox.curState == textbox.State.PRINTING or textbox.curState == textbox.State.FINISHED:
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_resume_pressed():
	_resume_game()

func _on_main_menu_pressed():
	print("GOING TO MAIN MENU")
	isPaused = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")
