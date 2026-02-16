extends Area2D

#Check drag event during collision is needed. 

var dragging: bool = false #Being dragged, this turns on so we keep pos of it
var locked: bool = false #Corner Pressure from Belial
var hion_scene = load("res://scenes/unguidedHion.tscn")
var electron_scene = load("res://scenes/electron.tscn")
var rng = RandomNumberGenerator.new() # used for random hion positions when they spawn
var hion_complexI_spawn = Rect2(Vector2(150, 820), Vector2(100, 100)) # location boxes for spawning hion
var hion_complexII_spawn = Rect2(Vector2(570, 820), Vector2(100, 100))

func _ready():
	add_to_group("draggable")

func _input(event):
	if locked:
		return  #Lost the 50/50
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT: #Works on Left click only
			if event.pressed and can_drag(): #True = flag for dragging
				dragging = true
				z_index = getMaxZ("draggable") + 1
			elif not event.pressed: #False = flag for stop dragging
				dragging = false 
				inTargetAreaCheck() #Flag for checking if object release = area
				
	#Handles screen interaction, maybe fixes some touchpad issues. 
	elif event is InputEventScreenTouch:
		if event.pressed and can_drag():
			dragging = true
		elif not event.pressed and dragging:
			dragging = false
			inTargetAreaCheck()

	if (event is InputEventMouseMotion or event is InputEventScreenDrag) and dragging:
		global_position = event.position #Make object follow mouse when true

#Check if mouse is over, check if it's the top object
func can_drag() -> bool:
	if not is_under_mouse():
		return false
	#dont drag if there's an object with higher index. 
	for node in get_tree().get_nodes_in_group("draggable"):
		if node != self and node.has_method("is_under_mouse") and node.is_under_mouse():
			if node.z_index > self.z_index:
				return false
	return true

#return true if mouse is oevr collision area
func is_under_mouse() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())

#helper, get max z, low z
func getMaxZ(group_name: String) -> int:
	var max_z: int = -10000  #Low default
	for node in get_tree().get_nodes_in_group(group_name):
		if node.has_method("get"):
			max_z = max(max_z, node.z_index)
	return max_z

func mouseovercheck() -> bool:
	return get_global_rect().has_point(get_global_mouse_position()) #checkmouse

func get_global_rect() -> Rect2: #use Rect2, rectangle bounds of collision
	var shape = $CollisionShape2D.shape #Define collission boundry, get shape
	var extents = shape.get_rect().size / 2 #Find size via offset.
	return Rect2(global_position - extents, shape.get_rect().size) #Rect made
	
# to get the type of object we are dragging, so that we can check to make sure NADH goes to proteinI 
# FADH2 to proteinII etc
func get_dragging_type() -> String:
	var grandparent = $CollisionShape2D.get_parent().get_parent()
	#var parent = $CollisionShape2D.get_parent()
	if grandparent.name == "Nadh":
		return "NADH"
	elif grandparent.name == "Fadh2":
		return "FADH2"
	#elif grandparent == "UnguidedHion":
		#return "HION"
	#elif grandparent.name == "Electron":
		#return "ELECTRON"
	#elif parent.name == "CoQ10":
		#return "CoQ10"
	return "none"
	
func inTargetAreaCheck() -> void: 
	#Purely for grouping target areas. 
	#Feel free to rework this. This is just logic for 'is this the right goal'
	#We may need to extend this for obvious reasons. Or make this code 5 times
	#For defining diff objects for diff objectives. Means we can be simple with
	#What goes where and add specifications to each.
	var dragging_type = get_dragging_type()
	var current_instance = $CollisionShape2D.get_parent().get_parent()
	if dragging_type == "NADH":
		for area in get_tree().get_nodes_in_group("proteinComplexI"):
			if area.overlaps_area(self): #Return XYZ when correct
				print("correct match protein complexI")
				for i in range(2):
					electron_spawn($CollisionShape2D)
				hion_spawn(hion_complexI_spawn)
				
				current_instance.free()
				return
				
	elif dragging_type == "FADH2":
		for area in get_tree().get_nodes_in_group("proteinComplexII"):
			if area.overlaps_area(self): #Return XYZ when correct
				print("correct match protein complexII")
				for i in range(2):
					electron_spawn($CollisionShape2D)
				hion_spawn(hion_complexII_spawn)
				
				current_instance.free()
				return

 #Function to spawn an object within the spawn box
@warning_ignore("shadowed_variable")
func hion_spawn(hion_sbox: Rect2) -> void:
	print('hion spawned')
	var spawn_position = Vector2(
		rng.randf_range(hion_sbox.position.x, hion_sbox.position.x + hion_sbox.size.x),
		rng.randf_range(hion_sbox.position.y, hion_sbox.position.y + hion_sbox.size.y)
	)
	# Instantiate your object and set its position
	var object_instance = hion_scene.instantiate()
	object_instance.position = spawn_position
	get_tree().root.add_child(object_instance)

func electron_spawn(protein_complex: CollisionShape2D) -> void:
	var parent_node = protein_complex.get_parent()
	var spawn_position = parent_node.get_global_position()
	var object_instance = electron_scene.instantiate()
	object_instance.position = spawn_position
	get_tree().root.add_child(object_instance)
