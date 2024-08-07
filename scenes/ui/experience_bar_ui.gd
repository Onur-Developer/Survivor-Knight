extends CanvasLayer

@export var experience_manager:Node
@onready var experience_bar:ProgressBar=$MarginContainer/ProgressBar


func _ready():
	experience_manager.experience_updated.connect(update_experience_bar)
	experience_bar.value=0



func update_experience_bar(current_experience:float,target_experience:float):
	experience_bar.value=current_experience / target_experience
