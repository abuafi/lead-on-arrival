# Iterates over children nodes until one succeeds
extends BehaviourComposite
class_name Selector

func bt_next() -> BehaviourNode:
    # print(self, " ", current_idx, " / ", children.size())
    if current_idx == children.size(): 
        node_failed()
        return null
    var next: BehaviourNode = super.bt_next()
    next.passed.connect(
        child_passed,
        ConnectFlags.CONNECT_ONE_SHOT)
    return next

func child_passed(_child: BehaviourNode):
    node_passed()