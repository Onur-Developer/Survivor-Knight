extends Node

@export var drone_scene:PackedScene

var drone_rotation=preload("res://resources/upgrades/drone_rotation_speed.tres")
var drone_active=preload("res://resources/upgrades/drone_active_time.tres")
var drone_cooldown=preload("res://resources/upgrades/drone_cooldown_time.tres")

const X_BORDER_MINIMUM:float=50
const X_BORDER_MAXIMUM:float=900
const Y_BORDER_MINIMUM:float=50
const Y_BORDER_MAXIMUM:float=450

var drone


func _ready():
	drone=drone_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(drone)
	drone.global_position=get_position()
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(drone_rotation)
	upgrade_manager.upgrade_pool.append(drone_active)
	upgrade_manager.upgrade_pool.append(drone_cooldown)
	GameEvents.ability_upgrade_added.connect(drone_rotation_speed)
	GameEvents.ability_upgrade_added.connect(drone_active_time)
	GameEvents.ability_upgrade_added.connect(drone_cooldown_time)


func get_position():
	var x_random=randf_range(50.0,900.0) as float
	var y_random=randf_range(50.0,500.0) as float
	var new_position=Vector2(x_random,y_random) as Vector2
	return new_position


func drone_rotation_speed(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="drone_rotation_speed":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] + 1
	drone.rotation_speed=drone.base_rotation_speed + (quantity*20)
	GameEvents.disconnect_upgrade(drone_rotation_speed,upgrade,current_upgrades)


func drone_active_time(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="drone_active_time":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] + 1
	drone.active_time=drone.base_active_time + (quantity*2)
	GameEvents.disconnect_upgrade(drone_active_time,upgrade,current_upgrades)


func drone_cooldown_time(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="drone_cooldown_time":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] + 1
	drone.cooldown_time=drone.base_cooldown_time - (quantity*2)
	GameEvents.disconnect_upgrade(drone_cooldown_time,upgrade,current_upgrades)
