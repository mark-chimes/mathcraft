extends Node2D

@onready var SuccessSprite = preload("res://success_sprite.tscn")
@onready var FailureSprite = preload("res://failure_sprite.tscn")

var cur_sprite = null

func _ready(): 
	pass

func display_success(): 
	if cur_sprite != null: 
		cur_sprite.queue_free()
	var success_sprite = SuccessSprite.instantiate()
	cur_sprite = success_sprite
	add_child(success_sprite)

func display_failure(): 
	if cur_sprite != null: 
		cur_sprite.queue_free()
	var failure_sprite = FailureSprite.instantiate()
	cur_sprite = failure_sprite
	add_child(failure_sprite)
