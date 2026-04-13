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

func _process(delta):
	if on_cooldown:
		time_left -= delta
		if time_left <= 0:
			on_cooldown = false
			print("Protein Complex I cooldown finished")
			$ProgressBar.value = ((cooldown_time - time_left) / cooldown_time) * 100

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
	on_cooldown = true
	time_left = cooldown_time
	print("Protein Complex I on cooldown for", cooldown_time, "seconds")
