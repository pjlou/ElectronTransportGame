extends Area2D

signal addATP()

var electrons_inside := []
var required_electron_count = 2

func _ready() -> void:
	add_to_group("proteinComplexII")
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

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
		
