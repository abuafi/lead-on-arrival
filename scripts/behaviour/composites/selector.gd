# Iterates over children nodes until one succeeds
extends BehaviourComposite
class_name Selector

func bt_next() -> BehaviourNode:
    # print(self, " ", current_idx, " / ", children.size())
    if current_idx == children.size(): 
        node_failed()
        return null
    var next: BehaviourNode = super.bt_next()
    if not next.passed.is_connected(child_passed):
        next.passed.connect(
            child_passed,
            ConnectFlags.CONNECT_ONE_SHOT)
    return next

func exit():
    super.exit()
    for child: BehaviourNode in children:
        if child.passed.is_connected(child_passed):
            child.passed.disconnect(child_passed)

func child_passed(_child: BehaviourNode):
    node_passed()