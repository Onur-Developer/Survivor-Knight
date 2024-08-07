extends Node

@export var flying_turret_scene:PackedScene
var flying_turret


func _ready():
	flying_turret=flying_turret_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(flying_turret)
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(upgrade_manager.flying_turret_cooldown)
	upgrade_manager.upgrade_pool.append(upgrade_manager.flying_turret_frequency)
	GameEvents.ability_upgrade_added.connect(decrease_cool_down)
	GameEvents.ability_upgrade_added.connect(ıncrease_frequency)


func decrease_cool_down(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="flying_turret_cooldown":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] + 1
	flying_turret.error_timer.wait_time= 7 - quantity
	GameEvents.disconnect_upgrade(decrease_cool_down,upgrade,current_upgrades)


func ıncrease_frequency(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="flying_turret_frequency":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] + 1
	var frequency=quantity/2.0 as float
	flying_turret.cooldown_timer.wait_time= 3.0 - frequency
	GameEvents.disconnect_upgrade(ıncrease_frequency,upgrade,current_upgrades)
