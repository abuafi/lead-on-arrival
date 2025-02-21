# Face towards the detected player.
extends BehaviourLeaf
class_name FacePlayer

const ROTATION_TOLERANCE: float = 0.01
func bt_physics_process(_delta: float) -> void:
    if not is_instance_valid(entity.detected_player): 
        node_failed()
        return
    var target_player: Player = entity.detected_player
    body.set_target_position_global(
        target_player.global_position, 
        _delta)
    var rotation_error: float = body.rotation_error()
    if abs(rotation_error) < ROTATION_TOLERANCE:
        node_passed()
