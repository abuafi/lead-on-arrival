# Face towards the detected player.
extends BehaviourLeaf
class_name LookSweep

var start_rotation: float = INF
var rotation_performed: float = 0

@export var speed: float = PI
@export var rotation_total_amount: float = TAU

func enter() -> void:
    super.enter()
    step = 0

func exit() -> void:
    super.exit()
    step = 0

func rotation_cw() -> float:
    return start_rotation + rotation_performed

func rotation_ccw() -> float:
    return start_rotation - rotation_performed

func bt_physics_process(_delta: float) -> void:
    if not is_finite(start_rotation):
        start_rotation = body.torso_rotation
    super.bt_physics_process(_delta)
    if step == 0: rotate_cw(_delta, rotation_total_amount / 2)
    elif step == 1: wait_until(0.5, _delta)
    elif step == 2: rotate_ccw(_delta, rotation_total_amount / 2)
    elif step == 3: wait_until(0.5, _delta)
    elif step == 4: rotate_ccw(_delta, rotation_total_amount / 2)
    elif step == 5: wait_until(0.5, _delta)
    elif step == 6: rotate_cw(_delta, rotation_total_amount / 2)
    else: node_passed()

var start_time: float = 0.
func wait_until(time: float, _delta: float):
    start_time += _delta
    if start_time >= time:
        step += 1

var step: int = 0 : 
    set(s):
        step = s
        rotation_performed = 0.
        start_rotation = INF
        start_time = 0

func rotate_cw(_delta, rotation_amount):
    rotation_performed += (speed * _delta)
    if rotation_performed >= rotation_amount:
        rotation_performed = rotation_amount

    var current_rotation: float = rotation_cw()
    current_rotation = fmod(current_rotation, TAU)

    var rotated: Vector2 = Vector2.DOWN.rotated(current_rotation)
    body.set_target_position(
        rotated, 
        _delta)
    if rotation_performed == rotation_amount:
        step += 1

func rotate_ccw(_delta, rotation_amount):
    rotation_performed += (speed * _delta)
    if rotation_performed >= rotation_amount:
        rotation_performed = rotation_amount

    var current_rotation: float = rotation_ccw()
    current_rotation = fmod(current_rotation, TAU)

    var rotated: Vector2 = Vector2.DOWN.rotated(current_rotation)
    body.set_target_position(
        rotated, 
        _delta)
    if rotation_performed == rotation_amount:
        step += 1