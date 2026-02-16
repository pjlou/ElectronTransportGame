extends Node

@onready var anim_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("Pleasesendhelp")


func _on_done_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/startScreen.tscn")
