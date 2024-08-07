extends Node

@export var axe_ability:PackedScene

var player:Node2D
var create_axe:Node2D
var tween:Tween
var base_rotation:Vector2
var hitbox_component:HitBoxComponent

const MAX_RADIUS=100


func _ready():
	var foreground=get_tree().get_first_node_in_group("foreground_layer") as Node2D
	GameEvents.ability_upgrade_added.connect(increase_axe_damage)
	player=get_tree().get_first_node_in_group("player") as Node2D
	create_axe=axe_ability.instantiate() as Node2D
	foreground.add_child(create_axe)
	create_axe.global_position=player.global_position
	hitbox_component=create_axe.get_node("HitBoxComponent") as HitBoxComponent
	base_rotation=Vector2.RIGHT.rotated(randf_range(0,TAU))
	tween=create_tween()
	tween.tween_method(tween_update,0.0,2.5,4.5)
	tween.set_loops()
	tween.tween_callback(change_rotation)


func tween_update(rotation:float):
	var current_radius:float=(rotation/2)*MAX_RADIUS
	if player==null:
		return
	var current_rotation=base_rotation.rotated(rotation*TAU)
	create_axe.global_position=player.global_position + (current_radius*current_rotation)


func change_rotation():
	base_rotation=Vector2.RIGHT.rotated(randf_range(0,TAU))


func increase_axe_damage(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id != "axe_damage":
		return
	hitbox_component.damage= hitbox_component.damage+\
	(hitbox_component.base_damage * (current_upgrades[upgrade.id]["quantity"]+1))/10
	GameEvents.disconnect_upgrade(increase_axe_damage,upgrade,current_upgrades)
