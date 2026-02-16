extends Area2D

var hions_inside := []
var required_hion_count = 1

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("unguidedHion") or area.get_parent().is_in_group("unguidedHion") and area not in hions_inside:
		hions_inside.append(area)
		_check_trigger()

func _on_body_exited(area: Area2D) -> void:
	if area in hions_inside:
		hions_inside.erase(area)

func _check_trigger() -> void:
	if hions_inside.size() >= required_hion_count:
		print("Event triggered! Enough items are inside intermembrane space.")
