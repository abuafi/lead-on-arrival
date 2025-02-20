extends Node2D
class_name World

@onready var prev_car: Traincar = null
@onready var current_car: Traincar = $Traincar
@onready var next_car: Traincar = null

func _ready():
    current_car.spawn_player()
    load_next_level("level_test")

var level: int = 0
func traincar_position(_level: int) -> float:
    return 540 * _level

const EMPTY_TRAINCAR_SCENE = preload("res://scenes/empty_traincar.tscn")

func load_next_level(level_name: String):
    var level_path: String = "res://scenes/levels/" + level_name + ".tscn"
    if not is_instance_valid(next_car):
        next_car = EMPTY_TRAINCAR_SCENE.instantiate()
        add_child(next_car)
        next_car.position.x = traincar_position(level + 1)
    next_car.load_level(level_path)