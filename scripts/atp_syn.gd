extends Area2D

signal addATP()

var hions_inside := []
var required_hion_count = 4
var phosphate_scene = load("res://scenes/phosphate.tscn")
var adp_scene = load("res://scenes/adp.tscn")
var phosphate_adp_sbox = Rect2(Vector2(1500, 820), Vector2(100, 100))
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))
	$Sprite2D2.visible = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("unguidedHion") or area.get_parent().is_in_group("unguidedHion") and area not in hions_inside:
		hions_inside.append(area)
		_check_trigger()

func _on_body_exited(area: Area2D) -> void:
	if area in hions_inside:
		hions_inside.erase(area)

func _check_trigger() -> void:
	var intermembrane_space = get_node("../IntermembraneSpace")
	if hions_inside.size() >= required_hion_count and intermembrane_space.hions_inside.size() >= intermembrane_space.required_hion_count:
		for hion in hions_inside.duplicate():
			hions_inside.erase(hion)
			hion.get_parent().free()
		spawn_phosphate()
		spawn_adp()
		print("Event triggered! Enough items are inside intermembrane space.")
		emit_signal("addATP", 20)

func spawn_phosphate() -> void:
	var spawn_position = Vector2(
		rng.randf_range(phosphate_adp_sbox.position.x, phosphate_adp_sbox.position.x + phosphate_adp_sbox.size.x),
		rng.randf_range(phosphate_adp_sbox.position.y, phosphate_adp_sbox.position.y + phosphate_adp_sbox.size.y)
	)
	# Instantiate your object and set its position
	var object_instance = phosphate_scene.instantiate()
	object_instance.position = spawn_position
	get_tree().root.call_deferred("add_child", object_instance)
	
func spawn_adp() -> void:
	var spawn_position = Vector2(
		rng.randf_range(phosphate_adp_sbox.position.x, phosphate_adp_sbox.position.x + phosphate_adp_sbox.size.x),
		rng.randf_range(phosphate_adp_sbox.position.y, phosphate_adp_sbox.position.y + phosphate_adp_sbox.size.y)
	)
	var object_instance = adp_scene.instantiate()
	object_instance.position = spawn_position
	get_tree().root.call_deferred("add_child", object_instance)
