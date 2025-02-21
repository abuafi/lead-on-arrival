extends BehaviourDecorator
class_name Inverted

func enter() -> void:
    super.enter()
    child.passed.connect(_node_passed, ConnectFlags.CONNECT_ONE_SHOT)
    child.failed.connect(_node_failed, ConnectFlags.CONNECT_ONE_SHOT)

func _node_failed(_arg: BehaviourNode):
    node_passed()

func _node_passed(_arg: BehaviourNode):
    node_failed()