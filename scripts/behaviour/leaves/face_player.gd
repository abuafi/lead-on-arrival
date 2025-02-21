# Face towards the detected player.
extends BehaviourLeaf
class_name FacePlayer

const ROTATION_TOLERANCE: float = 0.001
func bt_physics_process(_delta: float) -> void:
    var target_player: Player = entity.detected_player
    if not is_instance_valid(target_player): 
        node_failed()
        return
    body.set_target_position_global(
        target_player.global_position, 
        _delta)
    var rotation_error: float = body.rotation_error()
    if rotation_error < ROTATION_TOLERANCE:
        node_passed()