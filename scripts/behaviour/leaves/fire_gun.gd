extends BehaviourLeaf
class_name FireGun

func enter() -> void:
    super.enter()
    if body.has_weapon(): 
        body.get_weapon().fire()
        node_passed()
    else: node_failed()