extends CanvasLayer

signal transition


var skip_emit:bool=false


func make_transition():
	$AnimationPlayer.play("default")
	await transition
	skip_emit=true
	$AnimationPlayer.play_backwards("default")


func transition_to_scene(scene:String):
	make_transition()
	await transition
	get_tree().change_scene_to_file(scene)


func emit_transition():
	if skip_emit:
		skip_emit=false
		return
	transition.emit()
