extends Node2D

var nadh_scene = preload("res://scenes/nadh.tscn") # preload the scene
var fadh2_scene = preload("res://scenes/fadh2.tscn")
var hion_scene = load("res://scenes/unguidedHion.tscn")
var electron_scene = load("res://scenes/electron.tscn")
var hion_complexI_spawn = Rect2(Vector2(150, 820), Vector2(100, 100)) # location boxes for spawning hion
var hion_complexII_spawn = Rect2(Vector2(570, 820), Vector2(100, 100))
var rng = RandomNumberGenerator.new() # used for random hion positions when they spawn

var nadhButtonEnabled: bool = false
var fadh2ButtonEnabled: bool = false

var atp_made_count: int = 0

var scoreTime=0
var score=0
#Change total_time as required
var total_time=500
var elapsed_time=0

var game_ended = false

@onready var countdown_label = $Countdown
@onready var button_timer: Timer = Timer.new()

func _ready():
	Globals.score = 5
	randomize() # seed the random number generator
	$ProteinComplexI.addATP.connect(_new_ATP)
	$ProteinComplexII.addATP.connect(_new_ATP)
	$CoQ10/TrackingArea2D.addATP.connect(_new_ATP)  # ATP generation for this is currently disabled.  Enable in co_q_10.gd
	$ProteinComplexIII.addATP.connect(_new_ATP)
	$ProteinComplexIV.addATP.connect(_new_ATP)
	$ATPSyn.addATP.connect(_new_ATP)
	# create initial nadh and fadh2 scenes via spawn to streamline functionality
	nadh_spawn()
	fadh2_spawn()
	# start the game after 3 second countdown
	get_tree().paused = true
	for i in range(3, 0, -1):
		countdown_label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	countdown_label.visible = false
	# add timer for buttons
	add_child(button_timer)
	button_timer.one_shot = true
	button_timer.autostart = false
	button_timer.timeout.connect(_on_button_timer_timeout)
	
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
	object_instance.get_node("Area2D").nadh_in_complexI.connect(_complex_I_to_coQ10) # connect drag script signal
	object_instance.position = spawn_position          # set its position
	get_tree().root.get_node("UnguidedMode").add_child(object_instance)       # add it to scene tree

# Static spawn coordinates SHOULD make it always appear right below Complex 2
func fadh2_spawn():
	var spawn_position = Vector2(500, 900)  # create the coordinate
	
	var object_instance = fadh2_scene.instantiate() # instantiate the instance of the fadh2
	object_instance.get_node("Area2D").fadh2_in_complexII.connect(_complex_II_to_coQ10) # connect drag script signal
	object_instance.position = spawn_position          # set its position
	get_tree().root.get_node("UnguidedMode").add_child(object_instance)   

func electron_spawn(protein_complex: CollisionShape2D):
	var parent_node = protein_complex.get_parent()
	var spawn_position = parent_node.get_global_position()
	var object_instance = electron_scene.instantiate()
	object_instance.position = spawn_position
	add_child(object_instance)
	return object_instance

 #Function to spawn an object within the spawn box
@warning_ignore("shadowed_variable")
func hion_spawn(hion_sbox: Rect2) -> void:
	print('hion spawned')
	var spawn_position = Vector2(
		rng.randf_range(hion_sbox.position.x, hion_sbox.position.x + hion_sbox.size.x),
		rng.randf_range(hion_sbox.position.y, hion_sbox.position.y + hion_sbox.size.y)
	)
	# Instantiate your object and set its position
	var object_instance = hion_scene.instantiate()
	object_instance.position = spawn_position
	get_tree().root.add_child(object_instance)
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/modeSelection.tscn")

func end_game():
	game_ended=true
	$YouLose.visible = true
	Globals.score=0

func _on_nadh_button_pressed() -> void:
	if nadhButtonEnabled:
		nadhButtonEnabled = false
		nadh_spawn()
	else:
		$ButtonMessage.text = "You already have NADH"
		$ButtonMessage.visible = true
		button_timer.wait_time = 1.0
		button_timer.start()

func _on_fadh_2_button_pressed() -> void:
	if fadh2ButtonEnabled:
		fadh2ButtonEnabled = false
		fadh2_spawn()
	else:
		$ButtonMessage.text = "You already have FADH2"
		$ButtonMessage.visible = true
		button_timer.wait_time = 1.0
		button_timer.start()
	
func _on_button_timer_timeout() -> void:
	$ButtonMessage.visible = false
	$ButtonMessage.text = "You already have that" # reset to generic text to handle and test edge cases
	
func _new_ATP(amount):
	$ATPProgressBar.value += amount
	if $ATPProgressBar.value >= 100:
		var main = get_tree().root.get_node("UnguidedMode")
		var elapsed_time = main.elapsed_time
		Globals.score = round(100*total_time-elapsed_time)
		get_tree().change_scene_to_file("res://scenes/UnguidedVictory.tscn")

func _complex_I_to_coQ10(current_instance):
	nadhButtonEnabled = true
	complex_I_or_II_to_coQ10(current_instance)
	
func _complex_II_to_coQ10(current_instance):
	fadh2ButtonEnabled = true
	complex_I_or_II_to_coQ10(current_instance)

func complex_I_or_II_to_coQ10(current_instance):
	var collision_shape = current_instance.get_node("Area2D/CollisionShape2D")
	var electron_1 = electron_spawn(collision_shape)
	var electron_2 = electron_spawn(collision_shape)
	var tween = create_tween()
	tween.tween_property(electron_1, "position", $CoQ10.get_global_position(), 1)
	tween.tween_property(electron_2, "position", $CoQ10.get_global_position(), 1)
	hion_spawn(hion_complexI_spawn)
