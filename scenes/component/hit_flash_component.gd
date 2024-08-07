extends Node

@export var health_component:HealthComponent
@export var sprite:Sprite2D
@export var shader_material=ShaderMaterial
var current_tween:Tween


func _ready():
	health_component.health_changed.connect(on_health_changed)
	sprite.material=shader_material


func on_health_changed():
	if current_tween!=null and current_tween.is_valid():
		current_tween.kill()
	(sprite.material as ShaderMaterial).set_shader_parameter("flash_percent",1.0) 
	current_tween=create_tween()
	current_tween.tween_property(sprite.material,"shader_parameter/flash_percent",0.0,.25)\
	.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
