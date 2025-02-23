extends Node2D
class_name World

@onready var prev_car: Traincar = null
@onready var current_car: Traincar = $Traincar
@onready var next_car: Traincar = null
@onready var camera: GameCamera = $"../Camera2D"

@export var starting_level = 1

signal level_ready(level: int)
signal life_lost()

var player: Player = null
var level: int = 0

const LEVEL_DIR_DICT: Dictionary = {
    # 0: "test"
    0: "easy",
    5: "medium",
    # 10: "hard",
}
static var dir_changes: Array = LEVEL_DIR_DICT.keys()

const EASY_LEVELS: Array[String] = ["bowl","choice","easy","glass","rowless","sneak","vision"]
const MEDIUM_LEVELS: Array[String] = ["bone","bridge","cage","closet","columns","cover","guards","rows","stealth","towers"]
const HARD_LEVELS: Array[String] = ["fracture", "narrow", "race", "room", "run", "stop", "tube", "zig"]

const LEVELS: Dictionary = { # Dictionary[String, PackedScene]
    "bowl": preload("res://levels/easy/bowl.tscn"),
    "choice": preload("res://levels/easy/choice.tscn"),
    "easy": preload("res://levels/easy/easy.tscn"),
    "glass": preload("res://levels/easy/glass.tscn"),
    "rowless": preload("res://levels/easy/rowless.tscn"),
    "sneak": preload("res://levels/easy/sneak.tscn"),
    "vision": preload("res://levels/easy/vision.tscn"),
    "bone": preload("res://levels/medium/bone.tscn"),
    "bridge": preload("res://levels/medium/bridge.tscn"),
    "cage": preload("res://levels/medium/cage.tscn"),
    "closet": preload("res://levels/medium/closet.tscn"),
    "columns": preload("res://levels/medium/columns.tscn"),
    "cover": preload("res://levels/medium/cover.tscn"),
    "guards": preload("res://levels/medium/guards.tscn"),
    "rows": preload("res://levels/medium/rows.tscn"),
    "stealth": preload("res://levels/medium/stealth.tscn"),
    "towers": preload("res://levels/medium/towers.tscn"),
    "fracture": preload("res://levels/hard/fracture.tscn"),
    "narrow": preload("res://levels/hard/narrow.tscn"),
    "race": preload("res://levels/hard/race.tscn"),
    "room": preload("res://levels/hard/room.tscn"),
    "run": preload("res://levels/hard/run.tscn"),
    "stop": preload("res://levels/hard/stop.tscn"),
    "tube": preload("res://levels/hard/tube.tscn"),
    "zig": preload("res://levels/hard/zig.tscn")
}
const LEVEL_EMPTY: PackedScene = preload("res://levels/empty.tscn")

func get_level_scene(_level: int) -> PackedScene:
    if _level == 0: return LEVEL_EMPTY
    _level += starting_level
    var last_idx: int = 0
    for i: int in dir_changes:
        if i > _level: break
        last_idx = i
    var dir: String = LEVEL_DIR_DICT[last_idx]
    if dir == "easy": return LEVELS[pick_not_seen(EASY_LEVELS)]
    if dir == "medium": return LEVELS[pick_not_seen(MEDIUM_LEVELS)]
    else: return LEVELS[pick_not_seen(HARD_LEVELS)]

var seen_levels: Array[String] = []
func pick_not_seen(arr: Array[String]):
    var filtered_arr: Array[String] = []
    filtered_arr.assign(
        arr.filter(func(level_name): return level_name not in seen_levels)
    )
    var picked: String
    if filtered_arr.size() > 0:
        picked = filtered_arr.pick_random()
    else:
        seen_levels.clear()
        picked = arr.pick_random()
    seen_levels.append(picked)
    return picked

func _on_player_death():
    current_car.activate()
    life_lost.emit()

func start_game():
    setup_player()

    var level_scene_first: PackedScene = get_level_scene(level)
    load_first_level(level_scene_first)
    activate_level()

    var level_scene_next: PackedScene = get_level_scene(level + 1)
    load_next_level(level_scene_next)

const PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")

func activate_level():
    var player_parent: Node = player.get_parent()
    if is_instance_valid(player_parent):
        player.reparent(current_car.entity_container, true)
    else:
        current_car.entity_container.add_child(player)
        player.global_position = current_car.entrance.global_position
        player.position.x -= 30

    level_ready.emit(level)
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
    var level_scene: PackedScene = get_level_scene(level + 1)
    load_next_level(level_scene)
    camera.following = _player
    activate_level()

func _on_level_started(_player: Player):
    camera.following = null
    camera.target_x = traincar_position(level) + position.x

func load_first_level(level_scene: PackedScene):
    current_car.load_level(level_scene)

func load_next_level(level_scene: PackedScene):
    if not is_instance_valid(next_car):
        next_car = EMPTY_TRAINCAR_SCENE.instantiate()
        add_child(next_car)
        next_car.position.x = traincar_position(level + 1)

        var next_transition: Node2D = TRANSITION_SCENE.instantiate()
        next_car.add_child(next_transition)
        next_transition.global_position.x = next_car.global_position.x + TRANSITION_OFFSET
    next_car.load_level(level_scene)

func setup_player() -> void:
    player = PLAYER_SCENE.instantiate()
    player.setup_respawn(self)
    player.player_died.connect(_on_player_death)
