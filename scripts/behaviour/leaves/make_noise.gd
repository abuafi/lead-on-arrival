extends BehaviourLeaf
class_name MakeNoise

func enter() -> void:
    super.enter()
    entity.make_noise()
    node_passed()