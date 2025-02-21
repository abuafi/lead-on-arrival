extends BehaviourNode
class_name BehaviourLeaf

var position: Vector2 : 
    get(): return entity.position
var global_position: Vector2 : 
    get(): return entity.global_position
var body: Body : 
    get(): return entity.body
var nav: NavigationAgent2D : 
    get(): return entity.nav
var detection_area: DetectionArea : 
    get(): return entity.detection_area

func setup(_entity) -> void:
    super.setup(_entity)
    tree_exiting.connect(
        destructor,
        ConnectFlags.CONNECT_ONE_SHOT)

func destructor() -> void:
    pass