extends Node2D
class_name World

@onready var prev_car: Traincar = null
@onready var current_car: Traincar = $Traincar
@onready var next_car: Traincar = null
@onready var camera: GameCamera = $Camera2D

var level: int = 0

func _ready():
    load_first_level()
    load_next_level("level_test")

func load_first_level():
    current_car.spawn_player()
    current_car.activate()
    current_car.level_passed.connect(transition_next_car)

const TRAINCAR_POSITION = 540
const TRANSITION_OFFSET = 270
func traincar_position(_level: int) -> float:
    return TRAINCAR_POSITION * _level
func transition_position(_level: int) -> float:
    return TRANSITION_OFFSET * _level

const EMPTY_TRAINCAR_SCENE = preload("res://scenes/empty_traincar.tscn")
const TRANSITION_SCENE = preload("res://transition.tscn")

func transition_next_car(player: Player):
    level += 1
    if is_instance_valid(prev_car): 
        prev_car.queue_free()
    prev_car = current_car
    current_car = next_car
    next_car = null 
    load_next_level("level_empty")
    camera.following = player
    current_car.activate()

# TODO automatically determine next level from level int
func load_next_level(level_name: String):
    var level_path: String = "res://scenes/levels/" + level_name + ".tscn"
    if not is_instance_valid(next_car):
        next_car = EMPTY_TRAINCAR_SCENE.instantiate()
        add_child(next_car)
        next_car.position.x = traincar_position(level + 1)
    next_car.load_level(level_path)