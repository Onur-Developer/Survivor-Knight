extends Node


@export var energy_shield_scene:PackedScene

@onready var timer = $Timer

const base_time=10

var time:float
var shield_collision:CollisionShape2D
var animation_player:AnimationPlayer
var energy_shield:Node2D
var energy_shield_duration=preload("res://resources/upgrades/energy_shield_duration.tres")


func _ready():
	energy_shield=energy_shield_scene.instantiate()
	get_tree().get_first_node_in_group("player").add_child.call_deferred(energy_shield)
	shield_collision=energy_shield.get_node("CollisionShape2D")
	animation_player=energy_shield.get_node("AnimationPlayer")
	time=base_time
	adjust_timers()
	var upgrade_manager=get_tree().get_first_node_in_group("upgrade_manager")
	upgrade_manager.upgrade_pool.append(energy_shield_duration)
	GameEvents.ability_upgrade_added.connect(on_upgrade_timer)
	timer.timeout.connect(on_timer_timeout)


func adjust_timers():
	timer.wait_time=time


func on_timer_timeout():
	timer.stop()
	animation_player.play("finishing")
	await get_tree().create_timer(3).timeout
	shield_collision.set_deferred("disabled",!shield_collision.disabled)
	animation_player.stop()
	if shield_collision.disabled:
		energy_shield.modulate=Color.WHITE
	else:
		energy_shield.modulate=Color.TRANSPARENT
	timer.start()


func on_upgrade_timer(upgrade:AbilityUpgrade,current_upgrades:Dictionary):
	if upgrade.id!="energy_shield_duration":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] + 1
	time= base_time + (quantity*2.5)
	adjust_timers()
	GameEvents.disconnect_upgrade(on_upgrade_timer,upgrade,current_upgrades)
