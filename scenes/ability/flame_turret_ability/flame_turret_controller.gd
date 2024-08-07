extends Node


@export var flame_turret_scene:PackedScene
const X_BORDER_MINIMUM:float=50
const X_BORDER_MAXIMUM:float=900
const Y_BORDER_MINIMUM:float=50
const Y_BORDER_MAXIMUM:float=500
var turrets:Array=[]
var before_position:Vector2=Vector2.ZERO


func _ready():
	add_flame_turret()
	GameEvents.ability_upgrade_added.connect(decrease_repair_time)
	GameEvents.ability_upgrade_added.connect(ıncrease_flame_turret_count)
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(upgrade_manager.flame_turret_repair)
	upgrade_manager.upgrade_pool.append(upgrade_manager.flame_turret_count)


func add_flame_turret():
	var flame_turret_instance=flame_turret_scene.instantiate() as Node2D
	var foreground_layer=get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(flame_turret_instance)
	flame_turret_instance.global_position=get_position()
	turrets.append(flame_turret_instance)


func get_position():
	var turret_position=Vector2.ZERO
	for i in 4:
		var x_position:float=randf_range(X_BORDER_MINIMUM,X_BORDER_MAXIMUM)
		var y_position:float=randf_range(Y_BORDER_MINIMUM,Y_BORDER_MAXIMUM)
		turret_position=Vector2(x_position,y_position)
		if turret_position.distance_to(before_position) < 10:
			continue
		else:
			break
	before_position=turret_position
	return turret_position


func decrease_repair_time(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="flame_turret_repair":
		return
	
	for i in turrets:
		i.repair_timer = i.base_repair_time - current_upgrades[upgrade.id]["quantity"]
	
	GameEvents.disconnect_upgrade(decrease_repair_time,upgrade,current_upgrades)


func ıncrease_flame_turret_count(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="flame_turret_count":
		return
	
	add_flame_turret()
	for i in turrets:
		if !current_upgrades.has("flame_turret_repair"):
			break
		var quantity=current_upgrades["flame_turret_repair"]["quantity"]
		i.repair_timer = i.base_repair_time - quantity
	GameEvents.disconnect_upgrade(ıncrease_flame_turret_count,upgrade,current_upgrades)
