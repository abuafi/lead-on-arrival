extends BehaviourDecorator
class_name Ignore

func enter() -> void:
    super.enter()
    if not child.passed.is_connected(_node_passed):
        child.passed.connect(_node_passed, ConnectFlags.CONNECT_ONE_SHOT)
    if not child.failed.is_connected(_node_failed):
        child.failed.connect(_node_failed, ConnectFlags.CONNECT_ONE_SHOT)

func _node_failed(_arg: BehaviourNode):
    node_passed()

func _node_passed(_arg: BehaviourNode):
    node_passed()