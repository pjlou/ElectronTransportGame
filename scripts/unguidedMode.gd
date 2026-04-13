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

func _ready():
	Globals.score = 5
	randomize() # seed the random number generator
	
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
func nadh_spawn():
	var spawn_position = Vector2(
		rng.randf_range(fadh2_nadh_spawn.position.x, fadh2_nadh_spawn.position.x + fadh2_nadh_spawn.size.x),
		rng.randf_range(fadh2_nadh_spawn.position.y, fadh2_nadh_spawn.position.y + fadh2_nadh_spawn.size.y)
	)  # create the coordinate
	
	var object_instance = nadh_scene.instantiate() # instantiate the instance of the HIon scene
	object_instance.position = spawn_position          # set its position
	get_tree().root.get_node("UnguidedMode").add_child(object_instance)       # add it to scene tree

func fadh2_spawn():
	var spawn_position = Vector2(
		rng.randf_range(fadh2_nadh_spawn.position.x, fadh2_nadh_spawn.position.x + fadh2_nadh_spawn.size.x),
		rng.randf_range(fadh2_nadh_spawn.position.y, fadh2_nadh_spawn.position.y + fadh2_nadh_spawn.size.y)
	)  # create the coordinate
	
	var object_instance = fadh2_scene.instantiate() # instantiate the instance of the HIon scene
	object_instance.position = spawn_position          # set its position
	get_tree().root.get_node("UnguidedMode").add_child(object_instance)   
	
func _on_nadh_timer_timeout() -> void:
	nadh_spawn()

func _on_fadh2_timer_timeout() -> void:
	fadh2_spawn()
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")

func end_game():
	game_ended=true
	$YouLose.visible = true
	Globals.score=0
