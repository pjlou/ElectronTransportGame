extends Area2D

var electrons_inside := []
var required_electron_count = 2
var hions_inside := []
var required_hions_count = 2
var rng = RandomNumberGenerator.new()
var h2o_scene = load("res://scenes/h2o.tscn")
var h2o_spawn_box = Rect2(Vector2(1216, 770), Vector2(100, 100))


var hion_scene   = load("res://scenes/unguidedHion.tscn")

var hion_spawn_box = h2o_spawn_box

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(area: Area2D) -> void:
	print("an area has entered the oxygen body")
	print("the size of electrons inside", electrons_inside.size())
	print("the group of the electrons are", area.get_groups())
	if area.get_parent().is_in_group("ELECTRON") and area not in electrons_inside:
		print("is in group ELECTRON and not in electrons_inside")
		electrons_inside.append(area)
		_check_trigger()
	if area.get_parent().is_in_group("unguidedHion") and area not in hions_inside:
		hions_inside.append(area)
		_check_trigger()

func _on_body_exited(area: Area2D) -> void:
	print("an area has left the oxygen body")
	if area in electrons_inside:
		electrons_inside.erase(area)

func _check_trigger() -> void:
	if electrons_inside.size() >= required_electron_count and hions_inside.size() >= required_hions_count:
		
		spawn_H2O(h2o_spawn_box) # idea is to spawn h2o and despawn electron
		print("Event triggered! Enough items are inside.")
		
		# 1) Collect the actual nodes to kill
		var to_free := []
		for area in electrons_inside:
			if is_instance_valid(area) and is_instance_valid(area.get_parent()):
				to_free.append(area.get_parent())
		for area in hions_inside:
			if is_instance_valid(area) and is_instance_valid(area.get_parent()):
				to_free.append(area.get_parent())

		# 2) Clear your trackers *before* freeing anything
		electrons_inside.clear()
		hions_inside.clear()

		# 3) Queue-free each in its own time (safe inside signals, loops, etc)
		for node in to_free:
			node.queue_free()

		# 4) Remove this detector area itself at the end of the frame
		call_deferred("queue_free")

func spawn_H2O(h2o_sbox: Rect2) -> void:
	var h2o = h2o_scene.instantiate()
	h2o.position = Vector2(
		rng.randf_range(h2o_sbox.position.x, h2o_sbox.position.x + h2o_sbox.size.x),
		rng.randf_range(h2o_sbox.position.y, h2o_sbox.position.y + h2o_sbox.size.y)
	)
	get_tree().root.call_deferred("add_child", h2o)
	
	for i in range(4):
		var hion = hion_scene.instantiate()
		hion.position = Vector2(
			rng.randf_range(hion_spawn_box.position.x, hion_spawn_box.position.x + hion_spawn_box.size.x),
			rng.randf_range(hion_spawn_box.position.y, hion_spawn_box.position.y + hion_spawn_box.size.y)
		)
		# make sure it’s in the “unguidedHion” group so your atp_syn.gd will see it
		hion.add_to_group("unguidedHion")
		get_tree().root.call_deferred("add_child", hion)

	# safe removal after 5 seconds
	var t2 = get_tree().create_timer(3.0)
	t2.connect("timeout", Callable(h2o, "queue_free"))
