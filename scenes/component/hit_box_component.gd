extends Area2D

class_name HitBoxComponent
@export var base_damage:float=5
var damage:float

func _ready():
	damage=base_damage
