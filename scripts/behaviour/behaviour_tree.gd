extends Node
class_name BehaviourTree

@onready var entity: CharacterEntity = $".."
@onready var current: BehaviourNode = get_child(0) :
    set(n):
        if is_instance_valid(current): current.active = false
        current = n
        # print(current)
        if is_instance_valid(current):
            current.active = true
            _connect_once(current.post_finish, _on_node_finished)

@onready var path_to_node: Array[BehaviourNode] = []

func _ready():
    current.setup(entity)
    current = current

func transition_to_next(node: BehaviourNode):
    if not is_instance_valid(node): return 
    # print(current, " -> ", node)
    # print(path_to_node)
    path_to_node.append(current)
    # print(path_to_node)
    current = node

func transition_upper(node: BehaviourNode):
    var idx: int = path_to_node.find(node)
    # print(node, " <- ", current)
    # print(path_to_node, " ", idx)
    for i: int in range(idx + 1, path_to_node.size()):
        var lower_node: BehaviourNode = path_to_node[i]
        lower_node.exit()
    path_to_node = path_to_node.slice(0, idx)
    # print(path_to_node)
    current.exit()
    current = node

func _on_node_finished(node: BehaviourNode):
    transition_upper(node.get_parent())

func _physics_process(delta):
    if not is_instance_valid(current): return

    if not current.entered: 
        current.enter()
    transition_to_next(current.bt_next())

    if current.active: current.bt_physics_process(delta)

func _connect_once(_signal: Signal, _callback: Callable):
    if not _signal.is_connected(_callback):
        _signal.connect(
            _callback,
            ConnectFlags.CONNECT_ONE_SHOT
        )