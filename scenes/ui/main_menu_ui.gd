extends CanvasLayer

var options_scene=preload("res://scenes/ui/options_menu_ui.tscn")


func _ready():
	%PlayButton.pressed.connect(on_play_pressed)
	%PlayButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	%MetaButton.pressed.connect(on_meta_pressed)
	%MetaButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	%OptionsButton.pressed.connect(on_options_pressed)
	%OptionsButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	%QuitButton.pressed.connect(on_quit_pressed)


func on_play_pressed():
	ScreenTransitionUi.transition_to_scene("res://scenes/main/main.tscn")


func on_meta_pressed():
	ScreenTransitionUi.transition_to_scene("res://scenes/ui/meta_menu_ui.tscn")


func on_options_pressed():
	ScreenTransitionUi.make_transition()
	await ScreenTransitionUi.transition
	var options_create=options_scene.instantiate()
	add_child(options_create)


func on_quit_pressed():
	get_tree().quit()
