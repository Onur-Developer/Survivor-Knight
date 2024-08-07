extends CanvasLayer


@onready var panel_container = %PanelContainer


var options_menu_scene=preload("res://scenes/ui/options_menu_ui.tscn")



func _ready():
	get_tree().paused=true
	panel_container.pivot_offset=panel_container.size / 2
	$AnimationPlayer.play("default")
	var tween=create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.tween_property(panel_container,"scale",Vector2.ONE,.3)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SPRING)
	%ResumeButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	%ResumeButton.pressed.connect(on_resume_pressed)
	%OptionsButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	%OptionsButton.pressed.connect(on_options_pressed)
	%BackMenuButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	%BackMenuButton.pressed.connect(on_backmenu_pressed)


func on_resume_pressed():
	$AnimationPlayer.play_backwards("default")
	var tween=create_tween()
	tween.tween_property(panel_container,"scale",Vector2.ONE,0)
	tween.tween_property(panel_container,"scale",Vector2.ZERO,.3)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SPRING)
	
	await tween.finished
	get_tree().paused=false
	queue_free()


func on_options_pressed():
	ScreenTransitionUi.make_transition()
	await ScreenTransitionUi.transition
	var options_menu_instance=options_menu_scene.instantiate()
	var tile=options_menu_instance.get_child(0) as Node2D
	tile.visible=false
	add_child(options_menu_instance)


func on_backmenu_pressed():
	ScreenTransitionUi.make_transition()
	await ScreenTransitionUi.transition
	get_tree().paused=false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")
