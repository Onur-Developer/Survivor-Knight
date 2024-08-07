extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var health_component:HealthComponent = $HealthComponent
@onready var random_auido_sounds_component = $RandomAuidoSoundsComponent

func _ready():
	health_component.health_changed.connect(random_auido_sounds_component.set_random_sound)



func _process(delta):
	velocity_component.take_location()
	velocity_component.move(self)
