extends Node2D
class_name Traincar

@onready var world: World = $".."
@onready var nav_region: NavigationRegion2D = $NavRegion2D

@onready var entity_container: Node2D = $NavRegion2D/Level/EntityContainer
@onready var play_area: Area2D = $NavRegion2D/Level/PlayArea
@onready var play_area_shape: CollisionShape2D = $NavRegion2D/Level/PlayArea/CollisionShape2D
@onready var level: Node2D = $NavRegion2D/Level :
    set(l):
        if is_instance_valid(level):
            nav_region.remove_child(level)
            level.queue_free()
        level = l
        nav_region.add_child(level)
        if not is_instance_valid(level): return
        entity_container = l.get_node(^"EntityContainer")
        play_area = l.get_node(^"PlayArea")
        play_area_shape = l.get_node(^"PlayAreaShape")

@onready var entrance: Door = $Entrance
@onready var exit: Door = $Exit

func spawn_pickup() -> Pickup:
    var pos: Vector2 = rand_point()
    const test_pickup: PackedPickup = preload("res://resources/gun_pickup.tres")
    var new_pickup: Pickup = Pickup.from_packed(test_pickup)
    new_pickup.position = pos 
    entity_container.add_child(new_pickup)
    return new_pickup

# Spawnable area shape in local coordinates
func spawnable_area() -> Rect2:
    var shape: RectangleShape2D = play_area_shape.shape
    return shape.get_rect()

const PICKUP_NAV_LAYER = 1
func rand_point(layer: int = PICKUP_NAV_LAYER) -> Vector2: 
    var nav_rid: RID = nav_region.get_navigation_map()
    var layers: int = nav_region.get_navigation_layer_value(layer)
    var random_point: Vector2 = NavigationServer2D.map_get_random_point(nav_rid, layers, true)
    return random_point

func add_entity(entity: Node2D, where: Marker2D):
    entity_container.add_child(entity)
    entity.global_position = where.global_position
    entity.global_rotation = where.global_rotation

func character_entities() -> Array[CharacterEntity]:
    var out: Array[CharacterEntity] = []
    out.assign(entity_container
        .get_children()
        .filter(func (e): return e is CharacterEntity)
    )
    return out 

func get_targetable_entities(source: CharacterEntity) -> Array[CharacterEntity]:
    var is_hostile: bool = source.is_in_group(&"hostile")
    var entities: Array[CharacterEntity] = character_entities()
    entities = entities.filter(func(e): return is_hostile != e.is_in_group(&"hostile"))
    if entities.size() == 0: return [source]
    return entities

const PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")
func spawn_player():
    var player: Player = PLAYER_SCENE.instantiate()
    entity_container.add_child(player)
    player.global_position = entrance.global_position

func load_level(level_path: String):
    var level_scene: PackedScene = load(level_path)
    var level_node: Node2D = level_scene.instantiate()
    level = level_node

func get_hostiles() -> Array[CharacterEntity]:
    var entities: Array[CharacterEntity] = character_entities()
    entities = entities.filter(func(e): return e.is_in_group(&"hostile"))
    return entities

@onready var completion_timer: Timer = $CompletionTimer
var completed: bool = false :
    set(c):
        completed = c
        if completed: deactivate()
        if not completed: activate()

func activate():
    # TODO bake navigation map
    # TODO Open left door when ready
    completion_timer.timeout.connect(check_level_completion)
    completion_timer.start()

func _on_player_passed_right(player: Player):
    exit.close()
    level_passed.emit(player)

func deactivate():
    exit.open()
    print(exit)
    exit.player_passed_right.connect(
        _on_player_passed_right, 
        ConnectFlags.CONNECT_ONE_SHOT)
    completion_timer.stop()
    
func check_level_completion():
    if get_hostiles().size() == 0:
        completed = true

signal level_passed(player: Player)
