extends CanvasLayer


@export var arena_time_manager: Node
@export var victory_scene:PackedScene
var arena_time:Timer
@onready var label:Label=%Label
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	arena_time=arena_time_manager.get_node("Timer") as Timer
	arena_time.timeout.connect(on_arena_time_timeout)
	player=get_tree().get_first_node_in_group("player").get_node("HealthComponent") as HealthComponent
	player.died.connect(set_lost)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text=str(get_time_by_string())


func set_lost():
	var victory_scene_spawn=victory_scene.instantiate()
	owner.add_child(victory_scene_spawn)
	victory_scene_spawn.set_defeat()
	victory_scene_spawn.play_jingle(true)
	MetaProgression.save()


func get_time_by_string():
	return floor(arena_time.time_left)


func on_arena_time_timeout():
	var victory_scene_spawn=victory_scene.instantiate()
	owner.add_child(victory_scene_spawn)
	victory_scene_spawn.play_jingle()
	MetaProgression.save()
