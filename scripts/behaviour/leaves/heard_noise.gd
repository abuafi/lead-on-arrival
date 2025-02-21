extends BehaviourLeaf
class_name HeardNoise

func enter() -> void:
    super.enter()
    if entity is Enemy and entity.has_heard_noise(): node_passed()
    else: node_failed()