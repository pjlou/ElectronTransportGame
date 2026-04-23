extends Area2D

signal addATP()

var electrons_inside := []
var required_electron_count = 2

var cooldown_time = 5.0
var on_cooldown = false
var time_left = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("proteinComplexI")
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	
	# This is here at ready to make sure nothing is leftover when replaying the gamemode
	reset_electrons_list()

func _process(delta):
	if on_cooldown: # If the protein is currently on cooldown, update the timer
		time_left -= delta  # Reduce the remaining cooldown time
		if time_left <= 0:  # When cooldown reaches zero or below, end the cooldown
			on_cooldown = false
			modulate = Color (1,1,1,1) # Fade back in
			print("Protein Complex I cooldown finished")


func _on_area_entered(area: Area2D) -> void:
	print(electrons_inside.size())
	if area.get_parent().is_in_group("ELECTRON") and area not in electrons_inside:
		electrons_inside.append(area)
		_check_trigger()

func _on_area_exited(area: Area2D) -> void:
	if area in electrons_inside:
		electrons_inside.erase(area)
		print('one electron left pcI leaving ', electrons_inside.size(), ' remaining')

func _check_trigger() -> void:
	if electrons_inside.size() >= required_electron_count:
		print("Event triggered! Enough items are inside protein complex I.")
		emit_signal("addATP", 5)
		_start_cooldown()

func _start_cooldown():
	on_cooldown = true  # Mark that the protein is now on cooldown
	time_left = cooldown_time # Reset the cooldown timer to the full cooldown durationn
	# Fade out to show cooldown
	modulate = Color(1, 1, 1, 0.4)
	print("Protein Complex I on cooldown for ", cooldown_time, " seconds")
	
# Resets list of electrons, to call when the game ends.
# Makes sure that no lingering electrons will carry over when the scene is replayed
func reset_electrons_list():
	electrons_inside.clear()
