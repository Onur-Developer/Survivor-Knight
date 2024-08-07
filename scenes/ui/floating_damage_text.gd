extends Node2D


func animate_and_write(damage:String):
	$Label.text=damage
	var tween=create_tween()
	
	tween.set_parallel()
	tween.tween_property(self,"global_position",global_position+Vector2.UP*16,.4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2.ONE*1.1,.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	
	tween.tween_property(self,"global_position",global_position+Vector2.UP*48,.4)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2.ZERO,.4).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.chain()
	tween.tween_callback(queue_free)
