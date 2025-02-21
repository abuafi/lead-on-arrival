# Passes if a player is currently in the detection area.
extends BehaviourLeaf
class_name SeesPlayer

func enter():
    super.enter()
    if not is_instance_valid(detection_area): 
        await entity.ready
        node_failed()
        return
    if is_instance_valid(detection_area.seen()): 
        var player: Player = detection_area.seen()
        entity.detected_player = player
        node_passed()
    else: node_failed()
