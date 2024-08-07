extends Area2D


@export var health_component:HealthComponent


var floating_text_scene=preload("res://scenes/ui/floating_damage_text.tscn")


func _ready():
	area_entered.connect(on_area_entered)


func on_area_entered(on_area:Area2D):
	var damage_amount=on_area as HitBoxComponent
	health_component.take_damage(damage_amount.damage)
	if health_component.current_health<=0:
		var collision= get_child(0) as CollisionShape2D
		collision.set_deferred("disabled",true)
	var floating_text=floating_text_scene.instantiate() as Node2D
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	floating_text.global_position=global_position
	floating_text.animate_and_write(str(damage_amount.damage))
