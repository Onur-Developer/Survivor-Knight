extends Node


@export var axe_ability_contoller:PackedScene
@export var anvil_ability_controller_scene:PackedScene
@export var wooden_sword_ability_controller_scene:PackedScene
@export var poison_vial_controller_scene:PackedScene
@export var flame_turret_controller_scene:PackedScene
@export var flying_turret_controller_scene:PackedScene
@export var drone_controller_scene:PackedScene
@export var energy_shield_scene:PackedScene


func _ready():
	GameEvents.ability_upgrade_added.connect(add_axe_ability)
	GameEvents.ability_upgrade_added.connect(add_anvil_ability)
	GameEvents.ability_upgrade_added.connect(add_wooden_sword_ability)
	GameEvents.ability_upgrade_added.connect(add_poison_vial_ability)
	GameEvents.ability_upgrade_added.connect(add_flame_turret_ability)
	GameEvents.ability_upgrade_added.connect(add_flying_turret_ability)
	GameEvents.ability_upgrade_added.connect(add_drone_ability)
	GameEvents.ability_upgrade_added.connect(add_energy_shield_ability)


func add_axe_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="axe":
		return
	var create_axe_ability_contoller=axe_ability_contoller.instantiate() as Node
	add_child(create_axe_ability_contoller)
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(upgrade_manager.ability_axe_damage)
	GameEvents.disconnect_upgrade(add_axe_ability,upgrade,current_upgrades)


func add_anvil_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="anvil":
		return
	var anvil_ability_controller=anvil_ability_controller_scene.instantiate() as Node
	add_child(anvil_ability_controller)
	GameEvents.disconnect_upgrade(add_anvil_ability,upgrade,current_upgrades)


func add_wooden_sword_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="wooden_sword":
		return
	var wooden_sword_instantiate=wooden_sword_ability_controller_scene.instantiate()
	add_child(wooden_sword_instantiate)
	GameEvents.disconnect_upgrade(add_wooden_sword_ability,upgrade,current_upgrades)


func add_poison_vial_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="poison_vial":
		return
	var poison_controller_instance=poison_vial_controller_scene.instantiate()
	add_child(poison_controller_instance)
	GameEvents.disconnect_upgrade(add_poison_vial_ability,upgrade,current_upgrades)


func add_flame_turret_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="flame_turret":
		return
	var flame_turret_instance=flame_turret_controller_scene.instantiate()
	add_child(flame_turret_instance)
	GameEvents.disconnect_upgrade(add_flame_turret_ability,upgrade,current_upgrades)


func add_flying_turret_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="flying_turret":
		return
	
	var flying_turret_controller=flying_turret_controller_scene.instantiate()
	add_child(flying_turret_controller)
	GameEvents.disconnect_upgrade(add_flying_turret_ability,upgrade,current_upgrades)


func add_drone_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="drone":
		return
	var drone_controller_ınstance=drone_controller_scene.instantiate()
	add_child(drone_controller_ınstance)
	GameEvents.disconnect_upgrade(add_drone_ability,upgrade,current_upgrades)


func add_energy_shield_ability(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="energy_shield":
		return
	var energy_shield_ınstance=energy_shield_scene.instantiate()
	add_child(energy_shield_ınstance)
	GameEvents.disconnect_upgrade(add_energy_shield_ability,upgrade,current_upgrades)
