extends BehaviourLeaf
class_name DetectedPlayer

func enter() -> void:
    super.enter()
    if entity is Enemy and entity.detected_player: node_passed()
    else: node_failed()