extends Node2D
class_name World

@onready var prev_car: Traincar = null
@onready var current_car: Traincar = $Traincar
@onready var next_car: Traincar = null
@onready var camera: GameCamera = $Camera2D

var player: Player = null
var level: int = 0

func _ready():
    player = PLAYER_SCENE.instantiate()
    activate_level()
    load_next_level("level_test")

const PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")

func activate_level():
    var player_parent: Node = player.get_parent()
    if is_instance_valid(player_parent):
        player.reparent(current_car.entity_container, true)
    else:
        current_car.entity_container.add_child(player)
        player.global_position = current_car.entrance.global_position

    current_car.activate()
    current_car.level_started.connect(
        _on_level_started,
        ConnectFlags.CONNECT_ONE_SHOT )
    current_car.level_passed.connect(
        transition_next_car,
        ConnectFlags.CONNECT_ONE_SHOT )

const TRAINCAR_POSITION = 540
const TRANSITION_OFFSET = 270
func traincar_position(_level: int) -> float:
    return TRAINCAR_POSITION * _level

const EMPTY_TRAINCAR_SCENE = preload("res://scenes/empty_traincar.tscn")
const TRANSITION_SCENE = preload("res://scenes/transition.tscn")

func free_prev_car():
    var delete_timer: SceneTreeTimer = get_tree().create_timer(1., false)
    delete_timer.timeout.connect(prev_car.queue_free)

func transition_next_car(_player: Player):
    level += 1
    if is_instance_valid(prev_car): 
        free_prev_car()
    prev_car = current_car
    current_car = next_car
    next_car = null 
    load_next_level("level_empty")
    camera.following = _player
    activate_level()

func _on_level_started(_player: Player):
    camera.following = null
    camera.target_x = traincar_position(level)

# TODO automatically determine next level from level int
func load_next_level(level_name: String):
    var level_path: String = "res://scenes/levels/" + level_name + ".tscn"
    if not is_instance_valid(next_car):
        next_car = EMPTY_TRAINCAR_SCENE.instantiate()
        add_child(next_car)
        next_car.position.x = traincar_position(level + 1)

        var next_transition: Node2D = TRANSITION_SCENE.instantiate()
        next_car.add_child(next_transition)
        next_transition.global_position.x = next_car.global_position.x + TRANSITION_OFFSET
    next_car.load_level(level_path)