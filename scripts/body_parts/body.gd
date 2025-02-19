extends Node2D
class_name Body

@onready var head: Head = $Head
@onready var torso: Node2D = $Torso
@onready var legs: Legs = $Legs
@onready var arms: Arms = $Arms
@onready var entity: CharacterEntity = $".."

const ROTATION_SPEED: float = 15.
const ARM_ROTATION_SPEED: float = 30.

func set_target_position(target_position: Vector2, delta: float):
    target_position = target_position.normalized()
    var angle_to_target: float = atan2(target_position.y, target_position.x)
    angle_to_target -= PI/2
    head.set_rotation_angle(angle_to_target)
    var torso_angle: float = lerp_angle(torso_rotation, angle_to_target, delta * ROTATION_SPEED)
    torso_rotation = torso_angle
    legs.rotation = torso_angle
    arms.rotation = lerp_angle(arms.rotation, torso_angle, delta * ARM_ROTATION_SPEED)

func set_target_position_global(target_position: Vector2, delta: float):
    var local_target_position = target_position - global_position
    set_target_position(local_target_position, delta)

func set_velocity(velocity: Vector2):
    legs.moving = not is_zero_approx(velocity.length_squared())

var torso_wobble: float = 0 :
    set(w):
        torso_wobble = w
        torso.rotation = torso_rotation + torso_wobble
var torso_rotation: float :
    set(r):
        torso_rotation = r
        torso.rotation = r + torso_wobble
    get(): return torso.rotation - torso_wobble

func set_torso_wobble(angle: float):
    torso_wobble = angle
    pass

func equip_weapon(weapon: Weapon):
    print(entity)
    weapon.entity = entity
    weapon.body = self
    arms.set_weapon(weapon)
