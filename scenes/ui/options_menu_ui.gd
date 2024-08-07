extends CanvasLayer


@onready var window_menu_button:MenuButton = %WindowMenuButton
@onready var random_audio_stream_component = $RandomAudioStreamComponent
@onready var sfx_h_slider = %SfxHSlider
@onready var music_h_slider = %MusicHSlider

var window_menu:bool=true


func _ready():
	window_menu_button.about_to_popup.connect(random_audio_stream_component.set_random_sound)
	window_menu_button.get_popup().id_pressed.connect(on_pressed)
	sfx_h_slider.value_changed.connect(on_value_changed.bind("Sfx"))
	music_h_slider.value_changed.connect(on_value_changed.bind("Music"))
	%BackButton.pressed.connect(on_back_pressed)
	%BackButton.pressed.connect(random_audio_stream_component.set_random_sound)
	update_values()


func update_values():
	update_screen()
	update_sliders()


func update_screen():
	var current_window_mode=DisplayServer.window_get_mode()
	match current_window_mode:
		0:
			window_menu_button.text=window_menu_button.get_popup().get_item_text(1)
		3:
			window_menu_button.text=window_menu_button.get_popup().get_item_text(2)


func update_sliders():
	var value_sfx=AudioServer.get_bus_volume_db(1)
	var value_music=AudioServer.get_bus_volume_db(2)
	sfx_h_slider.value=db_to_linear(value_sfx)
	music_h_slider.value=db_to_linear(value_music)


func on_value_changed(value:float,bus_name:String):
	var _bus_index = AudioServer.get_bus_index(bus_name)
	var db_volume=linear_to_db(value)
	AudioServer.set_bus_volume_db(_bus_index,db_volume)


func on_pressed(index:int):
	random_audio_stream_component.set_random_sound()
	match index:
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var change_text=window_menu_button.get_popup().get_item_text(index)
	window_menu_button.text=change_text


func on_back_pressed():
	ScreenTransitionUi.make_transition()
	await ScreenTransitionUi.transition
	queue_free()
