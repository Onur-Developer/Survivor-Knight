extends StaticBody2D


var target:Node2D
@onready var detection_collision_shape = %DetectionCollisionShape
@onready var flame_turret = $FlameTurretHeadSprite
@onready var fire_particles = %FireParticles
@onready var fire_collision_shape = %FireCollisionShape
@onready var hit_timer = $HitTimer
@onready var progress_bar = $ProgressBar
@onready var start_audio_stream_component = $StartAudioSoundsComponent
@onready var detection_area = $DetectionArea



var fuel:int=15
var is_repair:bool=false
var repair_timer:int
const base_repair_time:int=10
var inside_enemy:int=0



func _ready():
	$DetectionArea.area_entered.connect(on_detection_entered)
	$DetectionArea.area_exited.connect(on_detection_exited)
	hit_timer.timeout.connect(on_hit_timer_timeout)
	$AlarmTimer.timeout.connect(on_alarm_timer_timeout)
	repair_timer=base_repair_time


func _process(_delta):
	look_to_enemy()


func look_to_enemy():
	if target==null or fuel <= 0:
		return
	
	flame_turret.look_at(target.global_position)
	flame_turret.flip_v=global_position > target.global_position


func repair_fuel():
	inside_enemy=0
	detection_area.set_deferred("monitoring",false)
	is_repair=true
	progress_bar.visible=true
	flame_turret.rotation_degrees=-90
	fire_collision_shape.set_deferred("disabled",true)
	start_audio_stream_component.stop()
	var tween=create_tween()
	tween.tween_method(tween_repair,0,100,repair_timer)
	tween.tween_callback(repair_complete)


func tween_repair(percent:float):
	progress_bar.value=percent


func repair_complete():
	fuel=25
	progress_bar.visible=false
	is_repair=false
	flame_turret.rotation_degrees=0
	detection_area.set_deferred("monitoring",true)


func on_detection_entered(area:Area2D):
	inside_enemy+=1
	if target==null and fuel > 0:
		target=area as Node2D
		fire_particles.emitting=fuel > 0
		hit_timer.start()
		start_audio_stream_component.set_random_sound()


func on_detection_exited(area:Area2D):
		inside_enemy-=1
		if inside_enemy<=0:
			start_audio_stream_component.stop()
		target=null
		fire_particles.emitting=false
		hit_timer.stop()
		fire_collision_shape.set_deferred("disabled",true)
		detection_collision_shape.set_deferred("disabled",true)
		await get_tree().create_timer(0.1).timeout
		detection_collision_shape.set_deferred("disabled",false)
		if fuel <=0 and !is_repair:
			repair_fuel()


func on_hit_timer_timeout():
	if fuel <=0 and !is_repair:
		repair_fuel()
		fire_particles.emitting=false
		hit_timer.stop()
		return
	fuel-=1
	fire_collision_shape.set_deferred("disabled",true)
	fire_collision_shape.set_deferred("disabled",false)


func on_alarm_timer_timeout():
	if inside_enemy > 0:
		$FlameTurretAlarm2.set_random_sound()
	else:
		$FlameTurretAlarm1.set_random_sound()
