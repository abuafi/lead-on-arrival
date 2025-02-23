extends Node2D
class_name Weapon

@onready var play_fire: AudioStreamPlayer2D = $Fire
@onready var play_invalid: AudioStreamPlayer = $Invalid
@onready var muzzle: Marker2D = $Muzzle
@onready var checker: RayCast2D = $Muzzle/CheckerRaycast
@onready var bullet_nav: NavigationAgent2D = $BulletNav

var weapon_resource: PackedEquippablePickup = null

var entity: CharacterEntity = null
var body: Body = null

func discard():
    if body.has_weapon(): body.equip_weapon(null, false)
    queue_free()

const DROP_FORCE: float = 75.
const DROP_TORQUE: float = 10.
func drop(traincar: Traincar, dir: Vector2, unpickable: bool = false):
    var pickup: Pickup = traincar.spawn_pickup(weapon_resource, body.global_position)
    pickup.apply_impulse(dir * DROP_FORCE)
    pickup.apply_torque_impulse(randf_range(-1, 1) * DROP_TORQUE)
    if unpickable:
        pickup.set_unpickable()

func _input(event: InputEvent) -> void:
    if entity is not Player: return
    if not is_inside_tree(): return
    if event.is_action_pressed(&"shoot"):
        fire()

const BULLET_SCENE: PackedScene = preload("res://scenes/bullet.tscn")
func fire():
    var traincar: Traincar = entity.get_current_traincar()
    if not can_fire(traincar):
        if body.entity is Player: play_invalid.play()
        return

    var bullet: Bullet = BULLET_SCENE.instantiate()
    traincar.make_noise(self, &"weapon")
    
    var initial_targets: Array[CharacterEntity] = traincar.get_targetable_entities(entity)
    var initial_target: CharacterEntity
    if initial_targets.size() == 1:
        initial_target = initial_targets[0]
    else:
        # This should not make a difference for enemies, for players prefer targets closer to the mouse
        var mouse_position: Vector2 = get_global_mouse_position()
        var distances: Array[float] = []
        distances.assign(initial_targets.map(func(t): return t.global_position.distance_squared_to(mouse_position)))
        var indices: Array[int] = [] 
        indices.assign(range(initial_targets.size()))
        var closest_idx: int = indices.reduce(
            func(acc: int, val: int):
                if distances[val] < distances[acc]:
                    return val
                else: return acc, 
            0)
        initial_target = initial_targets[closest_idx]
    play_fire_sound(traincar)
    traincar.add_entity(bullet, muzzle)
    bullet.set_target(initial_target)
    discard()

func can_fire(traincar: Traincar) -> bool:
    if \
    not traincar.in_play_area(body.global_position) or \
    not traincar.in_play_area(muzzle.global_position):
        return false
    checker.target_position = checker.to_local(body.global_position)
    checker.force_raycast_update()
    if not checker.is_colliding(): return false
    var collider: Object = checker.get_collider()
    return collider is CharacterEntity

func play_fire_sound(traincar: Traincar):
    remove_child(play_fire)
    traincar.add_child(play_fire)
    play_fire.pitch_scale = randf_range(0.5, 1.5)
    play_fire.play()
    await play_fire.finished
    traincar.remove_child(play_fire)
    play_fire.queue_free()