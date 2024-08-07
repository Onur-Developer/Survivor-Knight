extends Node

@export var upgrade_pool:Array[AbilityUpgrade]
@export var experience_manager:Node
@export var upgrade_ui:PackedScene

@export var current_upgrades = {}
var ability_axe_damage=preload("res://resources/upgrades/axe_damage.tres")
var anvil_count=preload("res://resources/upgrades/anvil_count.tres")
var poison_count=preload("res://resources/upgrades/poison_count.tres")
var flame_turret_repair=preload("res://resources/upgrades/flame_turret_repair.tres")
var flame_turret_count=preload("res://resources/upgrades/flame_turret_count.tres")
var flying_turret_cooldown=preload("res://resources/upgrades/flying_turret_cooldown.tres")
var flying_turret_frequency=preload("res://resources/upgrades/flying_turret_frequency.tres")


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level:int):
	
	var upgrade_interface = upgrade_ui.instantiate()
	owner.add_child(upgrade_interface)
	var collect_upgrades=check_upgrades() as Array[AbilityUpgrade]
	upgrade_interface.create_and_fill(collect_upgrades,current_upgrades)
	upgrade_interface.ability_upgraded.connect(on_upgrade_selected)


func check_upgrades():
	var temporary_upgrade_pool:Array[AbilityUpgrade]=upgrade_pool.duplicate()
	var choosen_upgrades:Array[AbilityUpgrade]=[]
	for i in 3:
		if temporary_upgrade_pool.size() ==0:
			break
		var choose_upgrade=temporary_upgrade_pool.pick_random() as AbilityUpgrade
		choosen_upgrades.append(choose_upgrade)
		temporary_upgrade_pool=temporary_upgrade_pool.filter(func(upgrade:AbilityUpgrade):
			return upgrade!=choose_upgrade
			)
	return choosen_upgrades
	

func apply_upgrade(upgrade:AbilityUpgrade):
	var has_upgrade=current_upgrades.has(upgrade.id) as bool
	
	if !has_upgrade:
		current_upgrades[upgrade.id]={
			"resorce":upgrade,
			"quantity":0,
		}
	else:
		current_upgrades[upgrade.id]["quantity"]+=1
	var current_quantity=current_upgrades[upgrade.id]["quantity"]
	if current_quantity==upgrade.max_quantity:
		upgrade_pool=upgrade_pool.filter(func(abilities:AbilityUpgrade):
			return abilities.id!=upgrade.id
			)
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)


func on_upgrade_selected(upgrade:AbilityUpgrade):
	experience_manager.update_level_count()
	apply_upgrade(upgrade)
