extends Sprite2D

var alpha_amount = 1.0

func _process(delta):
	alpha_amount = max(alpha_amount - delta, 0.0)
	modulate.a = alpha_amount
	
	if alpha_amount == 0.0:
		queue_free()
