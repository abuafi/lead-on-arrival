extends BehaviourDecorator
class_name InterruptOnSignal

@export var awaiting: StringName

func enter() -> void:
    super.enter()
    child.passed.connect(node_passed, ConnectFlags.CONNECT_ONE_SHOT)
    child.failed.connect(node_failed, ConnectFlags.CONNECT_ONE_SHOT)
    entity.connect(
        awaiting, 
        _on_signal_emitted,
        ConnectFlags.CONNECT_ONE_SHOT)

func exit():
    super.exit()
    if child.is_connected(awaiting, _on_signal_emitted):
        child.disconnect(awaiting, _on_signal_emitted)

func _on_signal_emitted(_arg):
    node_passed()