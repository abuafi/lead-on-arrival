extends BehaviourNode
class_name BehaviourComposite

var children: Array[BehaviourNode] = []
var current_idx = 0

func setup(_entity: CharacterEntity) -> void:
    super.setup(_entity)
    var children_nodes: Array[Node] = get_children()
    children.assign(children_nodes.filter(func(node):
        return node is BehaviourNode
    ))
    for child: BehaviourNode in children:
        child.setup(_entity)

func enter():
    # print("composite entered ", self)
    super.enter()
    current_idx = 0

func exit():
    super.exit()
    # print("composite exited ", self)

func bt_next() -> BehaviourNode:
    var next: BehaviourNode = children[current_idx]
    current_idx += 1
    return next