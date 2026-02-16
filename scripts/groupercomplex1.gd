#Geniunely just attach to an Area2D that you want this on and that Area2D will
#Become a 'correct group' for the previous basicdragscript. 
extends RigidBody2D

func _ready(): 
	add_to_group("correctArea")
	get_parent().connect("electron_donated", _on_electron_donated)
	electron_line.visible = false
	
func get_global_rect() -> Rect2: #use Rect2, rectangle bounds of collision
	var shape = $CollisionShape2D.shape #Define collission boundry, get shape
	var extents = shape.get_rect().size / 2 #Find size via offset.
	return Rect2(global_position - extents, shape.get_rect().size) #Rect made

signal electrondonated1

@onready var electron_line = $ElectronLine  # e.g. a Line2D or AnimatedSprite


func _on_electron_donated():
	print("NADH dropped! Electron Donation starting.")
	# Show electron line briefly
	electron_line.visible = true
	
	var tween = get_tree().create_tween()
	tween.tween_property(electron_line, "modulate", Color(1,1,1,1), 0.2)
	tween.tween_interval(0.5)
	tween.tween_property(electron_line, "modulate", Color(1,1,1,0), 0.3)
	tween.tween_callback(Callable(self, "_hide_line"))

func _hide_line():
	electron_line.visible = false
