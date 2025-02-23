extends BehaviourLeaf
class_name FollowNoise

func enter(): 
    super.enter()

const SPEED: float = 150.0
const MIN_DISTANCE: float = 80.
func bt_physics_process(_delta: float) -> void:
    if entity is not Enemy or not entity.has_heard_noise(): 
        node_failed()
        return

    var target_position: Vector2 = entity.last_heard_noise
    if global_position.distance_to(target_position) < MIN_DISTANCE:
        node_passed()
        return
    
    nav.target_position = target_position
    var next_pos: Vector2 = nav.get_next_path_position()
    body.set_target_position_global(next_pos, _delta)
    var dir: Vector2 = next_pos - global_position
    entity.velocity = dir.normalized() * SPEED

func exit():
    super.exit()
    entity.velocity = Vector2.ZERO