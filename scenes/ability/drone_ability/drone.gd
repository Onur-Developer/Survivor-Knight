extends Node2D


const base_rotation_speed:float=80
const base_active_time:float=10
const base_cooldown_time:float=10

var rotation_speed:float
var is_cooldown:bool=false
var cooldown_time:float=10
var active_time:float=10

@onready var progress_bar = $ProgressBar
@onready var reload_timer = $ReloadTimer
@onready var gpu_particles = $GPUParticles



func _ready():
	reload_timer.timeout.connect(on_reload_timer_timeout)
	reload_timer.wait_time=active_time
	rotation_speed=base_rotation_speed
	play_audio()


func _process(delta):
	if !is_cooldown:
		rotation_degrees+=rotation_speed*delta


func situation():
	$LaserRay.visible=!is_cooldown
	$LaserRay2.visible=!is_cooldown
	%LaserCollisionShape.disabled=is_cooldown
	%LaserCollisionShape2.disabled=is_cooldown
	gpu_particles.emitting=is_cooldown
	rotation_degrees=0
	progress_bar.visible=is_cooldown
	play_audio()
	var tween=create_tween()
	tween.tween_property(progress_bar,"value",progress_bar.max_value,reload_timer.wait_time)
	tween.tween_callback(end_tween.bind(tween))


func end_tween(tween:Tween):
	if tween.is_valid():
		tween.kill()
	progress_bar.value=0
	gpu_particles.emitting=false


func play_audio():
	if is_cooldown:
		$CooldownAuidoSoundComponent.set_random_sound()
		$ActiveAuidoSoundComponent.stop()
	else:
		$ActiveAuidoSoundComponent.set_random_sound()
		$CooldownAuidoSoundComponent.stop()


func on_reload_timer_timeout():
	reload_timer.stop()
	is_cooldown=!is_cooldown
	reload_timer.wait_time= cooldown_time if is_cooldown else active_time
	reload_timer.start()
	situation()
