extends CharacterBody2D


@onready var velocity_component = $VelocityComponent
@onready var health_component:HealthComponent = $HealthComponent
@onready var random_auido_sounds_component = $RandomAuidoSoundsComponent
var is_moving:bool=true

func _ready():
	health_component.health_changed.connect(random_auido_sounds_component.set_random_sound)



func _process(delta):
	if is_moving:
		velocity_component.take_location()
		velocity_component.move(self)


func change_to_move(moving:bool):
	is_moving=moving
