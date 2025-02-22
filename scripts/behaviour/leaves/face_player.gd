# Face towards the detected player.
extends BehaviourLeaf
class_name FacePlayer

const ROTATION_TOLERANCE: float = 0.1
func bt_physics_process(_delta: float) -> void:
    if not is_instance_valid(entity.detected_player): 
        node_failed()
        return

    var current_nav: NavigationAgent2D = nav
    if body.has_weapon(): current_nav = body.get_weapon().bullet_nav
    var target_player: Player = entity.detected_player
    current_nav.target_position = target_player.global_position
    var target_position: Vector2 = current_nav.get_next_path_position()
    body.set_target_position_global(
        target_position, 
        _delta)
    var rotation_error: float = body.rotation_error()
    if abs(rotation_error) < ROTATION_TOLERANCE:
        node_passed()
