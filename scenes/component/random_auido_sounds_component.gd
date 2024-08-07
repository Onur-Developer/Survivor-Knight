extends AudioStreamPlayer2D


@export var sounds:Array[AudioStream]
@export var min_pitch:float=.7
@export var max_pitch:float=1.3
@export var pitch_change:bool=true


func change_pitch_value():
	if pitch_change:
		var random_pitch:float=randf_range(min_pitch,max_pitch)
		pitch_scale=random_pitch



func set_random_sound():
	var sound=sounds.pick_random() as AudioStream
	stream=sound
	change_pitch_value()
	play()
