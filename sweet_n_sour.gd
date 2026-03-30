extends Node2D

signal close_dialog

func _process(delta) -> void: 
	if Input.is_action_just_pressed("right"):
		close_dialog.emit()
		queue_free()
