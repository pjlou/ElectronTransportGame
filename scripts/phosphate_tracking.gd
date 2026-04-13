extends Area2D

var adp_inside := []
var required_adp_count = 1
var rng = RandomNumberGenerator.new()
var atp_scene = load("res://scenes/atp.tscn")
var atp_sbox = Rect2(Vector2(1500, 820), Vector2(100, 100))
var total_time=500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(area: Area2D) -> void:
	print("adp entered phosphate body")
	if area.get_parent().is_in_group("ADP") and area not in adp_inside:
		adp_inside.append(area)
		print("adp is added to adp array")
		_check_trigger()

func _on_body_exited(area: Area2D) -> void:
	if area in adp_inside:
		adp_inside.erase(area)

func _check_trigger() -> void:
	if adp_inside.size() >= required_adp_count:
		spawn_atp()
		for adp in adp_inside.duplicate():
			adp.get_parent().free()
			adp_inside.erase(adp)
		self.get_parent().get_parent().call_deferred("free")

func spawn_atp() -> void:
	# 1. Instantiate and add it
	var atp = atp_scene.instantiate()
	atp.position = Vector2(
		rng.randf_range(atp_sbox.position.x, atp_sbox.position.x + atp_sbox.size.x),
		rng.randf_range(atp_sbox.position.y, atp_sbox.position.y + atp_sbox.size.y)
	)
	get_tree().root.call_deferred("add_child", atp)
	
	var main = get_tree().root.get_node("UnguidedMode")
	
	main.atp_made_count += 1
	print("ATP count is now %d" % main.atp_made_count)
	#  Switch to Victory when we’ve hit 3
	if main.atp_made_count >= 3:
	#if elapsed_time < 1:
		var elapsed_time = main.elapsed_time
		Globals.score = round(100*total_time-elapsed_time)
		get_tree().change_scene_to_file("res://scenes/UnguidedVictory.tscn")
	
	# 2. Schedule safe removal after 5 seconds
	#    SceneTree.create_timer returns a one-shot Timer
	var t = get_tree().create_timer(3.0)
	t.connect("timeout", Callable(atp, "queue_free"))
