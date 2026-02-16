extends Node

var flashcards: Array = []

var exePath = OS.get_executable_path()
var exeDir = exePath.get_base_dir()
var jsonDir = exeDir.path_join("questions.json")
	

func preLoad():
	if FileAccess.file_exists(jsonDir):
		load_flashcards(jsonDir)
	else:
		load_flashcards("res://data/questions.json")
		


func load_flashcards(fileLoc):
	
	var file := FileAccess.open(fileLoc, FileAccess.READ)
	if file == null:
		printerr("Failed to open flashcard JSON.")
		return

	var content := file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)

	if typeof(result) != TYPE_ARRAY:
		printerr("Flashcard JSON should be an array.")
		return

	flashcards = result
	print("Flashcards loaded successfully!")

func get_flashcards() -> Array:
	return flashcards
