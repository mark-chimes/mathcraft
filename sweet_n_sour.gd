extends Node2D

func _process(delta) -> void: 
	if Input.is_action_just_pressed("right"):
		queue_free()
