extends Node2D

var cooldown_time = 2.0
var can_use_ability = true
var cooldown_active = false
var time_left = 0.0

func _process(delta):
	if cooldown_active:
		time_left -= delta
		$ProgressBar.value = ((cooldown_time - time_left) / cooldown_time) * 100

		if time_left <= 0:
			cooldown_active = false
			$ProgressBar.value = 100
			print("Ability ready again!")

	if Input.is_action_just_pressed("ui_accept") and can_use_ability:
		use_ability()

func use_ability():
	print("Ability used!")
	can_use_ability = false
	cooldown_active = true
	time_left = cooldown_time
	$ProgressBar.value = 0

	# Start cooldown timer asynchronously
	await get_tree().create_timer(cooldown_time).timeout

	# Cooldown finished
	can_use_ability = true
