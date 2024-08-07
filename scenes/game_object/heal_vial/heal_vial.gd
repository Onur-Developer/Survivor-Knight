extends Node2D


@onready var sprite = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	$Timer.timeout.connect(on_timer_timeout)


func collect_animation(percent:float,start_position:Vector2):
	var player=get_tree().get_first_node_in_group("player") as Node2D
	
	if player==null:
		return
	
	global_position=start_position.lerp(player.global_position,percent)
	var direction_from_start=player.global_position - start_position
	var target_rotation=direction_from_start.angle() + deg_to_rad(90)
	rotation=lerp_angle(rotation,target_rotation, 1 - exp(-2 * get_process_delta_time()))


func collect():
	var player=get_tree().get_first_node_in_group("player")
	
	if player ==null:
		return
	
	$RandomAuidoSoundsComponent.set_random_sound()
	await $RandomAuidoSoundsComponent.finished
	player.heal_player()
	queue_free()


func disable_collision():
	$Area2D/CollisionShape2D.disabled=true

func on_area_entered(area_2d:Area2D):
	$AnimatedSprite2D.visible=false
	$Sprite2D.visible=true
	var tween=create_tween()
	Callable(disable_collision)
	tween.set_parallel()
	tween.tween_method(collect_animation.bind(global_position),0.0,1.0,.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite,"scale",Vector2.ZERO,.20).set_delay(.30)
	tween.chain()
	tween.tween_callback(collect)


func on_timer_timeout():
	if not $AnimationPlayer.current_animation=="disappear":
		$AnimationPlayer.play("disappear")
	else:
		queue_free()
