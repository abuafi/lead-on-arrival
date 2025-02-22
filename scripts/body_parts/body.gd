extends Node2D
class_name Body

@onready var head: Head = $Head
@onready var torso: Node2D = $Torso
@onready var legs: Legs = $Legs
@onready var arms: Arms = $Arms
@onready var entity: CharacterEntity = $".."

var angle_to_target: float

const ROTATION_SPEED: float = 15.
const ARM_ROTATION_SPEED: float = 30.

func set_target_position(target_position: Vector2, delta: float):
    target_position = target_position.normalized()
    angle_to_target = atan2(target_position.y, target_position.x)
    angle_to_target -= PI/2
    head.set_rotation_angle(angle_to_target)
    var torso_angle: float = lerp_angle(torso_rotation, angle_to_target, delta * ROTATION_SPEED)
    torso_rotation = torso_angle
    legs.global_rotation = torso_angle
    arms.global_rotation = lerp_angle(arms.global_rotation, torso_angle, delta * ARM_ROTATION_SPEED)

func set_target_position_global(target_position: Vector2, delta: float):
    var local_target_position = target_position - global_position
    set_target_position(local_target_position, delta)

func set_velocity(velocity: Vector2):
    legs.moving = not is_zero_approx(velocity.length_squared())
    velocity = velocity.normalized()
    var rotated_velocity = velocity.rotated(-torso_rotation)
    legs.invert = rotated_velocity.y < 0

var torso_wobble: float = 0 :
    set(w):
        torso_wobble = w
        torso.global_rotation = torso_rotation + torso_wobble
var torso_rotation: float :
    set(r):
        torso_rotation = r
        torso.global_rotation = r + torso_wobble
    get(): return torso.global_rotation - torso_wobble

func set_torso_wobble(angle: float):
    torso_wobble = angle
    pass

func equip_weapon(weapon: Weapon, throw: bool = false):
    if is_instance_valid(weapon):
        weapon.entity = entity
        weapon.body = self
    var old_weapon = get_weapon()
    if is_instance_valid(old_weapon) and throw: 
        old_weapon.drop(
            entity.get_current_traincar(),
            Vector2.DOWN.rotated(torso_rotation),
            true
        )
    arms.set_weapon(weapon)
    
func has_weapon() -> bool:
    return arms.has_weapon()
func get_weapon() -> Weapon:
    return arms.get_weapon()

func rotation_error() -> float:
    return angle_difference(
        arms.global_rotation,
        angle_to_target
    )
    
func drop_weapon(direction: Vector2, unpickable: bool = false):
    arms.drop_weapon(direction, unpickable)