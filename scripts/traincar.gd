extends Node2D
class_name Traincar

@onready var world: World = $".."
@onready var entity_container: Node2D = $EntityContainer
@onready var play_area: Area2D = $PlayArea
@onready var play_area_shape: CollisionShape2D = $PlayArea/CollisionShape2D
@onready var nav_region: NavigationRegion2D = $NavigationRegion2D

var pickup: Pickup = null
func _process(_delta):
    if not is_instance_valid(pickup): 
        pickup = spawn_pickup()

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