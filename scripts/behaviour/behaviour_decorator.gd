extends BehaviourNode
class_name BehaviourDecorator

var child: BehaviourNode

func setup(_entity: CharacterEntity) -> void:
    super.setup(_entity)
    child = get_child(0)
    child.setup(_entity)

func bt_next() -> BehaviourNode:
    return child