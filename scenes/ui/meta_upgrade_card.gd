extends PanelContainer


@onready var title_label = %TitleLabel
@onready var description_label = %DescriptionLabel
@onready var h_slider = %HSlider
@onready var label = %Label
@onready var button = %Button
@onready var count_label = %CountLabel

var upgrade:MetaUpgrade


func _ready():
	button.pressed.connect(on_button_pressed)


func set_meta_upgrade(_upgrade:MetaUpgrade):
	upgrade=_upgrade
	title_label.text=_upgrade.title
	description_label.text=_upgrade.description
	h_slider.max_value=upgrade.max_value
	update_slider()
	check_max_quantity()


func update_slider():
	var percent=MetaProgression.save_data["meta_upgrade_currency"]
	percent=min(percent,h_slider.max_value)
	h_slider.value=percent
	label.text=str(percent)+"/"+str(h_slider.max_value)
	button.disabled=percent < h_slider.max_value
	if not MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		return
	var percent_count=MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	count_label.text="x"+str(percent_count)


func check_max_quantity():
	if not MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		return
	var current_quantity=MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	if current_quantity < upgrade.max_quantity:
		return
	button.text="MAX"
	button.disabled=true


func on_button_pressed():
	$AnimationPlayer.play("selected")
	MetaProgression.save_data["meta_upgrade_currency"]-=h_slider.max_value
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save()
	get_tree().call_group("meta_ability_card","update_slider")
	get_tree().call_group("meta_ability_card","check_max_quantity")
	check_max_quantity()
