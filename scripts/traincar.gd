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
        play_area_shape = l.get_node(^"PlayArea/CollisionShape2D")

@onready var entrance: Door = $Entrance
@onready var exit: Door = $Exit

func in_play_area(global_pos: Vector2) -> bool:
    var playable_rect: Rect2 = spawnable_area()
    var inside: bool = playable_rect.has_point(to_local(global_pos))
    return inside

func spawn_pickup(packed: PackedPickup, global_pos: Vector2) -> Pickup:
    if not global_pos.is_finite():
        global_pos = rand_point()
    var new_pickup: Pickup = Pickup.from_packed(packed)
    entity_container.add_child(new_pickup)
    new_pickup.global_position = global_pos 
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

func get_pickups() -> Array[Pickup]:
    var out: Array[Pickup] = []
    out.assign(entity_container
        .get_children()
        .filter(func (e): return e is Pickup)
    )
    return out

func get_targetable_entities(source: CharacterEntity) -> Array[CharacterEntity]:
    var is_hostile: bool = source.is_in_group(&"hostile")
    var entities: Array[CharacterEntity] = character_entities()
    entities = entities.filter(func(e): return is_hostile != e.is_in_group(&"hostile"))
    if entities.size() == 0: return [source]
    return entities

var loaded_level_path = null
func load_level(level_path: String):
    loaded_level_path = level_path
    var level_scene: PackedScene = load(level_path)
    var level_node: Node2D = level_scene.instantiate()
    level = level_node
    level.process_mode = Node.PROCESS_MODE_DISABLED

func reload_level():
    load_level(loaded_level_path)

func get_player() -> Player:
    var entities: Array[CharacterEntity] = character_entities()
    for entity: CharacterEntity in entities:
        if entity is Player:
            return entity
    return null

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
    level.process_mode = Node.PROCESS_MODE_INHERIT
    nav_region.bake_finished.connect( 
        _activate_on_bake_finished,
        ConnectFlags.CONNECT_ONE_SHOT)
    nav_region.bake_navigation_polygon()
    
func _activate_on_bake_finished():
    exit.close()
    await get_tree().create_timer(0.5).timeout
    entrance.open()
    entrance.player_passed_right.connect(
        _on_entrance_player_passed_right, 
        ConnectFlags.CONNECT_ONE_SHOT)
    if not completion_timer.timeout.is_connected(check_level_completion):
        completion_timer.timeout.connect(check_level_completion)
    completion_timer.start()

func _on_entrance_player_passed_right(player: Player):
    entrance.close()
    level_started.emit(player)
    get_tree().create_timer(1.).timeout.connect(func():
        if not is_instance_valid(player) or not is_instance_valid(entrance): return
        if player.global_position.x < entrance.global_position.x:
            entrance.open()
            entrance.player_passed_right.connect(
                _on_entrance_player_passed_right, 
                ConnectFlags.CONNECT_ONE_SHOT)
    )

func _on_exit_player_passed_right(player: Player):
    exit.close()
    level_passed.emit(player)
    get_tree().create_timer(1.).timeout.connect(func():
        if not is_instance_valid(player) or not is_instance_valid(exit): return
        if player.global_position.x < exit.global_position.x:
            exit.open()
            exit.player_passed_right.connect(
                _on_exit_player_passed_right, 
                ConnectFlags.CONNECT_ONE_SHOT)
    )

func deactivate():
    exit.open()
    exit.player_passed_right.connect(
        _on_exit_player_passed_right, 
        ConnectFlags.CONNECT_ONE_SHOT)
    completion_timer.stop()
    
func check_level_completion():
    if get_hostiles().size() == 0:
        completed = true

signal level_passed(player: Player)
signal level_started(player: Player)

signal noise(position: Vector2)

func make_noise(node: Node2D):
    noise.emit(node.global_position)

func has_pickup() -> bool:
    return get_pickups().size() > 0

func closest_pickup(pos: Vector2):
    var pickups: Array[Pickup] = get_pickups()
    if pickups.size() == 0:
        return null
    elif pickups.size() == 1:
        return pickups[0]
    var distances: Array[float] = []
    distances.assign(pickups.map(func(t): return t.global_position.distance_squared_to(pos)))
    var indices: Array[int] = [] 
    indices.assign(range(pickups.size()))
    var closest_idx: int = indices.reduce(
        func(acc: int, val: int):
            if distances[val] < distances[acc]:
                return val
            else: return acc, 
        0)
    return pickups[closest_idx]
