extends BehaviourLeaf
class_name HasWeapon

func enter() -> void:
    super.enter()
    if body.has_weapon(): node_passed()
    else: node_failed()