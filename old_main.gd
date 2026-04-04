extends Node2D


func _ready(): 
	$Game.process_mode = Node.PROCESS_MODE_INHERIT
	pass

func _on_close_dialog() -> void:
	$Game.process_mode = Node.PROCESS_MODE_INHERIT
