extends RigidBody2D


@export var particle_explosion_scene:PackedScene
var foreground_layer:Node2D


func _ready():
	$HitBoxComponent.area_entered.connect(on_area_entered)
	foreground_layer=get_tree().get_first_node_in_group("foreground_layer")


func on_area_entered(area:Area2D):
	var particle_explosion_instance=particle_explosion_scene.instantiate() as Node2D
	foreground_layer.add_child(particle_explosion_instance)
	particle_explosion_instance.global_position=area.global_position
