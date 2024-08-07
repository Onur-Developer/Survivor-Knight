extends RigidBody2D

@export var circle_particle_scene:PackedScene
@export var skull_particle_scene:PackedScene
var circle_particle_instantiate:Node2D
var skull_particle_instantiate:Node2D
@onready var sprite = $Sprite
@onready var collision_shape = %CollisionShape
@onready var hit_timer = $HitTimer
@onready var working_timer = $WorkingTimer
var is_working:bool=false
var inside_enemy_velocity:Array=[]
var inside_enemy_base_speed:Array=[]
var decrease_quantity:float=70
var controller
var work_time:float=5


func _ready():
	$SlowBoxComponent.area_entered.connect(on_slowbox_entered)
	$SlowBoxComponent.area_exited.connect(on_slowbox_exited)
	working_timer.timeout.connect(on_working_timer_timeout)
	hit_timer.timeout.connect(on_hit_timer_timeout)
	body_entered.connect(on_body_entered)
	collision_shape.disabled=true
	preload_explosion()


func back_normal_speed():
	for i in inside_enemy_velocity.size():
		if inside_enemy_velocity[i]==null or \
		inside_enemy_velocity[i].speed==inside_enemy_base_speed[i]:
			continue
		inside_enemy_velocity[i].speed=inside_enemy_base_speed[i]
	inside_enemy_velocity.clear()
	inside_enemy_base_speed.clear()
	sprite.visible=true
	collision_shape.disabled=true
	hit_timer.stop()
	freeze=true
	freeze=false
	is_working=false
	if circle_particle_instantiate!=null:
		circle_particle_instantiate.queue_free()
		skull_particle_instantiate.queue_free()
		circle_particle_instantiate=null
		skull_particle_instantiate=null
	preload_explosion()


func preload_explosion():
	await get_tree().create_timer(7).timeout
	if !is_working:
		working_timer.wait_time=1.0
		explosion()


func explosion():
	is_working=true
	working_timer.start()
	circle_particle_instantiate=circle_particle_scene.instantiate()
	skull_particle_instantiate=skull_particle_scene.instantiate()
	add_child(circle_particle_instantiate)
	add_child(skull_particle_instantiate)
	hit_timer.start()
	sprite.visible=false
	set_deferred("freeze",true)
	collision_shape.set_deferred("disabled",false)


func on_slowbox_entered(area:Area2D):
	var velocity_component=area.owner.get_node("VelocityComponent")
	if !inside_enemy_velocity.has(velocity_component):
		inside_enemy_velocity.append(velocity_component)
		inside_enemy_base_speed.append(velocity_component.speed)
		velocity_component.speed-=velocity_component.speed*(decrease_quantity/100)


func on_slowbox_exited(area:Area2D):
	var velocity_component=area.owner.get_node("VelocityComponent")
	if velocity_component!=null:
		for i in inside_enemy_velocity.size():
			if velocity_component==inside_enemy_velocity[i]:
				velocity_component.speed=inside_enemy_base_speed[i]


func on_hit_timer_timeout():
	collision_shape.disabled=false
	await get_tree().create_timer(.1).timeout
	collision_shape.disabled=true

func on_working_timer_timeout():
	controller.reset_vial(self)
	back_normal_speed()
	working_timer.stop()


func on_body_entered(body:Node):
	if !is_working:
		working_timer.wait_time=work_time
		explosion()
