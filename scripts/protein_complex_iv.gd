extends Area2D

signal addATP()

var electrons_inside := []
var required_electron_count = 4
var rng = RandomNumberGenerator.new()
var oxygen_scene = load("res://scenes/oxygen.tscn")
var protein_complexIV_pos = self.global_position
var oxygen_sbox = Rect2(protein_complexIV_pos, Vector2(100, 100))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	add_to_group("ComplexIV")

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	# ONLY count the electrons spawned by Cytochrome C
	if parent.is_in_group("ELECTRON") and parent.is_in_group("DELIVERED2") and area not in electrons_inside:
		electrons_inside.append(area)
		_check_trigger()

func _on_area_exited(area: Area2D) -> void:
	if area in electrons_inside:
		electrons_inside.erase(area)

func _check_trigger() -> void:
	if electrons_inside.size() >= required_electron_count:
		oxygen_spawn(oxygen_sbox)
		print("Event triggered! Enough items are inside protein complex IV.")
		emit_signal("addATP", 5)

@warning_ignore("shadowed_variable")
func oxygen_spawn(oxygen_sbox: Rect2) -> void:
	var spawn_position = Vector2(
		rng.randf_range(oxygen_sbox.position.x, oxygen_sbox.position.x + oxygen_sbox.size.x),
		rng.randf_range(oxygen_sbox.position.y, oxygen_sbox.position.y + oxygen_sbox.size.y)
	)
	# Instantiate your object and set its position
	var object_instance = oxygen_scene.instantiate()
	object_instance.position = spawn_position
	get_tree().root.call_deferred("add_child", object_instance)
