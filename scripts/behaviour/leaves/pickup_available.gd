extends BehaviourLeaf
class_name PickupAvailable

func enter() -> void:
    super.enter()
    if not entity is Enemy: node_failed()
    var traincar: Traincar = entity.get_current_traincar()
    if traincar.has_pickup(): 
        entity.target_pickup = traincar.closest_pickup(entity.global_position)
        node_passed()
    else: node_failed()