extends Node


var velocity:Vector2=Vector2.ZERO

@export var speed:float=30
@export var acceleration:float=5
@export var x_value:Node2D



func take_location():
	var player=get_tree().get_first_node_in_group("player") as Node2D
	var owner_location=owner as Node2D
	if player==null or owner_location==null:
		return
	
	var send_location:Vector2=( player.global_position - owner_location.global_position).normalized()
	go_to_player(send_location)
	rotation_player(player,owner_location)


func go_to_player(direction:Vector2):
	var desired_velocity:Vector2=direction* speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func move(character_body_2d:CharacterBody2D):
	character_body_2d.velocity=velocity
	character_body_2d.move_and_slide()
	velocity=character_body_2d.velocity


func rotation_player(player_pos:Node2D, owner_pos:Node2D):
	var looking=sign(player_pos.global_position.x - owner_pos.global_position.x)
	x_value.scale=Vector2(looking,1)
