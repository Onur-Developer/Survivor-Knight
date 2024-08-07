extends Node

@export var heal_experience:PackedScene
@export var health_component:Node
var get_chance


func _ready():
	(health_component as HealthComponent).died.connect(look_chance)
	get_chance=get_tree().get_first_node_in_group("player") as Player


func look_chance():
	if get_chance==null:
		return
	
	if randf() < .06:
		Callable(drop_vial_experience).call_deferred()


func drop_vial_experience():
	var vial_drop=heal_experience.instantiate() as Node2D
	var spawn_position=(owner as Node2D)
	var entities=get_tree().get_first_node_in_group("entities_layer") as Node2D
	entities.add_child(vial_drop)
	vial_drop.global_position=Vector2(spawn_position.global_position.x+9,\
	spawn_position.global_position.y)
