extends CanvasLayer


@export var meta_upgrade_pool:Array[MetaUpgrade]=[]


var meta_upgrade_card_scene=preload("res://scenes/ui/meta_upgrade_card.tscn")


@onready var grid_container = %GridContainer


func _ready():
	%BackButton.pressed.connect(on_back_button)
	%BackButton.pressed.connect($RandomAudioStreamComponent.set_random_sound)
	create_upgrade_meta()


func create_upgrade_meta():
	for meta in meta_upgrade_pool:
		var meta_upgrade_card_instance=meta_upgrade_card_scene.instantiate()
		grid_container.add_child(meta_upgrade_card_instance)
		meta_upgrade_card_instance.set_meta_upgrade(meta)


func on_back_button():
	ScreenTransitionUi.transition_to_scene("res://scenes/ui/main_menu_ui.tscn")
