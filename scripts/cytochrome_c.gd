extends Area2D

signal addATP()
signal electrons_delivered_to_complexIV

var electrons_inside := []
var loaded := false
var pickup_allowed := true
@export var required_electron_count = 4

var ElectronScene := preload("res://scenes/electron.tscn")

@onready var sprite_node: Sprite2D = get_parent().get_node("Sprite2D") as Sprite2D
@onready var reload_timer: Timer   = $ReloadTimer

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited",  Callable(self, "_on_area_exited"))
	reload_timer.connect("timeout", Callable(self, "_on_reload_timeout"))
	
func _on_reload_timeout() -> void:
	pickup_allowed = true

func _control_shader(switch: bool):
	# Sets "enable" in shader to be on/true or off/false
	$Sprite2D.material.set("shader_parameter/enable", switch)

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if not loaded and pickup_allowed and parent.is_in_group("ELECTRON") and parent.is_in_group("DELIVERED") and area not in electrons_inside:
		electrons_inside.append(area)
		_check_electron_load()
		return
		
	if loaded and area.is_in_group("ComplexIV"):
		_deliver_to_complex(area)

func _on_area_exited(area: Area2D) -> void:
	if not loaded and area in electrons_inside:
		electrons_inside.erase(area)


func _check_electron_load() -> void:
	if electrons_inside.size() >= required_electron_count:
		# remove the four you just picked up
		for e_area in electrons_inside:
			e_area.get_parent().queue_free()
		electrons_inside.clear()

		loaded = true
		_control_shader(loaded)
		#sprite_node.frame = 1
		print("Cytochrome C is now loaded! Drag it to Complex IV.")
		emit_signal("addATP", 10)

func _deliver_to_complex(complex_node: Area2D) -> void:
	# 1) Get the RectangleShape2D on Complex IV
	var rect_shape := complex_node.get_node("CollisionShape2DPCIV").shape as RectangleShape2D
	var size := rect_shape.get_rect().size

	# 2) Spawn 4 new electrons inside Complex IV and tag them as DELIVERED2
	for i in range(required_electron_count):
		var e = ElectronScene.instantiate()
		e.add_to_group("DELIVERED2")
		var offset = Vector2(
			randf_range(-size.x/2, size.x/2),
			randf_range(-size.y/2, size.y/2)
		)
		e.position = complex_node.global_position + offset
		# deferred add so you don’t invalidate the loop
		get_tree().root.call_deferred("add_child", e)

	# 3) Reset state + lockout
	loaded = false
	_control_shader(loaded)
	pickup_allowed = false
	reload_timer.start()
	#sprite_node.frame = 0
	print("Delivered 4 electrons to Complex IV; Cytochrome C empty, lockout 2 s.")
	emit_signal("electrons_delivered_to_complexIV")
