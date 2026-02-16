#Geniunely just attach to an RigidBody2d that you want this on and that will
#Become a 'correct group' for the previous basicdragscript. 
extends RigidBody2D

func _ready(): 
	add_to_group("correctArea")
	
func get_global_rect() -> Rect2: #use Rect2, rectangle bounds of collision
	var shape = $CollisionShape2D.shape #Define collission boundry, get shape
	var extents = shape.get_rect().size / 2 #Find size via offset.
	return Rect2(global_position - extents, shape.get_rect().size) #Rect made
