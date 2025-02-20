extends Area2D 
class_name BulletDetectionArea

@onready var cone_collision: ConeCollisionShape2D = $ConeCollisionShape2D

signal entity_detected(entity: CharacterEntity)
signal entity_lost(entity: CharacterEntity)
signal closest_entity_changed(entity: CharacterEntity)

func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    entity_detected.connect(_on_entity_detected)
    entity_lost.connect(_on_entity_lost)

func _on_body_entered(body: Node2D):
    if body is CharacterEntity:
        entity_detected.emit(body)

func _on_body_exited(body: Node2D):
    if body is CharacterEntity and body in tracked_entities:
        entity_lost.emit(body)

var tracked_entities: Array[CharacterEntity]
var tracker_casts: Array[RayCast2D]
var closest: CharacterEntity

func _on_entity_detected(entity: CharacterEntity):
    tracked_entities.append(entity)
    var raycast: RayCast2D = RayCast2D.new()
    add_child(raycast)
    tracker_casts.append(raycast)

func _on_entity_lost(entity: CharacterEntity):
    var idx: int = tracked_entities.find(entity)
    tracked_entities.remove_at(idx)
    var raycast: RayCast2D = tracker_casts[idx]
    tracker_casts.remove_at(idx)
    raycast.queue_free()

func _physics_process(_delta: float):
    var n: int = tracked_entities.size()
    if n == 0: return
    var seen_idxs: Array[int] = []
    var distances: Array[float] = []
    for idx: int in range(n):
        var target: CharacterEntity = tracked_entities[idx]
        var raycast: RayCast2D = tracker_casts[idx]
        if not is_instance_valid(target): return
        raycast.target_position = target.global_position * global_transform
        raycast.force_raycast_update()
        var first_collider: Object = raycast.get_collider()
        if first_collider == target:
            seen_idxs.append(idx)
            var collision_point: Vector2 = raycast.get_collision_point()
            var distance: float = global_position.distance_to(collision_point)
            distances.append(distance)
        else:
            distances.append(INF)
    if seen_idxs.size() == 0: return
    var closest_idx: int = seen_idxs.reduce(func (acc, val):
        var dist_min: float = distances[acc]
        var dist_val: float = distances[val]
        if dist_min < dist_val: return acc
        else: return val,
        0
    )
    var new_closest: CharacterEntity = tracked_entities[closest_idx]
    if new_closest == closest: return
    closest = new_closest
    closest_entity_changed.emit(closest)