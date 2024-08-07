extends Node

class_name HealthComponent

@export var max_health:float=10
var current_health:float
var is_dead:bool=false
signal died
signal health_changed

func _ready():
	current_health=max_health


func take_damage(damage:float):
	current_health=max(current_health - damage,0)
	if current_health==0 && !is_dead:
		is_dead=true
		died.emit()
		owner.queue_free()
	health_changed.emit()
