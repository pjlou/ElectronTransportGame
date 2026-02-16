extends Area2D

var electrons_inside := []
var required_electron_count = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	add_to_group("ComplexIII")

func _on_area_entered(area: Area2D) -> void:
	print(electrons_inside.size())
	if area.get_parent().is_in_group("ELECTRON") and area.get_parent().is_in_group("DELIVERED") and area not in electrons_inside:
		electrons_inside.append(area)
		_check_trigger()

func _on_area_exited(area: Area2D) -> void:
	if area in electrons_inside:
		electrons_inside.erase(area)

func _check_trigger() -> void:
	if electrons_inside.size() >= required_electron_count:
		print("Event triggered! Enough items are inside protein complex III.")
