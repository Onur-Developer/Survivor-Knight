extends Node


@export var wooden_sword_ability_scene:PackedScene
var wooden_sword_ability_instance
var wooden_sword_animation:AnimationPlayer


func _ready():
	wooden_sword_ability_instance=wooden_sword_ability_scene.instantiate()
	var x_looking=get_tree().get_first_node_in_group("player")\
	.get_tree().get_first_node_in_group("x_looking")
	x_looking.add_child(wooden_sword_ability_instance)
	wooden_sword_animation=wooden_sword_ability_instance.get_child(0)
	wooden_sword_animation.animation_finished.connect(on_animation_finished)
	$Timer.timeout.connect(on_timer_timeout)


func follow_player(percent:float):
	var player=get_tree().get_first_node_in_group("player") as Node2D
	
	if player==null:
		return
	wooden_sword_ability_instance.global_position=player.global_position


func on_timer_timeout():
	wooden_sword_animation.play("hit")
	var tween=create_tween()
	tween.tween_method(follow_player,0,1,.5)


func on_animation_finished(anim_name:StringName):
	if anim_name=="hit":
		wooden_sword_animation.play("out")
