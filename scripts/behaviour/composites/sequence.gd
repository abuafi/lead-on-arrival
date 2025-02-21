# Iterates over children nodes until one fails
extends BehaviourComposite
class_name Sequence

func bt_next() -> BehaviourNode:
    # print(self, " ", current_idx, " / ", children.size())
    if current_idx == children.size(): 
        node_passed()
        return null
    var next: BehaviourNode = super.bt_next()
    if not next.failed.is_connected(child_failed):
        next.failed.connect(
            child_failed,
            ConnectFlags.CONNECT_ONE_SHOT)
    return next

func exit():
    super.exit()
    for child: BehaviourNode in children:
        if child.failed.is_connected(child_failed):
            child.failed.disconnect(child_failed)

func child_failed(_child: BehaviourNode):
    node_failed()