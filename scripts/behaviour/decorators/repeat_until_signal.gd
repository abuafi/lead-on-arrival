extends BehaviourDecorator
class_name RepeatUntilSignal

@export var awaiting: StringName

func enter() -> void:
    super.enter()
    entity.connect(
        awaiting, 
        _on_signal_emitted,
        ConnectFlags.CONNECT_ONE_SHOT)

func exit():
    super.exit()
    if entity.is_connected(awaiting, _on_signal_emitted):
        entity.disconnect(awaiting, _on_signal_emitted)

func _on_signal_emitted(_arg):
    node_passed()
