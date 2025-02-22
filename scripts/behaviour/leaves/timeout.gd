extends BehaviourLeaf
class_name Timeout

@export var time: float = 0.5
var timer: SceneTreeTimer

func enter() -> void:
    super.enter()
    timer = get_tree().create_timer(time, false)
    timer.timeout.connect(_on_timeout)

func exit() -> void:
    if is_instance_valid(timer) and \
    timer.timeout.is_connected(_on_timeout):
        timer.timeout.disconnect(_on_timeout)

func _on_timeout():
    node_passed()