extends Area2D

signal addATP()

@export var required_electron_count := 4
var electrons_inside := []
var loaded := false
var pickup_allowed := true

# cache the electron scene so we can respawn into Complex III
var ElectronScene := preload("res://scenes/electron.tscn")

@onready var sprite_node: Sprite2D = get_parent().get_node("Sprite2D") as Sprite2D
@onready var reload_timer: Timer = $ReloadTimer

func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited",  Callable(self, "_on_area_exited"))
	reload_timer.connect("timeout", Callable(self, "_on_reload_timeout"))
	
func _on_reload_timeout() -> void:
	pickup_allowed = true

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if not loaded and pickup_allowed and parent.is_in_group("ELECTRON") and area not in electrons_inside:
		electrons_inside.append(area)
		_check_electron_load()
		return

	if loaded and area.is_in_group("ComplexIII"):
		_deliver_to_complex(area)

func _on_area_exited(area: Area2D) -> void:
	if not loaded and area in electrons_inside:
		electrons_inside.erase(area)

func _check_electron_load() -> void:
	if electrons_inside.size() >= required_electron_count:
		# 1) Remove the pickup electrons
		for e_area in electrons_inside:
			e_area.get_parent().queue_free()
		electrons_inside.clear()

		# 2) Flip to “loaded” state
		loaded = true
		sprite_node.frame = 0
		print("CoQ10 is now loaded! Drag it to Complex III.")
		# emit_signal("addATP", 5)

func _deliver_to_complex(complex_node: Area2D) -> void:
	# Cast the shape to RectangleShape2D so we can get its rect
	var rect_shape := complex_node.get_node("CollisionShape2DPCIII").shape as RectangleShape2D
	var size := rect_shape.get_rect().size
	
	# Spawn the electrons inside Complex III
	for i in range(required_electron_count):
		var e = ElectronScene.instantiate()
		var offset = Vector2(
			randf_range(-size.x/2, size.x/2),
			randf_range(-size.y/2, size.y/2)
		)
		e.position = complex_node.global_position + offset
		e.add_to_group("DELIVERED")
		get_tree().root.call_deferred("add_child", e)
	
	# Reset for the next cycle
	loaded = false
	sprite_node.frame = 0
	pickup_allowed = false
	reload_timer.start()
	print("Delivered 4 electrons … CoQ10 empty, lockout 2s.")
	print("Delivered 4 electrons to Complex III; CoQ10 is empty again.")
