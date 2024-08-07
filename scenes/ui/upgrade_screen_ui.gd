extends CanvasLayer

@export var ability_card:PackedScene

@onready var card_container:HBoxContainer=%CardContainer
@onready var color_rect = $ColorRect


signal ability_upgraded(upgrade:AbilityUpgrade)

func _ready():
	get_tree().paused=true
	var tween=create_tween()
	tween.tween_property(color_rect,"modulate:a",1,.5)


func create_and_fill(upgrade_info:Array[AbilityUpgrade],current_upgrade:Dictionary):
	var delay:float=0
	for i in upgrade_info.size():
		var create_card=ability_card.instantiate()
		card_container.add_child(create_card)
		create_card.get_labels_information(upgrade_info[i],current_upgrade)
		create_card.play_in(delay)
		delay+=.4
		create_card.selected.connect(on_upgrade_selected.bind(upgrade_info[i]))
	


func on_upgrade_selected(upgrade:AbilityUpgrade):
	ability_upgraded.emit(upgrade)
	var tween=create_tween()
	tween.tween_property(color_rect,"modulate:a",0,.35)
	await tween.finished
	get_tree().paused=false
	queue_free()

