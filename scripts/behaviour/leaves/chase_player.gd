# Chase the detected player.
extends BehaviourLeaf
class_name ChasePlayer

func enter(): 
    super.enter()

const SPEED: float = 150.0
func bt_physics_process(_delta: float) -> void:
    var target_player: Player = entity.detected_player
    if not is_instance_valid(target_player): 
        node_failed()
        return
    nav.target_position = target_player.global_position
    var next_pos: Vector2 = nav.get_next_path_position()
    body.set_target_position_global(next_pos, _delta)
    var dir: Vector2 = next_pos - global_position
    entity.velocity = dir.normalized() * SPEED

func exit():
    super.exit()
    entity.velocity = Vector2.ZERO