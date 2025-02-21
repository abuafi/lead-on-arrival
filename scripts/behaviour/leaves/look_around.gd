# Face towards the detected player.
extends BehaviourLeaf
class_name LookAround

var start_rotation: float
var rotation_performed: float

@export var speed: float = PI
@export var rotation_clockwise: bool = true
@export var rotation_amount: float = TAU

func enter() -> void:
    super.enter()
    start_rotation = INF
    rotation_performed = 0.

func exit() -> void:
    super.exit()
    start_rotation = INF
    rotation_performed = 0.

func rotation_cw() -> float:
    return start_rotation + rotation_performed

func rotation_ccw() -> float:
    return start_rotation - rotation_performed

func bt_physics_process(_delta: float) -> void:
    if not is_finite(start_rotation):
        start_rotation = body.torso_rotation
    super.bt_physics_process(_delta)
    rotation_performed += (speed * _delta)
    if rotation_performed >= rotation_amount:
        rotation_performed = rotation_amount

    var current_rotation: float = rotation_cw() if rotation_clockwise else rotation_ccw()
    current_rotation = fmod(current_rotation, TAU)

    var rotated: Vector2 = Vector2.DOWN.rotated(current_rotation)
    body.set_target_position(
        rotated, 
        _delta)
    if is_equal_approx(rotation_performed, rotation_amount):
        node_passed()