extends Node2D

const MAX_RADIUS=100

@export var electric:PackedScene

@onready var electric_line = $ElectricLine
@onready var cooldown_timer = $CooldownTimer
@onready var error_timer = $ErrorTimer
@onready var detection_area = $DetectionArea/CollisionShape2D
@onready var flying_turret_animated = $FlyingTurretAnimatedSprite
@onready var random_auido_sounds_component = $RandomAuidoSoundsComponent
var tween:Tween
var line_hitbox:CollisionShape2D
var start_particle:GPUParticles2D
var end_particle:GPUParticles2D
var is_attack:bool=false
var bullet_count:int=7



func _ready():
	var tween_s=create_tween()
	tween_s.tween_method(follow_player,0.0,4.0,5.0)
	tween_s.set_loops()
	$DetectionArea.area_entered.connect(on_detection_entered)
	cooldown_timer.timeout.connect(on_cooldown_timer_timeout)
	$ErrorTimer.timeout.connect(on_error_timeout)
	line_hitbox=electric_line.get_node("HitBoxComponent/CollisionShape2D")
	start_particle=electric_line.get_node("StartParticle")
	end_particle=electric_line.get_node("ExplosionParticle")


func follow_player(percent:float):
	var player=get_tree().get_first_node_in_group("player") as Node2D
	
	if player==null:
		return
	
	var rotated=Vector2.RIGHT.rotated(percent*TAU/4)
	var new_position=player.global_position + (rotated * MAX_RADIUS)
	global_position=lerp(global_position,new_position,1.5/100)


func lightning_attack(enemy:Area2D):
	is_attack=true
	random_auido_sounds_component.set_random_sound()
	electric_line.add_point(Vector2.ZERO,1)
	electric_line.points[1]=enemy.global_position - global_position
	if tween!=null and tween.is_valid():
		tween.kill()
	tween=create_tween()
	tween.tween_property(electric_line,"width",5.0,.2)
	line_hitbox.set_deferred("disabled",false)
	line_hitbox.position=electric_line.points[1]
	end_particle.position=electric_line.points[1]
	start_particle.emitting=is_attack
	end_particle.emitting=is_attack
	await tween.finished
	lightning_close()
	cooldown_timer.start()
	if bullet_count<=0:
		$ErrorTimer.start()
		flying_turret_animated.play("error")


func lightning_close():
	electric_line.remove_point(1)
	tween.kill()
	tween=create_tween()
	tween.tween_property(electric_line,"width",0,.2)
	line_hitbox.set_deferred("disabled",true)


func on_detection_entered(area2d:Area2D):
	if !is_attack and bullet_count > 0:
		lightning_attack(area2d)
		bullet_count-=1


func on_cooldown_timer_timeout():
	is_attack=false
	detection_area.set_deferred("disabled",true)
	detection_area.set_deferred("disabled",false)


func on_error_timeout():
	flying_turret_animated.play("ıdle")
	bullet_count=7
	detection_area.set_deferred("disabled",true)
	detection_area.set_deferred("disabled",false)
