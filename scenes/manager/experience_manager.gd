extends Node

var current_experience:float=0
var target_experience:float=5
var current_level:int=1

const GROW_TARGET_EXPERİENCE:float=2.5

signal experience_updated(current_experience:float,target_experience:float)
signal level_up(new_level:int)

func _ready():
	GameEvents.experience_collected.connect(on_increase_experience)


func increase_experience(value:float):
	current_experience=min(current_experience+value,target_experience)
	if current_experience == target_experience:
		level_up.emit(current_level)
	emit_experience_updated(current_experience,target_experience)


func update_level_count():
	target_experience+=GROW_TARGET_EXPERİENCE
	current_level+=1
	current_experience=0
	emit_experience_updated(current_experience,target_experience)


func emit_experience_updated(current_experiences:float,target_experiences:float):
	experience_updated.emit(current_experiences,target_experiences)


func on_increase_experience(value:float):
	increase_experience(value)
