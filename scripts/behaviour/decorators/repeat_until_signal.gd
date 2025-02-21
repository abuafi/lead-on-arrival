extends BehaviourDecorator
class_name RepeatUntilSignal

@export var awaiting: StringName

func enter() -> void:
    super.enter()
    entity.body.connect(
        awaiting, 
        _on_signal_emitted,
        ConnectFlags.CONNECT_ONE_SHOT)

func exit():
    super.exit()
    if child.is_connected(awaiting, _on_signal_emitted):
        child.disconnect(awaiting, _on_signal_emitted)

func _on_signal_emitted():
    node_passed()
