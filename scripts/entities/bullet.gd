extends CharacterBody2D
class_name Bullet

@onready var trail: Line2D = $Trail
@onready var nav: NavigationAgent2D = $NavigationAgent2D

class PIDControl:
    var k_p: float = 9.
    var k_i: float = 1.5
    var k_d: float = 0.2
    var i: float = 0.
    var d: float = 0.
    var last_error: float =  0.

    func step(error: float, delta: float):
        i += error * delta
        d = (error - last_error) / delta
        last_error = error
        return (error * k_p) + (i * k_i) + (d * k_d)

var angular_pid: PIDControl = PIDControl.new()
var linear_pid: PIDControl = PIDControl.new()

func _physics_process(_delta):
    if not is_instance_valid(target_entity):
        var traincar: Traincar = get_node(^"../../../..")
        var entities: Array[CharacterEntity] = traincar.get_targetable_entities(self)
        if entities.size() == 0: return
        var distances: Array[float] = []
        distances.assign(entities.map(func(t): return t.global_position.distance_squared_to(global_position)))
        var indices: Array[int] = [] 
        indices.assign(range(entities.size()))
        var closest_idx: int = indices.reduce(
            func(acc: int, val: int):
                if distances[val] < distances[acc]:
                    return val
                else: return acc, 
            0)
        target_entity = entities[closest_idx]
    target_position = target_entity.global_position
    # print(target_entity, " ", target_position)

    var target: Vector2 = nav.get_next_path_position() - global_position
    var dir: Vector2 = target.normalized()
    var linear_error = target.length()

    var angle_target: float = atan2(dir.y, dir.x) + PI/2
    var forward_vector: Vector2 = Vector2.UP.rotated(rotation)
    var angular_error = angle_difference(rotation, angle_target)
    var angular: float = angular_pid.step(angular_error, _delta)
    angular = clamp(angular, -TAU, TAU)

    rotation += angular * _delta * 2

    var linear: float = linear_pid.step(linear_error, _delta)
    linear = clamp(linear, 100, 500)
    velocity = forward_vector * linear * _delta * 80
    var collided: bool = move_and_slide()
    if collided:
        var collision: KinematicCollision2D = get_last_slide_collision()
        if is_instance_valid(collision): handle_collision(collision)

func handle_collision(collision: KinematicCollision2D):
    var collider: Object = collision.get_collider()
    if collider is CharacterEntity:
        hit_target(collider)
        return 

func hit_target(entity: CharacterEntity):
    entity.bullet_hit(self)
    queue_free()

var target_position: Vector2 :
    set(p): nav.target_position = p
    get(): return nav.target_position
var target_entity: CharacterEntity :
    set(p):
        if p == target_entity: return
        if is_instance_valid(p):
            target_position = p.global_position
        target_entity = p

func set_target(target: CharacterEntity):
    target_entity = target

var trail_positions: Array[Vector2] = []

@export var trail_points: int = 10
@export var trail_length: float = 50
@onready var trail_point_distance: float = trail_length / trail_points

func _process(_delta: float) -> void:
    if  trail_positions.size() == 0:
        trail.add_point(Vector2.ZERO)
        trail_positions.append(global_position)
        return

    var last_position: Vector2 = trail_positions[trail_positions.size() - 1]
    if global_position.distance_to(last_position) > trail_point_distance:
        trail.add_point(Vector2.ZERO)
        trail_positions.append(global_position)
        if trail_positions.size() > trail_points:
            trail_positions.remove_at(0)

    for i: int in range(trail_positions.size()):
        trail.set_point_position(
            i,
            to_local(trail_positions[i])
        )

@onready var detection_area: BulletDetectionArea = $BulletDetectionArea
func _ready():
    detection_area.monitoring = false
    detection_area.closest_entity_changed.connect(_on_entity_closest)
    get_tree().create_timer(0.1, false).timeout.connect(func():
        detection_area.monitoring = true
    )

func _on_entity_closest(entity: CharacterEntity):
    if is_instance_valid(entity):
        target_entity = entity
