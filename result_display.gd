extends Node2D

@onready var SuccessSprite = preload("res://success_sprite.tscn")
@onready var FailureSprite = preload("res://failure_sprite.tscn")

func _ready(): 
	pass

func display_success(): 
	var success_sprite = SuccessSprite.instantiate()
	add_child(success_sprite)

func display_failure(): 
	var failure_sprite = FailureSprite.instantiate()
	add_child(failure_sprite)
