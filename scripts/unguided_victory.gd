extends Node

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var initials_input = $InputInitials
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("Pleasesendhelp")
	print("Final score: ", Globals.score)


func _on_button_pressed() -> void:
	var initials = initials_input.text.strip_edges()
	if initials == "":
		initials = "Anon"  # Default initials if nothing entered
	
	if initials.length() > 5:
		initials = initials.substr(0, 5)  # Cut at 5 characters
	# Create/open the file for writing
	var lbpath = "user://scores.txt"
	if not FileAccess.file_exists(lbpath):
		FileAccess.open(lbpath,FileAccess.WRITE)
	var file = FileAccess.open("user://scores.txt", FileAccess.READ_WRITE)
	if file:
		file.seek_end()  # Move to end of the file to append
		var score = Globals.score
		file.store_line(initials + ": " + str(score))
		file.close()
	else:
		print("Failed to open file!")
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")
	#get_tree().change_scene_to_file("res://scenes/startScreen.tscn")
