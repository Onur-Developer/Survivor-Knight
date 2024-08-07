extends Node


@export var anvil_ability_scene:PackedScene


var anvil_pool:Array[Node2D]=[]
var reset_gravity_speed:Array[RigidBody2D]

const distance_from_player:float=75


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	add_anvil()
	set_position_anvil()
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(upgrade_manager.anvil_count)


func add_anvil():
	var anvil_ability=anvil_ability_scene.instantiate()
	var anvil_rigidbody=anvil_ability as RigidBody2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(anvil_ability)
	anvil_pool.append(anvil_ability)
	reset_gravity_speed.append(anvil_rigidbody)


func set_position_anvil():
	var player=get_tree().get_first_node_in_group("player") as Node2D
	if player==null:
		return
	
	for i in anvil_pool.size():
		var random_x=randf_range(-distance_from_player,distance_from_player)
		anvil_pool[i].global_position=Vector2(player.global_position.x+random_x,-185)


func on_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="anvil_count":
		return
	add_anvil()
	GameEvents.disconnect_upgrade(on_ability_upgrade_added,upgrade,current_upgrades)


func on_timer_timeout():
	for i in anvil_pool.size():
		reset_gravity_speed[i].freeze=true
		reset_gravity_speed[i].freeze=false
	set_position_anvil()
