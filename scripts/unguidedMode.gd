extends Node2D

var nadh_scene = preload("res://scenes/nadh.tscn") # preload the scene
var fadh2_scene = preload("res://scenes/fadh2.tscn")
var rng = RandomNumberGenerator.new() # used for random hion positions when they spawn
var fadh2_nadh_spawn = Rect2(Vector2(50, 828), Vector2(900, 70)) # location boxes for spawning hion

var atp_made_count: int = 0

var scoreTime=0
var score=0
#Change total_time as required
var total_time=500
var elapsed_time=0

var game_ended = false

@onready var countdown_label = $Countdown

func _ready():
	Globals.score = 5
	randomize() # seed the random number generator
	$ProteinComplexI.addATP.connect(_new_ATP)
	$ProteinComplexII.addATP.connect(_new_ATP)
	$CoQ10/TrackingArea2D.addATP.connect(_new_ATP)  # ATP generation for this is currently disabled.  Enable in co_q_10.gd
	$ProteinComplexIII.addATP.connect(_new_ATP)
	$ProteinComplexIV.addATP.connect(_new_ATP)
	$ATPSyn.addATP.connect(_new_ATP)
	get_tree().paused = true
	for i in range(3, 0, -1):
		countdown_label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	countdown_label.visible = false
	
func _process(delta: float) -> void:
	if game_ended:
		return

	elapsed_time += delta
	#Globals.time += delta
	$Node2D/TimeLabel.text="Time = " + str(round(total_time - elapsed_time))

	#You lose when time runs out
	if (total_time - elapsed_time) <= 0:
		$Node2D/TimeLabel.text="Time = 0" 
		end_game()
	
	#Winning occurs in phosphate_tracking.gd

# spawn the nadh
# Static spawn coordinates SHOULD make it always appear right below Complex 1
func nadh_spawn():
	var spawn_position = Vector2(200, 900)  # create the coordinate
	
	var object_instance = nadh_scene.instantiate() # instantiate the instance of the nadh
	object_instance.position = spawn_position          # set its position
	get_tree().root.get_node("UnguidedMode").add_child(object_instance)       # add it to scene tree

# Static spawn coordinates SHOULD make it always appear right below Complex 2
func fadh2_spawn():
	var spawn_position = Vector2(500, 900)  # create the coordinate
	
	var object_instance = fadh2_scene.instantiate() # instantiate the instance of the fadh2
	object_instance.position = spawn_position          # set its position
	get_tree().root.get_node("UnguidedMode").add_child(object_instance)   
	
func _on_nadh_timer_timeout() -> void:
	pass

func _on_fadh2_timer_timeout() -> void:
	pass
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")

func end_game():
	game_ended=true
	$YouLose.visible = true
	Globals.score=0


func _on_nadh_button_pressed() -> void:
	nadh_spawn()

func _on_fadh_2_button_pressed() -> void:
	fadh2_spawn()
	
func _new_ATP(amount):
	$ATPProgressBar.value += amount
	if $ATPProgressBar.value >= 100:
		var main = get_tree().root.get_node("UnguidedMode")
		var elapsed_time = main.elapsed_time
		Globals.score = round(100*total_time-elapsed_time)
		get_tree().change_scene_to_file("res://scenes/UnguidedVictory.tscn")
