extends Node


@export var poison_vial_ability_scene:PackedScene


var poison_vial_pool:Array[Node2D]=[]

const distance_from_player:float=15


func _ready():
	add_poison_vial()
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(upgrade_manager.poison_count)


func add_poison_vial():
	var poision_vial_instance=poison_vial_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(poision_vial_instance)
	poison_vial_pool.append(poision_vial_instance)
	set_position_poison_vial(poision_vial_instance)
	poision_vial_instance.controller=self


func set_position_poison_vial(poison_vial):
	var player=get_tree().get_first_node_in_group("player") as Node2D
	if player==null:
		return
	
	for i in poison_vial_pool.size():
		if poison_vial_pool[i]==poison_vial:
			var random_x=randf_range(-distance_from_player,distance_from_player)
			poison_vial_pool[i].global_position=Vector2(player.global_position.x+random_x,-185)


func reset_vial(poison_vial):
	set_position_poison_vial(poison_vial)


func on_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="poison_count":
		return
	add_poison_vial()
	GameEvents.disconnect_upgrade(on_ability_upgrade_added,upgrade,current_upgrades)


