extends BehaviourLeaf
class_name GoToPickup

func enter(): 
    super.enter()
    entity.picked_weapon.connect(_on_picked_weapon, ConnectFlags.CONNECT_ONE_SHOT)

func exit():
    super.exit()
    if entity.picked_weapon.is_connected(_on_picked_weapon):
        entity.picked_weapon.disconnect(_on_picked_weapon)
    entity.velocity = Vector2.ZERO

func _on_picked_weapon(_weapon: Weapon):
    node_passed()

const SPEED: float = 150.0
func bt_physics_process(_delta: float) -> void:
    if not is_instance_valid(entity.target_pickup): 
        node_failed()
        return
    var target_pickup: Pickup = entity.target_pickup
    nav.target_position = target_pickup.global_position
    var next_pos: Vector2 = nav.get_next_path_position()
    body.set_target_position_global(next_pos, _delta)
    var dir: Vector2 = next_pos - global_position
    entity.velocity = dir.normalized() * SPEED
