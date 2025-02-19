extends Node2D
class_name Body

@onready var head: Head = $Head
@onready var torso: Node2D = $Torso

const ROTATION_SPEED: float = 15.

func set_target_position(target_position: Vector2, delta: float):
    target_position = target_position.normalized()
    var angle_to_target: float = atan2(target_position.y, target_position.x)
    angle_to_target -= PI/2
    head.set_rotation_angle(angle_to_target)
    torso.rotation = lerp_angle(torso.rotation, angle_to_target, delta * ROTATION_SPEED)

func set_target_position_global(target_position: Vector2, delta: float):
    var local_target_position = target_position - global_position
    set_target_position(local_target_position, delta)