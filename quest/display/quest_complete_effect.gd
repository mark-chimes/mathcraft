extends Node2D


var alpha_amount = 1.0
var fade_seconds = 4.0

func _process(delta):
	alpha_amount = max(alpha_amount - delta/fade_seconds, 0.0)
	modulate.a = alpha_amount
	position.y += delta*10

	
	if alpha_amount == 0.0:
		queue_free()

func set_icon_text_col(new_icon, new_text, new_color): 
	$Icon.texture = new_icon
	$Label.text = new_text
	modulate = new_color
	modulate.a = 1.0
	
