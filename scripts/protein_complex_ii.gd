extends Area2D

signal addATP()

var electrons_inside := []
var required_electron_count = 2

var cooldown_time = 5.0
var on_cooldown = false
var time_left = 0.0


func _ready() -> void:
	add_to_group("proteinComplexII")
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _process(delta):
	if on_cooldown:
		time_left -= delta
		if time_left <= 0:
			on_cooldown = false
			modulate = Color (1,1,1,1) #fade back in
			print("Protein Complex II cooldown finished")

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("ELECTRON") and area not in electrons_inside:
		electrons_inside.append(area)
		_check_trigger()

func _on_area_exited(area: Area2D) -> void:
	if area in electrons_inside:
		electrons_inside.erase(area)

func _check_trigger() -> void:
	if electrons_inside.size() >= required_electron_count:
		print("Event triggered! Enough items are inside protein complex II.")
		emit_signal("addATP", 5)
		_start_cooldown()

func _start_cooldown():
	on_cooldown = true
	time_left = cooldown_time
	# Fade out to show cooldown
	modulate = Color(1, 1, 1, 0.4)
	print("Protein Complex II on cooldown for ", cooldown_time, " seconds")
