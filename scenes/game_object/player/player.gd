extends CharacterBody2D

class_name Player
var speed:float
const ACCURATİON:float=25
var gained_experience:float=3
var drop_vial_chance:float=.5
var closing_enemies:int
var health_component:HealthComponent
var healing_amount:float=1

@onready var damage_interval_timer:Timer=$DamageIntervalTimer
@onready var health_bar = %HealthBar
@onready var x_looking:Node2D=$XLooking
@onready var animation_player:AnimationPlayer=$AnimationPlayer
@onready var animation_player_vignette = $VignetteUI/AnimationPlayer
@onready var health_label = %HealthLabel
@onready var sprite_2d = %Sprite2D



var pause_menu_scene=preload("res://scenes/ui/pause_menu_ui.tscn")
var player1_sprite=preload("res://scenes/game_object/player/player.png")
var player2_sprite=preload("res://scenes/game_object/player/player2.png")
var player3_sprite=preload("res://scenes/game_object/player/player3.png")


@export var base_speed:float


func _ready():
	speed=base_speed
	$PlayerHitBoxComponent.body_entered.connect(on_body_entered)
	$PlayerHitBoxComponent.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(increase_speed)
	health_component=$HealthComponent as HealthComponent
	health_component.health_changed.connect($RandomAuidoSoundsComponent.set_random_sound)
	get_drop_chance()
	adjust_health_bar()
	get_heal_count()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector:Vector2=get_input_movement()
	var direction:Vector2=movement_vector.normalized()
	var target_velocity=direction*speed
	velocity=velocity.lerp(target_velocity,1 - exp(-delta*ACCURATİON))
	move_and_slide()
	set_animations(movement_vector)


func get_drop_chance():
	if not MetaProgression.save_data["meta_upgrades"].has("experience_gain"):
		return
	var quantity=float(MetaProgression.save_data["meta_upgrades"]["experience_gain"]["quantity"])
	drop_vial_chance+=quantity/10


func get_heal_count():
	if not MetaProgression.save_data["meta_upgrades"].has("heal_count"):
		return
	var quantity=MetaProgression.save_data["meta_upgrades"]["heal_count"]["quantity"]
	healing_amount+=quantity


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		var pause_menu_instance=pause_menu_scene.instantiate()
		add_child(pause_menu_instance)


func set_animations(movement_position:Vector2):
	if movement_position!=Vector2.ZERO:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	
	if movement_position.x!=0:
		var x_value=sign(movement_position.x)
		x_looking.scale=Vector2(x_value,1)


func get_input_movement():
	var movement_x:float= Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_y:float=Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(movement_x,movement_y)


func control_enemies():
	if closing_enemies==0 || !damage_interval_timer.is_stopped():
		return
	health_component.take_damage(1)
	animation_player_vignette.play("hit")
	adjust_health_bar()
	damage_interval_timer.start()


func adjust_health_bar():
	health_bar.value=health_component.current_health
	health_label.text=str(health_component.current_health)+"/"\
	+str(health_component.max_health)
	control_sprite()


func increase_speed(upgrade:AbilityUpgrade, current_upgrades:Dictionary):
	if upgrade.id!="player_speed":
		return
	
	var quantity=current_upgrades[upgrade.id]["quantity"] as int
	speed+=base_speed*(quantity+1)/10
	GameEvents.disconnect_upgrade(increase_speed,upgrade,current_upgrades)


func control_sprite():
	var current_health=health_component.current_health
	if current_health > 7:
		sprite_2d.texture=player1_sprite
	elif current_health >= 5:
		sprite_2d.texture=player2_sprite
	else:
		sprite_2d.texture=player3_sprite


func heal_player():
	var heal_health=min(health_component.current_health+healing_amount,\
	health_component.max_health)
	health_component.current_health=heal_health
	adjust_health_bar()


func on_timer_timeout():
	control_enemies()


func on_body_entered(body:Node2D):
	closing_enemies+=1
	control_enemies()


func on_body_exited(body:Node2D):
	closing_enemies-=1
