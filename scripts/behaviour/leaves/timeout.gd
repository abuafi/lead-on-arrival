extends BehaviourLeaf
class_name Timeout

@export var time: float = 0.5

func enter() -> void:
    super.enter()
    var timer: SceneTreeTimer = get_tree().create_timer(time, false)
    timer.timeout.connect(_on_timeout)

func _on_timeout():
    node_passed()