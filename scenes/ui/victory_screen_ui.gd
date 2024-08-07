extends CanvasLayer


@onready var panel_container = $MarginContainer/PanelContainer
@onready var color_rect = $ColorRect
var win_jingle=preload("res://assets/sounds/jingles_Victory.ogg")
var defeat_jingle=preload("res://assets/sounds/jingles_Defeat.ogg")



func _ready():
	get_tree().paused=true
	%ContinueButton.pressed.connect($RandomButtonStreamComponent.set_random_sound)
	%ContinueButton.pressed.connect(on_continue_button_pressed)
	%BacktoMainButton.pressed.connect($RandomButtonStreamComponent.set_random_sound)
	%BacktoMainButton.pressed.connect(on_back_to_main_menu_button_pressed)
	make_animation()


func make_animation():
	color_rect.color.a=0
	panel_container.pivot_offset=panel_container.size / 2
	var tween=create_tween()
	tween.set_parallel()
	tween.tween_property(color_rect,"color:a",.5,.3)
	tween.tween_property(panel_container,"scale",Vector2.ZERO,0)
	tween.chain()
	tween.tween_property(panel_container,"scale",Vector2.ONE,1)\
	.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)


func play_jingle(defeat:bool=false):
	if defeat:
		$RandomJingleStreamComponent.stream=defeat_jingle
	else:
		$RandomJingleStreamComponent.stream=win_jingle
	$RandomJingleStreamComponent.play()


func set_defeat():
	%VictoryLabel.text="Defeat"
	%Label2.text="You lost the game."


func on_continue_button_pressed():
	ScreenTransitionUi.transition_to_scene("res://scenes/ui/meta_menu_ui.tscn")
	await ScreenTransitionUi.transition
	get_tree().paused=false


func on_back_to_main_menu_button_pressed():
	ScreenTransitionUi.transition_to_scene("res://scenes/ui/main_menu_ui.tscn")
	await ScreenTransitionUi.transition
	get_tree().paused=false
