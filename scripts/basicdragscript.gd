extends RigidBody2D

#Check drag event during collision is needed. 

var dragging: bool = false #Being dragged, this turns on so we keep pos of it
var locked: bool = false #Corner Pressure from Belial

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

func inTargetAreaCheck(): 
	#Purely for grouping target areas. 
	#Feel free to rework this. This is just logic for 'is this the right goal'
	#We may need to extend this for obvious reasons. Or make this code 5 times
	#For defining diff objects for diff objectives. Means we can be simple with
	#What goes where and add specifications to each. 
	for area in get_tree().get_nodes_in_group("correctArea"):
		if area.get_global_rect().intersects(self.get_global_rect()): #Return XYZ when correct
			print("Correct Match")
			locked = true  #Hard Knockdown in Corner
			
			#YIPPEEE (Physical)
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", self.scale * 1.1, 0.2)
			tween.tween_property(self, "scale", self.scale, 0.2)
			
			#Scene transitions below
			if area.name == "FEEDMEJESUS":
				var anim_player4 = get_node("AnimationPlayer")
				if anim_player4:
					anim_player4.play("FEEDMESEYMOUR")
					await get_tree().create_timer(23.0).timeout
					
					get_tree().change_scene_to_file("res://scenes/victorySceneGuided.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")
			
			if area.name == "COMPLEX4h":
				var anim_player4 = get_node("AnimationPlayer")
				if anim_player4:
					anim_player4.play("throwingupandgaming")
					await get_tree().create_timer(13.0).timeout
					get_tree().change_scene_to_file("res://scenes/guidedMode5.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")
			
			if area.name == "COMPLEX4":
				var anim_player4 = get_node("AnimationPlayer")
				if anim_player4:
					anim_player4.play("almostdoneohgod")
					await get_tree().create_timer(13.0).timeout
					get_tree().change_scene_to_file("res://scenes/guidedMode4.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")
			
			
			if area.name == "COMPLEX3h":
				var anim_player4 = get_node("AnimationPlayer")
				if anim_player4:
					anim_player4.play("greatmigration")
					await get_tree().create_timer(7.0).timeout
					get_tree().change_scene_to_file("res://scenes/guidedMode3halfhalf.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")
			
			if area.name == "COMPLEX3":
				var anim_player3 = get_node("AnimationPlayer")
				if anim_player3:
					anim_player3.play("TophatMoved")
					await get_tree().create_timer(11.0).timeout
					get_tree().change_scene_to_file("res://scenes/guidedMode3half.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")

			if area.name == "C2":
				var anim_player2 = get_node("AnimationPlayer")
				if anim_player2:
					anim_player2.play("donation2")
					await get_tree().create_timer(8.0).timeout
					get_tree().change_scene_to_file("res://scenes/guidedmode3.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")


			if area.name == "COMPLEX1":
				var anim_player = get_node("AnimationPlayer")
				if anim_player:
					anim_player.play("donate_electrons")
					await get_tree().create_timer(10.0).timeout
					get_tree().change_scene_to_file("res://scenes/guided_mode_2.tscn")
				else:
					print("Where the heck is the AnimationPlayer bozo")

	print("Incorrect Match") #Return ZYX when incorrect
