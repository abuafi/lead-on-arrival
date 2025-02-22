extends Node2D
class_name Weapon

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var muzzle: Marker2D = $Muzzle

var weapon_resource: PackedEquippablePickup = null

var entity: CharacterEntity = null
var body: Body = null

func discard():
    if body.has_weapon(): body.equip_weapon(null, false)
    queue_free()

const DROP_FORCE: float = 75.
func drop(traincar: Traincar, dir: Vector2, unpickable: bool = false):
    var pickup: Pickup = traincar.spawn_pickup(weapon_resource, body.global_position)
    pickup.apply_impulse(dir * DROP_FORCE)
    if unpickable:
        pickup.set_unpickable()

func _input(event: InputEvent) -> void:
    if entity is not Player: return
    if not is_inside_tree(): return
    if event.is_action_pressed(&"shoot"):
        fire()

const BULLET_SCENE: PackedScene = preload("res://scenes/bullet.tscn")
func fire():
    var bullet: Bullet = BULLET_SCENE.instantiate()
    var traincar: Traincar = entity.get_current_traincar()
    traincar.make_noise(self)
    
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

func play_fire_sound(traincar: Traincar):
    remove_child(audio)
    traincar.add_child(audio)
    audio.pitch_scale = randf_range(0.5, 1.5)
    audio.play()
    await audio.finished
    traincar.remove_child(audio)
    audio.queue_free()