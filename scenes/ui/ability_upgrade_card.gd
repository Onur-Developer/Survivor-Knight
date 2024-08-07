extends PanelContainer

@onready var title_label:Label=%TitleLabel
@onready var description_label:Label=%DescriptionLabel
@onready var texture_rect = %TextureRect



var disabled:bool=false


signal selected


func _ready():
	gui_input.connect(take_click_action)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func play_in(delay:float):
	modulate=Color.TRANSPARENT
	await get_tree().create_timer(delay).timeout
	modulate=Color.WHITE
	$AnimationPlayer.play("appear")


func get_labels_information(upgrade_info:AbilityUpgrade,current_upgrade:Dictionary):
	title_label.text=upgrade_info.name
	description_label.text=upgrade_info.description
	texture_rect.texture=upgrade_info.ımage


func card_selected():
	disabled=true
	other_card_disabled()
	$HoverAnimation.stop()
	$AnimationPlayer.play("selected")
	await $AnimationPlayer.animation_finished
	selected.emit()


func card_disabled():
	disabled=true
	$AnimationPlayer.play("discard")


func other_card_disabled():
	for card in get_tree().get_nodes_in_group("ability_card"):
		if card == self:
			continue
		card.card_disabled()
	


func take_click_action(event:InputEvent):
	if event.is_action_pressed("left_click") and !disabled:
		$EffectParticles.modulate=Color.TRANSPARENT
		card_selected()


func on_mouse_entered():
	if !disabled:
		$HoverAnimation.play("in")
		var tween=create_tween()
		tween.tween_property(self,"position:y",-30,.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		await tween.finished
		tween.kill()


func on_mouse_exited():
	if !disabled:
		$HoverAnimation.play("out")
		var tween2=create_tween()
		tween2.tween_property(self,"position:y",0,.4)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		await tween2.finished
		tween2.kill()
