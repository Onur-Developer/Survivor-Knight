extends Node

@export var sword_ability: PackedScene
var sword
var player
var sword_hitbox:HitBoxComponent
var foreground:Node2D

var max_distance:float=150

# Called when the node enters the scene tree for the first time.
func _ready():
	player=get_tree().get_first_node_in_group("player") as Node2D
	foreground=get_tree().get_first_node_in_group("foreground_layer")
	sword= sword_ability.instantiate() as Node2D
	sword_hitbox=sword.get_node("HitBoxComponent") as HitBoxComponent
	foreground.add_child.call_deferred(sword)
	sword.global_position=player.global_position
	$Timer.timeout.connect(update_location)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func update_location():
	var enemies=get_tree().get_nodes_in_group("enemies")
	enemies=enemies.filter(func(enemy:Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(max_distance,2)
		)
	
	if enemies.size() ==0:
		return
	
	enemies.sort_custom(func(a:Node2D,b:Node2D):
		var a_distance=a.global_position.distance_squared_to(player.global_position)
		var b_distance=b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance
		)
	sword.global_position=enemies[0].global_position


func on_ability_upgrade_added(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="sword_rate":
		return
	
	var level_quantity:float=(sword_hitbox.base_damage*(current_upgrades["sword_rate"]["quantity"]+1)/10)
	sword_hitbox.damage=sword_hitbox.damage+level_quantity
	GameEvents.disconnect_upgrade(on_ability_upgrade_added,upgrade,current_upgrades)
