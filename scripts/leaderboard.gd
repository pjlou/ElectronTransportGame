extends Node2D
@onready var yourScore = $animatedBackground/YourScorePanel/YourScoreLabel2
@onready var topUngScore = $animatedBackground/LeadarboardScorePanel/unguidedScoreLabel
@onready var secUngScore = $animatedBackground/LeadarboardScorePanel/unguided2ScoreLabel
@onready var thirdUngScore = $animatedBackground/LeadarboardScorePanel/unguided3ScoreLabel

var score_label = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	output_score()
	top_scores()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_button_pressed() -> void:
	Globals.score=0
	get_tree().change_scene_to_file("res://scenes/startScreen.tscn")

func output_score():
	var file = FileAccess.open("res://scores/scores.txt", FileAccess.READ)
	var lines: Array = []
	var user_score = Globals.score
	yourScore.text=str(round(user_score))
	 
func top_scores():
	#func top_scores():
	var file = FileAccess.open("res://scores/scores.txt", FileAccess.READ)
	var score_entries: Array = []

	if file:
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			var parts = line.split(":")
			if parts.size() == 2:
				var initials = parts[0].strip_edges()
				var score = float(parts[1].strip_edges())
				score_entries.append({ "initials": initials, "score": score })
		file.close()
	else:
		print("Could not open score file.")

	# Sort by score descending
	score_entries.sort_custom(func(a, b): return b["score"] < a["score"])

	# Default values
	var first_text = "N/A"
	var second_text = "N/A"
	var third_text = "N/A"

	if score_entries.size() > 0:
		first_text = "%s : %.0f" % [score_entries[0]["initials"], score_entries[0]["score"]]
	if score_entries.size() > 1:
		second_text = "%s : %.0f" % [score_entries[1]["initials"], score_entries[1]["score"]]
	if score_entries.size() > 2:
		third_text = "%s : %.0f" % [score_entries[2]["initials"], score_entries[2]["score"]]

	# Output to labels
	topUngScore.text = first_text
	secUngScore.text = second_text
	thirdUngScore.text = third_text
