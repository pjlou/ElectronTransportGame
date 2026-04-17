extends CanvasLayer

const CHAR_SHOW_RATE = 0.03

@onready var fullBox = $FullBoxSize
@onready var startSymbol = $FullBoxSize/TextMargins/HBoxContainer/Start
@onready var endSymbol = $FullBoxSize/TextMargins/HBoxContainer/End
@onready var textLabel = $FullBoxSize/TextMargins/HBoxContainer/Text

enum State {
	READY,
	PRINTING,
	FINISHED
}

var curState = State.READY
var tween: Tween
var textQueue = []
var textFilePath = "res://data/guidedDialogue/guided1.txt"
var game_paused_by_menu = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hideText()
	load_text_from_file()

func _process(_delta: float) -> void:
	if game_paused_by_menu:
		return
	match curState:
		State.READY:
			if !textQueue.is_empty():
				get_tree().paused = true
				addText()
		State.PRINTING:
			if Input.is_action_just_pressed("ui_accept"):
				textLabel.visible_ratio = 1.0
				tween.kill()
				endSymbol.text = ">"
				changeState(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				if textQueue.is_empty():
					get_tree().paused = false
					hide()
				changeState(State.READY)

func load_text_from_file() -> void:
	textQueue.clear()
	if textFilePath.is_empty():
		printerr("Text file path is not set!")
		return
	if not FileAccess.file_exists(textFilePath):
		print("Text file not found at path: ", textFilePath)
		return
	var file = FileAccess.open(textFilePath, FileAccess.READ)
	if file == null:
		print("Failed to open text file: ", FileAccess.get_open_error())
		return
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		if not line.is_empty():
			textQueue.push_back(line)
	file.close()
	print("Loaded %d lines from %s" % [textQueue.size(), textFilePath])

func hideText():
	startSymbol.text = ""
	endSymbol.text = ""
	textLabel.text = ""
	fullBox.hide()

func showText():
	startSymbol.text = "-"
	fullBox.show()

func addText():
	var nextText = textQueue.pop_front()
	textLabel.text = nextText
	changeState(State.PRINTING)
	showText()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(textLabel, "visible_ratio", 1.0, len(nextText) * CHAR_SHOW_RATE).from(0)
	tween.connect("finished", _on_tween_completed)

func _on_tween_completed():
	endSymbol.text = ">"
	changeState(State.FINISHED)

func changeState(nextState):
	curState = nextState
	match curState:
		State.READY:
			print('Changing to State.READY')
		State.PRINTING:
			print('Changing to State.PRINTING')
		State.FINISHED:
			print('Changing to State.FINISHED')
