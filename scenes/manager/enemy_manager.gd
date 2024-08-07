extends Node

@export var enemies:Array[PackedScene]
var spawn_enemies_pool:Array[PackedScene]
var enemies_type_count:int=0

const window_radius:float=292

var player:Node2D

var entities:Node2D
var difficulty_count:int=1


func _ready():
	$Timer.timeout.connect(on_timer_update)
	player=get_tree().get_first_node_in_group("player")
	entities=get_tree().get_first_node_in_group("entities_layer")
	spawn_enemies_pool.append(enemies[0])
	$NewEnemyTimer.timeout.connect(on_timer_new_enemies)
	$DifficultyTimer.timeout.connect(on_diffuculty_timer)


func get_spawn_position():
	if player ==null:
		return
	
	
	var spawn_position=Vector2.ZERO
	var random_location:Vector2=Vector2.RIGHT.rotated(randf_range(0,TAU))
	for i in 4:
		spawn_position=player.global_position + (random_location * window_radius)
		var additional_check_offset=random_location * 20
		var query_parameter=PhysicsRayQueryParameters2D.create(player.global_position+additional_check_offset,spawn_position,1)
		var result=get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameter)
		
		if result.is_empty():
			break
		else:
			random_location=random_location.rotated(deg_to_rad(90))
	
	return spawn_position


func on_timer_update():
	if player ==null:
		return
	
	for i in difficulty_count:
		var pick_random_enemy=spawn_enemies_pool.pick_random() as PackedScene
		var spawn_enemy=pick_random_enemy.instantiate() as Node2D
		entities.add_child(spawn_enemy)
		spawn_enemy.global_position=get_spawn_position()


func on_timer_new_enemies():
	enemies_type_count+=1
	spawn_enemies_pool.append(enemies[enemies_type_count])
	if spawn_enemies_pool.size()==enemies.size():
		$NewEnemyTimer.stop()


func on_diffuculty_timer():
	difficulty_count+=1
