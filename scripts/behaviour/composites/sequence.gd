# Iterates over children nodes until one fails
extends BehaviourComposite
class_name Sequence

func bt_next() -> BehaviourNode:
    # print(self, " ", current_idx, " / ", children.size())
    if current_idx == children.size(): 
        node_passed()
        return null
    var next: BehaviourNode = super.bt_next()
    next.failed.connect(
        child_failed,
        ConnectFlags.CONNECT_ONE_SHOT)
    return next

func child_failed(_child: BehaviourNode):
    node_failed()